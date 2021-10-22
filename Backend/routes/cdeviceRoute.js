const express = require('express');
const router = express.Router();
const path = require('path');
const cdControl = require('../controllers/cdeviceControl');
const userControl = require('../controllers/userControl');

//Adding central device
router.post('/api/cdevice/addCdevice', userControl.verifyToken, cdControl.addCdevice);

//getting all the Cdevices connected to a home
router.get('/api/cdevice/getallByid', userControl.verifyToken, cdControl.getAllbyId )

module.exports = router