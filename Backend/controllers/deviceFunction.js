let homes = require('../models/homes')
let devices = require('../models/devices')
let rooms = require('../models/rooms')

let mqtt = require('mqtt');
const clientId = "digitalHut_smartBulb"
const options = {
    clientId,
    clean: true,
    connectTimeout: 4000,
    reconnectPeriod: 1000,
}

let functions ={
    turnOn: async function(req, res){
        try{
            devices.findByIdAndUpdate(req.body.deviceid, {status: 1, StartTime:Date.now()}, (err, doc)=>{
                if(err) return res.json({success: false, msg: err.message})
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
            if (!req.body.cdeviceid,
                !req.body.color,
                !req.body.brightness
            ) {
                return res.json({ success: false, msg: "Enter All feilds for RGB" });
            }
            devices.findByIdAndUpdate(req.body.deviceid, { status: 1, StartTime: Date.now() }, (err, doc) => {
                // If error happen
                if (err) return res.json({ success: false, msg: err.message });
                if (!doc) return res.json({ success: false, msg: "Device Not found!" });
                // If the device found
                client.on('connect', function () {
                    console.log('connect');
                    // device.subscribe('esp32/pub');
                    let devicename = doc.devicename
                    let cdeviceid = doc.cdeviceid
                    let color = req.body.color
                    let brightness = req.body.brightness
                    client.publish('esp32/sub/'+cdeviceid+devicename, JSON.stringify({ devicename: 1, color:color, brightness:brightness }));
                });
                return res.json({success:true, msg: "successfully Turned On!", device: doc})
            } )
        
        } catch (e) {
            return res.json({
				success: false,
				msg: 'Error on add cdevice try catch',
				error: err.message,
            });
            
    }   
    },
    testPub: async function (req, res) {
        try {
            console.log(req.body.name);
            let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
            client.on('connect', ()=> {
                console.log('connect');
                client.publish('esp32/sub/', JSON.stringify({ devicename: 1, color: "red", brightness: "60" }),
                    (error) => {
                        if (error) {
                            console.log(error)
                            return res.json({ success: false, msg: "Error in publishing" });
                        }
                        return res.json({ success: true, msg: "Msg published successfully" });
                    }
                    
                );
                
            });
        } catch (e) {
            return res.json({
				success: false,
				msg: 'Error on testPub try catch',
				error: err.message,
            });
        }
    }

}

module.exports = functions