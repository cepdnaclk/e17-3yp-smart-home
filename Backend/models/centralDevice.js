var mongoose = require('mongoose');
var schema = mongoose.Schema;
var bcrypt = require('bcrypt');
var cdSchema = new schema({
	name: {
		type: String,
		require: true,
	},
	password: {
		type: String,
		require: true,
	},
	cdeviceId: {
		type: String,
		require: true,
		unique: true,
	},
	homeid : {
		type: schema.Types.ObjectId,
		ref: 'homes',
		require: true,
	}
});

//Using bcrypt algorithm to encrypt the cdevice password
cdSchema.pre('save', function (next) {
	var cdevice = this;
	if (this.isModified('password') || this.isNew) {
		bcrypt.genSalt(10, function (err, salt) {
			if (err) {
				return next(err);
			}
			bcrypt.hash(cdevice.password, salt, function (err, hash) {
				if (err) {
					return next(err);
				}
				cdevice.password = hash;
				next();
			});
		});
	} else {
		return next();
	}
});

//Ceating compare Password Method
cdSchema.methods.comparePassword = function (candidatePassword, cb) {
	bcrypt.compare(candidatePassword, this.password, function (err, isMatch) {
		if (err) return cb(err);
		cb(null, isMatch);
	});
};

//Creating Model With name of "Users"
module.exports = mongoose.model('centralDevices', cdSchema);
