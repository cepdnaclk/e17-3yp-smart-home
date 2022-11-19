let homes = require('../models/homes')
let devices = require('../models/devices')
let rooms = require('../models/rooms')

let mqtt = require('mqtt');
const clientId = "digitalHut_smartBulb"
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
            return res.json({ success: false, msg: "Enter All feilds for Smart Plugd]" });
        }
            devices.findByIdAndUpdate(req.body.deviceid, {status: state, StartTime:Date.now()}, (err, doc)=>{
                if (err) return res.json({ success: false, msg: err.message })
                let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
                client.on('connect', function () {
                    console.log('connect');
                    client.publish('esp32/sub/', JSON.stringify({ port: req.body.port, deviceid: req.body.deviceid, state: state }), (error) => {
                        if (!error) {
                            return res.json({success:true, msg: "successfully state Changed!", device: doc})
                        }
                        else {
                            return res.json({ success: false, msg: error.message });
                        }
                    });
                });
                
            } )
        }catch(err){
            return res.json({
				success: false,
				msg: 'Error on add cdevice try catch',
				error: err.message,
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
            let state = 0;
            if (req.body.state === "true") {
                state = 1;
            }
            else {
                state = 0;
            }
            devices.findByIdAndUpdate(req.body.deviceid, { status: state, StartTime: Date.now() , brightness:req.body.brightness }, (err, doc) => {
                // If error happen
                if (err) return res.status(404).json({ success: false, msg: err.message });
                if (!doc) return res.status(404).json({ success: false, msg: "Device Not found!" });
                // If the device found
            })
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
                            return res.json({ success: true, msg: "successfully Turned On!", device: dev });
                        }
                    });
                });
        } catch (e) {
            return res.status(404).json({
				success: false,
				error: e.message,
            });
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
    }

}

module.exports = functions