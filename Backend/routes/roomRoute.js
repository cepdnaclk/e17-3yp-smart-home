const express = require('express');
const router = express.Router();
const path = require('path');
const roomControl = require('../controllers/roomControl');

//Adding a new room
router.post('api/rooms/addroom');
