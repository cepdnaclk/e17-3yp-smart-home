let home = require('../models/homes');
let rooms = require('../models/rooms');

let functions = {
	addRoom: async function (req, res) {
		try {
			//If any details is not given
			if (!req.body.roomname && !req.body.roomType) {
				console.log('Failed to addRoom');
				return res.json({
					success: false,
					msg: 'not all datas given to create room',
				});
			} else {

                let newRoom = rooms({
                    roomname = req.body.roomname,
                    roomType = req.body.roomType
                })
                home.
			}
		} catch (err) {
			console.log('addRoom', err);
			return res.json({
				success: false,
				msg: err,
			});
		}
	},
};
