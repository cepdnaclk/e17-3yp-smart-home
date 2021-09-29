var mongoose = require('mongoose');
var schema = mongoose.Schema;
var bcrypt = require('bcrypt');
var nonActiveDevice = new schema({
	password: {
		type: String,
		require: true,
	},
	cdeviceNumber: {
		type: String,
		require: true,
		unique: true,
	},
});

//Ceating compare Password Method
nonActiveDevice.methods.comparePassword = function (candidatePassword, cb) {
	bcrypt.compare(candidatePassword, this.password, function (err, isMatch) {
		if (err) return cb(err);
		cb(null, isMatch);
	});
};

//Creating Model With name of "Users"
module.exports = mongoose.model('NonActiveCentralDevices', nonActiveDevice);
