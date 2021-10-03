let home = require('../models/homes');

let functions = {
	addhome: async function (req, res) {
		try {
			if (!req.body.name) {
				let newHome = home({
					homename: req.body.homename,
				});
				newHome.save(function (err, newHome) {
					if (err) {
						console.log('addhome-save', err);
						return res.json({
							success: false,
							msg: err,
						});
					} else {
						res.json({
							success: true,
							msg: 'Successfully saved!',
						});
					}
				});
			} else {
				return res.status(404).json({
					succcess: false,
					msg: 'Entre the name',
				});
			}
		} catch (err) {
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
