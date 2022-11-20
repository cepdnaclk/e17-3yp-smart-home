const express = require('express');
const router = express.Router();
// const roomControl = require('../controllers/roomControl');
const userControl = require('../controllers/userControl')
const deviceControl = require('../controllers/deviceControl')
const deviceFunction = require('../controllers/deviceFunction')

//Adding a new room
router.post('/api/devices/adddevice', userControl.verifyToken, deviceControl.addDevice);

//Get all devices
router.post('/api/devices/getallDevices', userControl.verifyToken, deviceControl.getAllDevices);

// Delete a device 
router.post('/api/devices/deleteone', userControl.verifyToken, deviceControl.deleteDevice);

// Get the status of a device
router.post('/api/devices/status', userControl.verifyToken, deviceFunction.deviceStatus)

//Turn on A device
router.post('/api/devices/turnOn', userControl.verifyToken, deviceFunction.plugTurnOn)

// Turn on the rgb light
router.post('/api/devices/rgb', userControl.verifyToken, deviceFunction.rgbTurnOn);

// Shedule the Device
router.post('/api/devices/schedule',userControl.verifyToken, deviceFunction.scheduleDevice )

// MQtt publish test
router.post('/api/devices/testPub', deviceFunction.testPub);
// MQTT subscribe test
router.post('/api/devices/testsub', deviceFunction.testsub)




module.exports = router