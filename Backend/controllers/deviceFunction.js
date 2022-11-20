let devices = require('../models/devices')
const nodeSchedule = require('node-schedule')

let mqtt = require('mqtt');
const clientId = "digitalHut"
const options = {
    clientId,
}

let functions ={
    plugTurnOn: async function(req, res){
        try {
            if(
            !req.body.port,
            !req.body.deviceid,
            !req.body.state
            )
        {
            return res.json({ success: false, msg: "Enter All feilds for Smart Plugd" });
            }
            console.log(req.body.state);
            let state = (req.body.state == 'true');
            devices.findByIdAndUpdate(req.body.deviceid, {status: state}, (err, doc)=>{
                if (err) return res.json({ success: false, msg: err.message })
                let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
                client.on('connect', function () {
                    console.log('connect');
                    let plug = { port: req.body.port, state: state, d_t: 2 }; //d_t --> Device type plug-->2
                    
                    client.publish('esp32/sub/', JSON.stringify(plug), (error) => {
                        if (!error) {
                            client.end();
                            return res.json({success:true, msg: "successfully state Changed!", device:plug })
                        }
                        else {
                            client.end();
                            return res.json({ success: false, msg: error.message });
                        }
                    });
                });
                
            } )
        }catch(err){
            return res.json({
				success: false,
				msg: 'Error on turnOn try catch',
				error: err.message,
			});
        }
    }, 
    deviceStatus: async function (req, res) {
        try {
            if (req.body.deviceid) {
                devices.findById(req.body.deviceid, (err, doc) => {
                    // If error happen
                    if (err) return res.status(404).json({ success: false, msg: err.message });
                    if (!doc) return res.status(404).json({ success: false, msg: "Device Not found!" });
                    // If the device found
                    return res.json({ success: true, device: doc});
                    
                })
            } else {
                return res.json({ success: false, msg: "Enter the device_id" });
            }
        } catch (e) {
            
        }
    },

    rgbTurnOn: async function(req, res) 
    {
        try {
            if (
                !req.body.r,
                !req.body.g,
                !req.body.b,
                !req.body.brightness,
                !req.body.port,
                !req.body.deviceid,
                !req.body.state
            ) {
                return res.json({ success: false, msg: "Enter All feilds for RGB" });
            }
            let r = req.body.r;
            let g = req.body.g;
            let b = req.body.b;
            let state = (req.body.state == "true")
            devices.findByIdAndUpdate(req.body.deviceid, { status: req.body.state, StartTime: Date.now() , brightness:req.body.brightness, r:r, g:g, b:b }, (err, doc) => {
                // If error happen
                if (err) return res.status(404).json({ success: false, msg: err.message });
                if (!doc) return res.status(404).json({ success: false, msg: "Device Not found!" });
                // If the device found
            
            let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
            let dev ={state:state, brtns: req.body.brightness, port: parseInt(req.body.port), d_t: 1, r:r, g:g, b:b }
            console.log("Device Found")
                client.on('connect', function () {
                    console.log('connect');
                    client.publish('esp32/sub', JSON.stringify(dev), (error) => {
                        if (error) {
                            console.log(error.message);
                            client.end();
                            return res.status(404).json({ success: false, msg: error.message });
                        }
                        else {
                            client.end();
                            console.log('send');
                            return res.json({ success: true, msg: "successfully Turned On!", device: dev });
                        }
                    });
                });
            })
            return res.json({ success: true, msg: "Schedule Successfully! "});
        } catch (e) {
            console.log('catch e');
            return res.status(404).json({
				success: false,
				error: e.message,
            });
    }   
    },
        // Schuduling the Devices in the applications
    scheduleDevice : async function (req, res) {
        try {
            if (!req.body.schedulestate,
                !req.body.deviceid,
                !req.body.port,
                !req.body.StartTime,
                !req.body.EndTime
            ) {
                return res.json({ success: false, msg: "Enter All the  feilds for scheule" });
            }
            devices.findByIdAndUpdate(req.body.deviceid, { schedule: req.body.schedulestate, StartTime: req.body.StartTime, EndTime: req.body.EndTime }, (err, doc) => {
                if (err) return res.status(404).json({ success: false, msg: err.message });
                if (!doc) return res.status(404).json({ success: false, msg: "Device Not found!" });
                let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
                nodeSchedule.scheduleJob(StartTime, () => {
                    client.on('connect', function () {
                        console.log('connect');
                        client.publish('esp32/sub', JSON.stringify({state:true}), (error) => {
                            if (error) {
                                console.log(error.message);
                                client.end();
                                return res.status(404).json({ success: false, msg: error.message });
                            }
                            else {
                                client.end();
                                console.log('send');
                                return res.json({ success: true, msg: "successfully Turned On!", device: doc });
                            }
                        });
                    });
                })
                nodeSchedule.scheduleJob(EndTime, () => {
                    client.on('connect', function () {
                        console.log('connect');
                        client.publish('esp32/sub', JSON.stringify({state:false}), (error) => {
                            if (error) {
                                console.log(error.message);
                                client.end();
                                return res.status(404).json({ success: false, msg: error.message });
                            }
                            else {
                                client.end();
                                console.log('send');
                                return res.json({ success: true, msg: "successfully Turned On!", device: doc });
                            }
                        });
                    });
                })
            })
        } catch (e) {
            console.log(e.message);
            return res.json({success:false, msg: e.message})
        }
    },
    // For testing the publishing
    testPub: async function (req, res) {
        try {
            console.log(req.body.name, req.body.topic);
            let topic = req.body.topic
            let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
            client.on('connect', ()=> {
                console.log('connect');
                client.publish(topic, JSON.stringify({ devicename: 1 }),
                    (error) => { 
                        if (error) {
                            console.log(error)
                            client.end();
                            return res.json({ success: false, msg: "Error in publishing" });
                        } else {
                            client.end();
                            return res.json({ success: true, msg: "Msg published successfully" });
                        }
                    });
            });
        } catch (e) {
            console.log(`Error catched in testPub ${e.message}`)
            return res.json({
				success: false,
				msg: 'Error on testPub try catch',
				error: err.message,
            });
        }
    },
    // For testing subcribtion
    testsub: async function (req, res) {
        try {
            let topic = req.body.topic;
            let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
            client.on('connect', () => {
                console.log('Connected')
            client.subscribe([topic])
            client.on('message', function (topic, message) {
            console.log(message.toString());
            })
    })
        } catch (e) {
            console.log(e.message);
            return res.json({success:false, msg: e.message})
        }
    },


}

module.exports = functions