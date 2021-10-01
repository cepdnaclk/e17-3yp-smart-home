var mongoose = require('mongoose');
var schema = mongoose.Schema;

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

module.exports = mongoose.model('devices', deviceSchema);
