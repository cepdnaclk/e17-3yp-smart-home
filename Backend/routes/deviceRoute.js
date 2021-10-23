const express = require('express');
const router = express.Router();
// const roomControl = require('../controllers/roomControl');
const userControl = require('../controllers/userControl')
const deviceControl = require('../controllers/deviceControl')

//Adding a new room
router.post('/api/devices/adddevice', userControl.verifyToken, deviceControl.addDevice);

//Get all devices
router.post('/api/devices/getallDevices', userControl.verifyToken, deviceControl.getAllDevices )

module.exports = router
