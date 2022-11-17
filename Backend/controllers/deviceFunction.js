let homes = require('../models/homes')
let devices = require('../models/devices')
let rooms = require('../models/rooms')

let mqtt = require('mqtt');
const clientId = "digitalHut_smartBulb"
const options = {
    clientId,
}

let functions ={
    turnOn: async function(req, res){
        try{
            devices.findByIdAndUpdate(req.body.deviceid, {status: 1, StartTime:Date.now()}, (err, doc)=>{
                if (err) return res.json({ success: false, msg: err.message })
                let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
                client.on('connect', function () {
                    console.log('connect');
                    // device.subscribe('esp32/pub');
                    let devicename =doc.devicename
                    client.publish('esp32/sub/'+devicename, JSON.stringify({ devicename: 1 }));
                });
                return res.json({success:true, msg: "successfully Turned On!", device: doc})
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
                !req.body.color,
                !req.body.brightness,
                !req.body.port,
                !req.body.deviceid,
                !req.body.state
            ) {
                return res.json({ success: false, msg: "Enter All feilds for RGB" });
            }
            let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
            devices.findByIdAndUpdate(req.body.deviceid, { status: req.body.state, StartTime: Date.now(), color: req.body.color, brightness:req.body.brightness }, (err, doc) => {
                // If error happen
                if (err) return res.json({ success: false, msg: err.message });
                if (!doc) return res.json({ success: false, msg: "Device Not found!" });
                // If the device found
            })
            let dev ={ d_id: req.body.deviceid, col: req.body.color, brtns: req.body.brightness, port: req.body.port, d_t: 1 }
            console.log("Device Found")
                client.on('connect', function () {
                    console.log('connect');
                    // device.subscribe('esp32/pub');
                    // Device Type RGB 1
                    client.publish('esp32/sub' + devicename, JSON.stringify(dev), (error)=>{
                        console.log(error.message);
                        client.end();
                        return res.json({ success: flase, msg: error.message });
                    });
                });
                client.end();
                return res.json({ success: true, msg: "successfully Turned On!", device: dev });
            
        } catch (e) {
            return res.json({
				success: false,
				msg: 'Error on add cdevice try catch 1',
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