var mongoose = require('mongoose');
var schema = mongoose.Schema;


let Energy = new schema({
	current_level: {
		type: Number,
		default: 0,
	},
	today_level: {
		type: Number,
		default: 0,
	},
	monthly_level: {
		type: Number,
		default: 0,
	},
	allTime: {
		type: Number,
		default: 0,
	}
})

let deviceSchema = new schema({
	devicename: {
		type: String,
		require: true,
		unique:true,
	},
	deviceType: {
		type: String,
		require: true,
	},
	energy: {
		type: Number,
		default: 0
	},
	status: {
		type: Boolean,
		default: false,
	},
	cdeviceid:{
		type: String,
		require: true,
	},
	port: {
		type: Number,
		require: true
	},
	roomid: {
		type: schema.Types.ObjectId,
		ref: 'rooms'
	},
	r: {
		type: Number,
		default: 0
	},
	g: {
		type: Number,
		default: 0
	},
	b: {
		type: Number,
		default: 0
	},
	brightness:{
		type : Number,
		default: 0
	},
	StartTime :{
		type: String,
		default: Date.toString
	},

	EndTime :{
		type: String,
		default: Date.toString
		
	},

	Schedule:{
		type: Boolean,
		default: false
	}
});
module.exports = mongoose.model('devices', deviceSchema);
