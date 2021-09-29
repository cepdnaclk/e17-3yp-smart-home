const express = require('express');
const router = express.Router();
const path = require('path');
const cdControl = require('../controllers/cdeviceControl');

//Adding Home to a user
router.post('api/home/addhome', cdControl.addhome);

//
