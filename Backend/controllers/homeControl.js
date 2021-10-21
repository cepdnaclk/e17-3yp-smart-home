
let home = require('../models/homes');
let user = require('../models/users');
let mongoose = require('mongoose')

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
					home.create(newHome).then(homedoc=>{
						user.findByIdAndUpdate(req.body.userid, 
							{ $push: { homes: homedoc._id }},
							{ new: true, useFindAndModify: false },()=>{
								console.log("reached the update")
							}  );

							return res.json({
								success: true,
								home: homedoc,
								msg: "home successfully added"
							})
			}   )
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

	showAllHomeByuserId: async function (req, res) {
		try {
			user.findById(req.body.userid).populate('homes').exec( function(err, user1){
				if(err) return res.status(400).json({success: false, msg: err.message})
				if(!user1) return res.status(400).json({success: false, msg:"Userid is wrong"})
				return res.json({ success: true, homes: user1.homes})
			})
			
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
			home.findById(req.body.homeid).populate('rooms').exec( function(err, home1){
				if(err) return res.status(400).json({success: false, msg: err.message})
				if(!home1) return res.status(400).json({success: false, msg:"homeid is wrong"})
				return res.json({ success: true, rooms: home1.rooms})
			})
			
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
