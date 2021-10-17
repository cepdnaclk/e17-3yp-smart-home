const { admin } = require('googleapis/build/src/apis/admin');
let home = require('../models/homes');
const { findOne, findByIdAndUpdate } = require('../models/users');
let user = require('../models/users');

let functions = {
	addhome: async function (req, res) {
		try {
			if (req.body.homename && req.body.userid) {	//If username and home name were not given 
				
				data=await home.findOne({homename: req.body.homename})
				if(data){
					return res.status(409).json({success: false,
					msg:"Name already used"
				})
				}else{
					let newHome = home({
						homename: req.body.homename,
						adminid: req.body.userid,
						// memberids: req.body.userid
						
					});
					if(req.body.address){			//If address were given --> Address optional
						newHome.address = req.body.address;
					}
					newHome.save(function (err, newHome) {
						if (err) {				//If any error occur while saving
							console.log('addhome-save', err);
							return res.status(500).json({
								success: false,
								msg: err,
								line:30
							});
						} else {				//If no error
							
							return res.json({
								success: true,
								msg: 'Home Successfully saved!',
							});
						}
					});
				}
			} else {		//If the Name was not given 
				return res.status(404).json({
					succcess: false,
					msg: 'Entre the name',
				});
			}
		} catch (err) {		///Error catch
			// console.log(err);
			return res.json({
				succcess: false,
				msg: err,
				line:55
			});
		}
	},

	showAllHome: async function (req, res) {
		try {
			let allHome = await home.find();
			res.status(200).json({
				success: true,
				homes: allHome,
			});
		} catch (err) {
			console.log(err);
			return res.status(404).json({
				succcess: false,
				msg: err,
			});
		}
	},

	getAllrooom: async function (req, res) {
		try {
			let allRooms = await home.findById(req.body._id).select('rooms');
			res.status(200).json({
				success: true,
				rooms: allRooms,
			});
		} catch (err) {
			console.log('show all rooms', err);
			return res.status(404).json({
				succcess: false,
				msg: err,
			});
		}
	},
};

module.exports = functions;
