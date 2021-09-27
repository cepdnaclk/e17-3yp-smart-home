const express = require('express');
const router = express.Router();
const path = require('path');
const userControl = require('../controllers/userControl');

//Adding New User Or SignUp=>{name, mail, password ,confirmPassword}
router.post('/api/user/signup', userControl.addNew);

//Validate the mail id by clicking the link in the mail
router.get('/api/user/validate/:uniqueString', userControl.verifyMail);

//Authendicate the user And send the JWT token =>{req->mail, password}=> res.authToken ->Header.autheriztion
router.post('/api/user/login', userControl.authendicate);

//Get the All user Info     => All users
router.get('/api/user/alluser', userControl.verifyToken, userControl.handleGet);

//Get one user info by id   => info (mail name)
router.get(
	'/api/user/info/:id',
	userControl.verifyToken,
	userControl.handleGetById
);

//Update user Name by ID req->id
router.put(
	'/api/user/updatename/:id',
	userControl.verifyToken,
	userControl.handleNameUpdate
);

//Change Password
// router.put('api/user/changePass/:id', userControl.handlePasswordUpdate);

//Get UserInfo
// router.get('/api/getinfo', userControl.getInfo, () => {});

module.exports = router;
