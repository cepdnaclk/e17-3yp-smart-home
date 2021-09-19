var JwtStrategy = require('passport-jwt').Strategy,
	ExtractJwt = require('passport-jwt').ExtractJwt;

var User = require('../models/users');
var config = require('./dbconfig');

module.exports = function (passport) {
	var opts = {};
	opts.jwtFromRequest = ExtractJwt.fromAuthHeaderAsBearerToken('jwt');
	opts.secretOrKey = 'secret';
	passport.use(
		new JwtStrategy(opts, function (jwt_payload, done) {
			User.findOne({ id: jwt_payload.sub }, function (err, user) {
				if (err) {
					return done(err, false);
				}
				if (user) {
					return done(null, user);
				} else {
					return done(null, false);
					// or you could create a new account
				}
			});
		})
	);
};
