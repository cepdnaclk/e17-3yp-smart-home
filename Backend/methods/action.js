var User = require('../models/users');
var jwt = require('jwt-simple');
var config = require('../config/dbconfig');

var functions = {
	addNew: function (req, res) {
		if (!req.body.name || !req.body.password || !req.body.mail) {
			res.json({ success: false, msg: 'Enter all fields' });
		} else {
			var newUser = User({
				name: req.body.name,
				password: req.body.password,
				mail: req.body.mail,
			});
			//Saving The New User Details
			newUser.save(function (err, newUser) {
				if (err) {
					res.json({ success: false, msg: 'Failed to save' });
				} else {
					res.json({ success: true, msg: 'Successfully saved' });
				}
			});
		}
	},
	authendicate: function (req, res) {
		User.findOne(
			{
				name: req.body.name,
			},
			function (err, user) {
				if (err) throw err;
				if (!user) {
					res.status(403).send({
						success: false,
						msg: 'Authendication Failed!, User not found',
					});
				} else {
					//Else Compare the password and check whether it's correct
					user.comparePassword(req.body.password, function (err, isMatch) {
						if (isMatch && !err) {
							//Creating Jwt token
							var token = jwt.encode(user, 'secret');
							res.json({ success: true, token: token });
						} else {
							return res.status(403).send({
								success: false,
								msg: 'Authendication Failed, Wrong Password!',
							});
						}
					});
				}
			}
		);
	},
	getInfo: function (req, res) {
		if (
			req.headers.authorization &&
			req.headers.authorization.split(' ')[0] === 'Bearer'
		) {
			var token = req.headers.authorization.split(' ')[1];
			var decodedToken = jwt.decode(token, config.secret);
			return res.json({ success: true, msg: 'Hello ' + decodedToken.name });
		} else {
			return res.json({ success: false, msg: 'No Headers' });
		}
	},
};
module.exports = functions;
