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

nonActiveDevice.pre('save', function (next) {
	var user = this;
	if (this.isModified('password') || this.isNew) {
		bcrypt.genSalt(10, function (err, salt) {
			if (err) {
				return next(err);
			}
			bcrypt.hash(user.password, salt, function (err, hash) {
				if (err) {
					return next(err);
				}
				user.password = hash;
				next();
			});
		});
	} else {
		return next();
	}
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
