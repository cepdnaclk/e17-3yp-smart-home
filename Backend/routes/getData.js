const express = require('express');
const router = express.Router();
const path = require('path');
const action = require('../methods/action');

//Adding New User
router.post('/api/adduser', action.addNew);

router.post('/api/authenticate', action.authendicate);
router.get('/api/Users/:UserName', (req, res) => {
	res.send('Hello world');
});

//Get UserInfo
router.get('/api/getinfo', action.getInfo);

module.exports = router;
