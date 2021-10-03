var mongoose = require('mongoose');
var schema = mongoose.Schema;
// var roomSchema = require('./rooms');

let deviceSchema = new schema({
	name: {
		type: String,
		require: true,
	},
	type: {
		type: String,
		require: true,
	},
	Energy: {
		type: Number,
	},
	status: {
		type: Number,
		default: 0,
	},
});

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
	devices: [deviceSchema],

	numberOfDevices: {
		type: Number,
		default: 0,
	},
});

var homeschema = new schema({
	homename: {
		type: String,
		require: true,
		unique: true,
	},
	address: {
		type: String,
	},
	rooms: [roomsSchema],
});

module.exports = mongoose.model('homes', homeschema);
