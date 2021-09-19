const express = require('express');
const router = express.Router();
const path = require('path');
const userControl = require('../controllers/userControl');

//Adding New User
router.post('/api/user', userControl.addNew);

//Authendicate the user And send the JWT token
router.post('/api/authenticate', userControl.authendicate);

//Get the All user Info
router.get('/api/user', userControl.handleGet);

//Get one user info by id
router.get('/api/user/:id', userControl.handleGetById);

//Update user by id
router.put('/api/user/:id', userControl.handleUpdate);

//Get the user js
// router.get('/api/users/:UserName', (req, res) => {
// 	res.send('Hello world');
// });

//Get UserInfo
router.get('/api/getinfo', userControl.getInfo, () => {});

module.exports = router;
