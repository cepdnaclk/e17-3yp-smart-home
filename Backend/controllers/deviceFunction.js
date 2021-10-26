// let homes = require('../models/homes')
// let devices = require('../models/devices')
// let rooms = require('../models/rooms')


// // Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// // SPDX-License-Identifier: MIT-0
// var awsIot = require('aws-iot-device-sdk');

// var device = awsIot.thingShadow({//device({
//     keyPath: 'private.pem.key',
//     certPath: 'certificate.pem.crt',
//     caPath: 'AmazonRootCA1.pem',
//     clientId: 'digitalHuT',
//     host: 'a2vg03neigl4wn-ats.iot.us-east-1.amazonaws.com',

// });

// device.on('connect', function () {
// 	console.log('connect');
// 	device.subscribe('esp32/pub');
// 	device.publish('esp32/sub', JSON.stringify({ bulb_1: 0 }));
// });

// // device.on('message', function (topic, payload) {
// // 	console.log('message', topic, payload.toString());
// // });


// let functions ={
//     turnOn: async function(req, res){
//         try{
//             devices.findByIdAndUpdate(req.body.deviceid, {status: 1, StartTime:Date.now()}, (err, doc)=>{
//                 if(err) return res.json({success: false, msg: err.message})
//                 device.on('connect', function () {
//                     console.log('connect');
//                     // device.subscribe('esp32/pub');
//                     let devicename =doc.devicename
//                     device.publish('esp32/sub/'+devicename, JSON.stringify({ devicename: 1 }));
//                 });
//                 return res.json({success:true, msg: "successfully Turned On!", device: doc})
//             } )

//         }catch(err){
//             return res.json({
// 				success: false,
// 				msg: 'Error on add cdevice try catch',
// 				error: err.message,
// 			});
//         }
//     }
// }

// module.exports = functions