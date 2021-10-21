const express = require('express');
const router = express.Router();
const roomControl = require('../controllers/roomControl');
const userControl = require('../controllers/userControl')

//Adding a new room
router.post('/api/home/rooms/addroom', userControl.verifyToken, roomControl.addRoom);

//get all rooms using roomid
router.get('/api/home/rooms/getAlldivices',userControl.verifyToken, roomControl.getAlldevices)

module.exports = router
