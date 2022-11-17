
let home = require('../models/homes');
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
					

					await newHome.save(function (err, newHome) {
						if (err) {				//If any error occur while saving
							console.log('addhome-save', err);
							return res.status(500).json({
								success: false,
								msg: err,
								line:30
							});
						} else {				//If no error
							user.findByIdAndUpdate(req.body.userid, { $push: { homes: newHome._id }},
								{ new: true, useFindAndModify: false }, ()=>{
									console.log('Updated')
								} );
							
							home.findById(newHome._id, (err,data)=>{
								if(err) {
									return res.status(400).json({succcess:false, msg: err.message})
								}
								else{
									
								data.memberids.push(req.body.userid)
								data.save()
								}
							})
							return res.json({
								success: true,
								msg: 'Home Successfully saved!',
								home_id: newHome._id
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

	showAllHomeByuserId: async function (req, res) {
		try {
			user.findById(req.body.userid).populate('homes').exec( function(err, user1){
				if(err) return res.status(400).json({success: false, msg: err.message})
				
				return res.json({ success: true, homes: user1.homes, numberOfhomes: user1.homes.length})
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
			await home.findById(req.body._id).populate('rooms').exec(function(err, home1){
				if(err)return res.status(400).json({success: false, msg: err.message})
				res.status(200).json({
					success: true,
					rooms: home1.rooms,
					numberOfrooms: home1.rooms.length
				});
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
