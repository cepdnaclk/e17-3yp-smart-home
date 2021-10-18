var mongoose = require('mongoose');
var schema = mongoose.Schema;

// var roomSchema = require('./rooms');



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
		type:schema.Types.ObjectId,
		ref: 'users',
		require: true
	},
	memberids:[{
		type:schema.Types.ObjectId,
		ref: 'users'
	}],				//friend
	rooms: [{
		type: schema.Types.ObjectId,
		ref: 'rooms'
	}],
});

module.exports = mongoose.model('homes', homeschema);
