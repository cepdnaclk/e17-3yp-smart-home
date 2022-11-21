let devices = require('../models/devices')
const nodeSchedule = require('node-schedule')

require("events").EventEmitter.defaultMaxListners = 70;

let mqtt = require('mqtt');
const clientId = "digitalHut"
const options = {
    clientId,
}

process.env.TZ = "Asia/Calcutta";




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
            const clientId = "digitalHut_plug"
                const options = {
                    clientId,
                }
            let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
            devices.findByIdAndUpdate(req.body.deviceid, {status: state}, (err, doc)=>{
                if (err) return res.json({ success: false, msg: err.message })
                
                client.on('connect', function () {
                    console.log('connect');
                    let plug = { port: req.body.port, state: state, d_t: 2 }; //d_t --> Device type plug-->2
                    
                    client.publish('esp32/sub', JSON.stringify(plug), (error) => {
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
            console.log('catch e');
            return res.status(404).json({
				success: false,
				error: e.message,
            });
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
            devices.findByIdAndUpdate(req.body.deviceid, { status: state, StartTime: Date.now() , brightness:req.body.brightness, r:r, g:g, b:b }, (err, doc) => {
                // If error happen
                if (err) return res.status(404).json({ success: false, msg: err.message });
                if (!doc) return res.status(404).json({ success: false, msg: "Device Not found!" });
                // If the device found
                const clientId = "digitalHut_RGB"
                const options = {
                    clientId,
                }
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
                !req.body.EndTime,
                !req.body.d_t
            ) {
                return res.json({ success: false, msg: "Enter All the  feilds for scheule" });
            }
            console.log(req.body.StartTime, req.body.EndTime);
            let state = (req.body.schedulestate == "true");
            let StartTime = new Date(req.body.StartTime);
            let EndTime = new Date(req.body.EndTime);

            devices.findByIdAndUpdate(req.body.deviceid, { schedule: req.body.state, StartTime: StartTime, EndTime: EndTime }, (err, doc) => {
                if (err) return res.status(404).json({ success: false, msg: err.message });
                if (!doc) return res.status(404).json({ success: false, msg: "Device Not found!" });
                const clientId = "digitalHut_Scheduler"
                const options = {
                    clientId,
                }
                let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
                client.setMaxListeners(Infinity);
                if (state) {
                    console.log(StartTime.getMinutes(), StartTime.getHours());
                    nodeSchedule.scheduleJob(req.body.deviceid + "start", `* ${StartTime.getMinutes()} ${StartTime.getHours()} * * *`, () => {
                        client.on('connect', function () {
                            console.log('Start Schedule');
                            client.publish('esp32/sub', JSON.stringify({ state: true, port: req.body.port, d_t: req.body.d_t }), (error) => {
                                if (error) {
                                    console.log(error.message);
                                    client.end();
                                    // return res.status(404).json({ success: false, msg: error.message });
                                }
                                else {
                                    client.end();
                                    console.log('send');
                                    // return res.json({ success: true, msg: "successfully Turned On!", device: doc });
                                }
                            });
                        });
                    });
                    console.log(client.removeAllListeners('connect'));
                    console.log(EndTime.getMinutes(), EndTime.getHours());
                    nodeSchedule.scheduleJob(req.body.deviceid + "end", `* ${EndTime.getMinutes()} ${EndTime.getHours()} * * *`, () => {
                        
                        client.on('connect', function () {
                            console.log('End Schedule');
                            client.publish('esp32/sub', JSON.stringify({state:false, port:req.body.port, d_t:req.body.d_t }), (error) => {
                                if (error) {
                                    console.log(error.message);
                                    client.end();
                                    // return res.status(404).json({ success: false, msg: error.message });
                                }
                                else {
                                    client.end();
                                    console.log('send');
                                    // return res.json({ success: true, msg: "successfully Turned On!", device: doc });
                                }
                            });
                        });
                    })
                } else {
                    
                    let startS = nodeSchedule.scheduledJobs[req.body.deviceid + "start"];
                    let endS = nodeSchedule.scheduledJobs[req.body.deviceid + "end"];
                    console.log( endS)
                    if (startS != undefined) {
                        startS.cancel();
                        endS.cancel();
                        console.log('Cleared...');
                    }
                    
                }
            })
            return res.status(200).json({ success: true, msg: "Schedule Successfully!" });
        } catch (e) {
            console.log(e.message);
            return res.json({success:false, msg: e.message})
        }
    },
    // For testing the publishing
    // testPub: async function (req, res) {
    //     try {
    //         console.log(req.body.name, req.body.topic);
    //         let topic = req.body.topic
    //         let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
    //         client.on('connect', ()=> {
    //             console.log('connect');
    //             client.publish(topic, JSON.stringify({ devicename: 1 }),
    //                 (error) => { 
    //                     if (error) {
    //                         console.log(error)
    //                         client.end();
    //                         return res.json({ success: false, msg: "Error in publishing" });
    //                     } else {
    //                         client.end();
    //                         return res.json({ success: true, msg: "Msg published successfully" });
    //                     }
    //                 });
    //         });
    //     } catch (e) {
    //         console.log(`Error catched in testPub ${e.message}`)
    //         return res.json({
	// 			success: false,
	// 			msg: 'Error on testPub try catch',
	// 			error: err.message,
    //         });
    //     }
    // },
    // // For testing subcribtion
    // testsub: async function (req, res) {
    //     try {
    //         let topic = req.body.topic;
    //         let client = mqtt.connect("mqtt://127.0.0.1:1883", options);``
    //         client.on('connect', () => {
    //             console.log('Connected')
    //         client.subscribe([topic])
    //         client.on('message', function (topic, message) {
    //         console.log(message.toString());
    //         })
    // })
    //     } catch (e) {
    //         console.log(e.message);
    //         return res.json({success:false, msg: e.message})
    //     }
    // },


}

module.exports = functions