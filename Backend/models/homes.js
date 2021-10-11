var mongoose = require('mongoose');
var schema = mongoose.Schema;
// var roomSchema = require('./rooms');

let deviceSchema = new schema({
	devicename: {
		type: String,
		require: true,
		unique:true,
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

//Members of the home user._id
var memberid = new schema({
	id: {
		type:String,
		require: true,
		unique: true,
	}
})

var homeschema = new schema({
	homename: {
		type: String,
		require: true,
		unique: true,
	},
	address: {
		type: String,
	},
	adminid: {
		type:String,
		require: true,
	},
	memberids:[memberid],				//friend
	rooms: [roomsSchema],
});

module.exports = mongoose.model('homes', homeschema);
