let homes = require('../models/homes')
let devices = require('../models/devices')
let rooms = require('../models/rooms')

let mqtt=require('mqtt');


// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
var awsIot = require('aws-iot-device-sdk');

var device = awsIot.thingShadow({//device({
    keyPath: 'private.pem.key',
    certPath: 'certificate.pem.crt',
    caPath: 'AmazonRootCA1.pem',
    clientId: 'digitalHuT',
    host: 'ao6ctcxwx3ib7-ats.iot.ap-southeast-1.amazonaws.com',

});

device.on('connect', function () {
	console.log('connect');
	device.subscribe('esp32/pub');
	device.publish('esp32/sub', JSON.stringify({ bulb_1: 0 }));
});

// device.on('message', function (topic, payload) {
// 	console.log('message', topic, payload.toString());
// });


let functions ={
    turnOn: async function(req, res){
        try{
            devices.findByIdAndUpdate(req.body.deviceid, {status: 1, StartTime:Date.now()}, (err, doc)=>{
                if(err) return res.json({success: false, msg: err.message})
                device.on('connect', function () {
                    console.log('connect');
                    // device.subscribe('esp32/pub');
                    let devicename =doc.devicename
                    device.publish('esp32/sub/'+devicename, JSON.stringify({ devicename: 1 }));
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
    rgbTurnOn: (req, res, next) =>
    {
        try {
            if (!req.body.homeid,
                !req.body.roomid,
                !req.body.deviceid,
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
                device.on('connect', function () {
                    console.log('connect');
                    // device.subscribe('esp32/pub');
                    let devicename = doc.devicename
                    let homeid = doc.homeid
                    let roomid = doc.roomid
                    let color = req.body.color
                    let brightness = req.body.brightness
                    device.publish('esp32/sub/'+homeid+roomid+devicename, JSON.stringify({ devicename: 1, color:color, brightness:brightness }));
                });
                return res.json({success:true, msg: "successfully Turned On!", device: doc})
            } )
        
        } catch (e) {
            return res.json({
				success: false,
				msg: 'Error on add cdevice try catch',
				error: err.message,
            });
            next();
    }   
    },
    
}

module.exports = functions