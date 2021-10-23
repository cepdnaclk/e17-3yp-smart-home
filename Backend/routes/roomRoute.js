const express = require('express');
const router = express.Router();
const roomControl = require('../controllers/roomControl');
const userControl = require('../controllers/userControl')

//Adding a new room
router.post('/api/home/rooms/addroom', userControl.verifyToken, roomControl.addRoom);


module.exports = router
