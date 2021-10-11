const { admin } = require('googleapis/build/src/apis/admin');
let home = require('../models/homes');
let user = require('../models/users');

let functions = {
	addhome: async function (req, res) {
		try {
			if (req.body.homename && req.body.username) {	//If username and home name were not given 
				
				await user.findOne({name:req.body.username},(err, data)=>{	//
					if(!err && data){
						let newadminid = data._id;
					}else{
						return res.json({
							succcess:false, 
							msg: err
						})
					}
				})
				let newHome = home({
					homename: req.body.homename,
					adminid: newadminid
				});
				if(req.body.address){			//If address were given --> Address optional
					newHome.address = req.body.address;
				}
				newHome.save(function (err, newHome) {
					if (err) {				//If any error occur while saving
						console.log('addhome-save', err);
						return res.json({
							success: false,
							msg: err,
						});
					} else {				//If no error
						res.json({
							success: true,
							msg: 'Home Successfully saved!',
						});
					}
				});
			} else {		//If the Name was not given 
				return res.status(404).json({
					succcess: false,
					msg: 'Entre the name',
				});
			}
		} catch (err) {		///Error catch
			console.log(err);
			return res.status(404).json({
				succcess: false,
				msg: err,
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
