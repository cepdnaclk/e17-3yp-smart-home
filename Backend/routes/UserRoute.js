const express = require('express');
const router = express.Router();
const path = require('path');
const userControl = require('../controllers/userControl');

// router.get('/',(req,res)=>{
// 	console.log("Testing 1 Root")
// })

//Adding New User Or SignUp=>{name, mail, password ,confirmPassword}--> Send mail
router.post('/api/user/signup', userControl.addNew,()=>{
	console.log("testing")
});

//Validate the mail id by clicking the link in the mail
router.get('/api/user/validate', userControl.verifyMail);

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


router.post('/api/user/uploadimg', userControl.verifyToken, userControl.AddProfile)

//Update user Name by ID req->id
router.put(
	'/api/user/updatename/:id',
	userControl.verifyToken,
	userControl.handleNameUpdate
);

//Alluser connected to a house
router.get('/api/user/getalluserbyhome', userControl.verifyToken, userControl.allUserofAhouse )

//Change Password
// router.put('api/user/changePass/:id', userControl.handlePasswordUpdate);

//Get UserInfo
// router.get('/api/getinfo', userControl.getInfo, () => {});

module.exports = router;
