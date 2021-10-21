var cdevice = require('../models/centralDevice');
var nonActiveDevice = require('../models/nonActiveCDevice');

var functions = {
	addCdevice: async function (req, res) {
		try {
			if (!req.body.password || !req.body.cdeviceId) {
				return res //If not all the feilds are given
					.status(404)
					.json({ success: false, msg: 'Enter all fields' });
			} else {
				cdevice.findOne(
					//Check whether it is already used
					{ cdeviceNumber: req.body.cdeviceNumber },
					(err, data) => {
						if (!data) {
							//if the id not used check the new id is coreect
							nonActiveDevice.findOne(
								{
									cdeviceNumber: req.body.cdeviceNumber,
								},
								(err, data2) => {
									if (data2) {
										// if the Entered device number correct then check the password
										bcrypt.compare(
											req.body.password,
											data2.password,
											function (err, isMatch) {
												//if the passwords are matched
												if (!err && isMatch) {
													var newcDevice = cdevice({
														name : req.body.name,
														password : req.body.password,
														cdeviceNumber : req.body.cdeviceNumber
													})
													newcDevice.save(function(err,newcDevice){
														if(err){
															return res.status(400).json({
																success: false,
																msg: err,})
														}
														else{
															return res.status(200).json({
																success: true,
																msg: "Successfully saved",
																
																cdeviceNumber : req.body.cdeviceNumber
															})
														}
													})
												} else { //If any error ocuured 
													return res.status(400).json({
														success: false,
														msg: err,
													});
												}
											}
										);
									} else {
										//Entered Device number is wrong
										return res.status(400).json({
											success: false,
											msg: 'Given id is wrong!',
										});
									}
								}
							);
						} else {
							//If the device number already exist
							return res.status(400).json({
								success: false,
								msg: 'This device is already connected!',
							});
						}
					}
				);
			}
		} catch (err) {
			return res.json({
				success: false,
				msg: 'Error on add cdevice try catch',
				error: err,
			});
		}
	},
};

module.exports = functions;
