const express = require('express');
const router = express.Router();
const path = require('path');
const userControl = require('../controllers/userControl');
const homeControl = require('../controllers/homeControl');

//Adding Home
//Home-Name required
//Address optional
router.post('/api/home/addhome', userControl.verifyToken, homeControl.addhome);

//Delete Home

//Get home byid

//invite Users

//Get all rooms
router.get(
	'/api/home/allrooms',
	userControl.verifyToken,
	homeControl.getAllrooom
);

module.exports = router;
