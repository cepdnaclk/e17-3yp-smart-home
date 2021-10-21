const express = require('express');
const router = express.Router();

const nonActiveControl = require('../controllers/NonactiveDeviceControl');

//Add new Non Active Device
router.post('/api/NonActive/addCdevice', nonActiveControl.addNonActive)

module.exports = router