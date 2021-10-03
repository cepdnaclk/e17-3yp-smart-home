const express = require('express');
const router = express.Router();
const path = require('path');
const cdControl = require('../controllers/cdeviceControl');

//Adding central device
router.post('api/cdevice/addCdevice', cdControl.addCdevice);

//getting all the rooms
router.get;
