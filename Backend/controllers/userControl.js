var User = require('../models/users');
var jwt = require('jwt-simple');
var config = require('../config/dbconfig');
const users = require('../models/users');
const { use } = require('../routes/UserRoute');

var functions = {
	//AddNew
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
					let { name, mail } = newUser;
					res.json({
						success: true,
						msg: 'Successfully saved',
						user: { name, mail },
					});
				}
			});
		}
	},
	//Authendicate the user
	authendicate: function (req, res) {
		User.findOne(
			{
				mail: req.body.mail,
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
							var token = jwt.encode(user, config.secret);
							// var payload = jwt.decode(token, config.secret);
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
		// console.log(req.headers.authorization);
		if (
			req.headers.authorization //&&
			// req.headers.authorization.split(' ')[0] === 'Bearer'
		) {
			var token = req.headers.authorization; //.split(' ')[1];
			console.log(typeof token);
			console.log(token === newToken);
			var decodedToken = jwt.decode(token, config.secret);
			return res.json({ success: true, msg: 'Hello ' + decodedToken });
		} else {
			return res.json({ success: false, msg: 'No Headers' });
		}
	},
	//Get the User By Id
	handleGet: async function (req, res, next) {
		try {
			const allUsers = await users.find().select('-password');
			return res.status(200).json({ allUsers: allUsers });
		} catch (err) {
			if (err) {
				return next(err);
			}
		}
	},
	//Get One User by Id
	handleGetById: async function (req, res, next) {
		try {
			const userById = await users.findById(req.params.id).select('-password');
			return res.status(200).json({ user: userById });
		} catch (err) {
			if (err) {
				return next(err);
			}
		}
	},
	//Update User Info
	handleUpdate: async function (req, res, next) {
		try {
			// let userById = await users.findById(req.params.id);
			if (req.body.password) {
				let userById = await users.findById(req.params.id);
			} else {
				let updatedUser = await users.findByIdAndUpdate(
					req.params.id,
					req.body
				);
				return res.status(200).json({ updatedUser: updatedUser });
			}
			//Catch Error
		} catch (err) {
			if (err) {
				return next(err);
			}
		}
	},
};
module.exports = functions;
