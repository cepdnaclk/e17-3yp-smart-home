var mongoose = require('mongoose');
var schema = mongoose.Schema;
let deviceSchema = require('./devices');

var roomsSchema = new schema({
	roomname: {
		type: String,
		require: true,
		unique: true,
	},
	homeid: {
		type:schema.Types.ObjectId,
		ref: 'homes',
		require: true
	},
	roomType: {
		type: String,
		require: true,
	},
	devices: [{
		type: schema.Types.ObjectId,
		ref : 'devices'
	}],	//

	numberOfDevices: {
		type: Number,
		default: 0,
	},
});

module.exports = mongoose.model('rooms', roomsSchema);
