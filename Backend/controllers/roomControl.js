let homes = require('../models/homes');
let rooms = require('../models/rooms')


let functions = {
	addRoom: async function (req, res) {
		try {
			console.log('reached the addRoom')
			//If any details is not given
			if (!req.body.roomname || !req.body.roomType || !req.body.homeid) {
				console.log('Failed to addRoom');
				return res.status(404).json({
					success: false,
					msg: 'not all datas given to create room',
				});
			} else {
				let newRoom = new rooms({
					roomname: req.body.roomname,
					roomType: req.body.roomType,
					homeid: req.body.homeid
				})
				rooms.findOne({roomname: req.body.roomname },(err, data)=>{
					if(data){
						return res.status(409).json({
							success : false,
							msg: "Room name already in use"
						})
					}else{
						rooms.create(newRoom).then(roomdoc=>{
							console.log(roomdoc);
							homes.findByIdAndUpdate(req.body.homeid, 
								{ $push: { rooms: roomdoc._id }},
								{ new: true, useFindAndModify: false },()=>{
									console.log("reached the update")
								}  );
							
							return res.json({
								success: true,
								room: roomdoc,
								msg: "Rooom successfully added"
							})
						})
					}
				})
			}
		} catch (err) {
			console.log('addRoom', err);
			return res.json({
				success: false,
				msg: err,
			});
		}
	},

	getAlldevices: async function (req, res) {
		try {
			rooms.findById(req.body.roomid).populate('devices').exec( function(err, room1){
				if(err) return res.status(400).json({success: false, msg: err.message})
				if(!room1) return res.status(400).json({success: false, msg:"roomid is wrong"})
				return res.json({ success: true, devices: room1.devices})
			})
			
		} catch (err) {
			console.log('show all devices', err);
			return res.status(404).json({
				succcess: false,
				msg: err.message,
			});
		}
	},

};

module.exports = functions