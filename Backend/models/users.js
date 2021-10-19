var mongoose = require('mongoose');
var schema = mongoose.Schema;
var bcrypt = require('bcrypt');




var userSchema = new schema({
	name: {
		type: String,
		require: true,
		unique: true,
	},
	mail: {
		type: String,
		require: true,
		unique: true,
		lowercase: true,
	},
	password: {
		type: String,
		require: true,
	},
	homes: [{
		type: schema.Types.ObjectId,
		ref : 'homes'
}],
	

});

// console.log(typeof(userSchema))
//Using bcrypt algorithm to encrypt the user password
userSchema.pre('save', function (next) {
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
userSchema.methods.comparePassword = function (candidatePassword, cb) {
	bcrypt.compare(candidatePassword, this.password, function (err, isMatch) {
		if (err) return cb(err);
		cb(null, isMatch);
	});
};

//Creating Model With name of "Users"
module.exports = mongoose.model('users', userSchema);
