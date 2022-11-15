var User = require('../models/users');
let jwt = require('jsonwebtoken');
var config = require('../config/dbconfig');
const users = require('../models/users');
const activate = require('../Mail Activation/activate');
let homes = require('../models/homes');




var functions = {
	//AddNew
	addNew: function (req, res, next) {
		// console.log('addnew');
		try {
			if (
				!req.body.name || //User Name
				!req.body.password || //Password
				!req.body.confpassword || //Confirm Password
				!req.body.mail //User Mail
			) {
				return res //If not all the feilds are given
					.status(404)
					.json({ success: false, msg: 'Enter all fields' });
			} //Both Password are same
			else if (req.body.password === req.body.confpassword) {
				console.log(req.body.name)
				User.findOne({ mail: req.body.mail.toLowerCase() }, (err, data) => {
					// console.log(data);
					if (!data && !err) {
						//Check The mail in the dB
						var newUser = User({
							name: req.body.name,
							password: req.body.password,
							mail: req.body.mail.toLowerCase(),
						});
						//Verify the mail by sending the mail to that account
						activate(newUser); //Sending mail
						return res
							.status(200)
							.json({ success: true, msg: 'Verification mail sent' });
					} else if (!err) {
						//If the Mail already connected
						return res.status(404).json({
							success: false,
							msg: 'Mail Already Conected with an account!',
						});
					} else {
						return req.json({
							success: false,
							msg: err,
						});
					}
				});
			} else {
				//If the Password Doesn't Match
				return res.status(404).json({
					success: false,
					msg: "The Password Doesn't match",
				});
			}
		} catch (err) {
			//If any error Found
			if (err) {
				return next(err);
			}
		}
	},
	//Mail Verification
	verifyMail: function (req, res, next) {
		try {
			const token = req.query.token;
			// console.log(token);
			if (token) {
				// console.log(token);
				jwt.verify(token, config.secret, (err, authData) => {
					if (err) {
						// console.log(1);
						return res.status(403).json({ msg: 'Authorization failed!' });
					} else {
						// console.log(2);
						// console.log('Hello', authData.user.mail);
						users.findOne({ mail: authData.user.mail }, (err, data) => {
							if (!data && !err) {
								// console.log(1111);
								var newUser = users({
									name: authData.user.name,
									mail: authData.user.mail,
									password: authData.user.password,
								});
								//Saving The New User Details
								// console.log(authData);
								// console.log(newUser);
								newUser.save(function (err, newUser) {
									if (err) {
										// console.log(3);
										return res.json({
											success: false,
											msg: 'Failed to save',
											Error: err.message,
										});
									} else {
										// console.log(4);
										let { name, mail } = newUser;
										return res.json({
											success: true,
											msg: 'Successfully saved',
											user: { name, mail },
										});
									}
								});
							} else {
								return res.status(403).json({ msg: 'Already Verified!' });
							}
						});
					} //else
				}); //jwt-verify;
			} else {
				return res.status(403).json({ msg: 'Authorization Error!' });
			}
		} catch (err) {
			console.log('verify Mail', err);
			return next(err);
		}
	},
	//Authendicate the user--->Login
	authendicate: function (req, res,next) {
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
							//Creating Jwt token Expire in 2 hour
							jwt.sign(
								{ user },
								config.secret,
								{ expiresIn: '22h' },
								(err, token) => {
									if (err) {
										return res.json({ success: false, msg: err });
									} else {
										
										// var payload = jwt.decode(token, config.secret);
										return res.json({ success: true, userid: user._id, token: token});
										
									}
								}
							);
						} else {
							return res.status(403).send({
								success: false,
								msg: 'Authendication Failed!',
							});
						}
					});
				}
			}
		);
	},

	allUserofAhouse: async function (req, res, next) {
		try{
			if(req.body.homeid){
			// let members = await homes.findById(req.body.homeid).select('memberids')
			// return res.json({
			// 	members:members,
			// })

			homes.findById(req.body.homeid).populate('adminid').exec(function (err, home){
				if (err) return res.json({error:err.message});
				if(!home) return res.json({success: false, msg: " Home id wrong!"})
				// console.log(home.adminid)
				return res.status(200).json({ 
						username : home.adminid.name, 
						success:true
					})
			})
			}else{
				return res.status(403).json({
					success:false,
					msg: "failed"
				})
			}
		}catch(err){
			return res.status(403).send({
				success: false,
				msg: err.message,
			});
		}
	},

	//Invite user

	//Delete User
	deleteuserByID : async function(req, res, next){
		try{
			users.findByIdAndRemove(req.body.userid)
			return res.json({
				success: true,
				msg: "deleted"
			})

		}catch(err){
			return res.status(403).send({
				success: false,
				msg: err.message,
			});
		}
	},


	//Get the all users
	handleGet: async function (req, res, next) {
		try {
			let allUsers = await users.find().select('-password');
			return res.status(200).json({ allUsers: allUsers });
		} catch (err) {
			if (err) {
				return next(err);
			}
		}
	},
	//Get One User by Id
	handleGetById: async function (req, res, next) {
		// console.log(req);
		try {
			const userById = await users.findById(req.params.id).select('-password');
			if (!userById) {
				return res.status(404).json({ success: false, msg: 'Id not found' });
			}
			return res.status(200).json({ user: userById });
		} catch (err) {
			if (err) {
				return next(err);
			}
		}
	},
	//Update User Name
	handleNameUpdate: async function (req, res, next) {
		// console.log(req.body);
		try {
			let updatedUser = await users
				.findByIdAndUpdate(req.body.userid, {name: req.body.name})
				.select('-password');
			return res.status(200).json({ success: true, msg: 'User Name Updated!' });
			//Catch Error
		} catch (err) {
			if (err) {
				return next(err);
			}
		}
	},
	verifyToken: async function (req, res, next) {
		try {
			console.log("reached verify token")
			const bearerHeader = req.headers['authorization'];
			if (typeof bearerHeader !== 'undefined') {
				const bearerToken = bearerHeader.split(' ')[1];
				// console.log(bearerToken);
				jwt.verify(bearerToken, config.secret, (err, authData) => {
					if (err) {
						return res.status(403).json({ msg: 'Authorization failed!', error: err });
					} else {
						req.name = authData.name;
						req.mail = authData.mail;
						req.password = authData.password;
						next();
					}
				});
			} else {
				return res.status(403).json({ msg: 'Authorization Error!',error:'undefiend token' });
			}
		} catch (err) {
			return next(err);
		}
	},

	//Change Password
	changePassword: async function (req, res, next) {
		try {
			newPassword = req.body.newpassword;
			users.findByIdAndUpdate()
		} catch (err) {
			return res.status(500).json({
				success: false,
				msg: err.message
			})
		}
	},
};



module.exports = functions;
