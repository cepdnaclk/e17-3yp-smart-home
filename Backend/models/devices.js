var mongoose = require('mongoose');
var schema = mongoose.Schema;

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
	Energy: {
		type: Number,
	},
	status: {
		type: Number,
		default: 0,
	},
	cdeviceid:{
		type: String,
		require: true,
	},
	port: {
		type: Number,
		require: true
	},
	homeid: {
		type:schema.Types.ObjectId,
		ref: 'homes',
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
		type: Date, default: Date.now
	},

	EndTime :{
		type: Date,
		default:Date.now
	},

	Schedule:{
		type: Date
		
	}
});

module.exports = mongoose.model('devices', deviceSchema);
