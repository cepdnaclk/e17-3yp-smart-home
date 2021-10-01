var mongoose = require('mongoose');
var schema = mongoose.Schema;
let deviceSchema = require('./devices');

var roomsSchema = new schema({
	roomname: {
		type: String,
		require: true,
		unique: true,
	},
	roomType: {
		type: String,
		require: true,
	},
	// devices: [deviceSchema],

	numberOfDevices: {
		type: Number,
		default: 0,
	},
});

module.exports = mongoose.model('rooms', roomsSchema);
