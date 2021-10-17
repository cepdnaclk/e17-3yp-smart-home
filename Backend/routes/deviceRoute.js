const express = require('express');
const router = express.Router();
// const roomControl = require('../controllers/roomControl');
const userControl = require('../controllers/userControl')
const deviceControl = require('../controllers/deviceControl')

//Adding a new room
router.post('/api/home/rooms/devices/adddevice', userControl.verifyToken, deviceControl.addDevice);

module.exports = router
