const mongoose = require('mongoose');
const dbconfig = require('./dbconfig');

const connectDB = async () => {
	try {
		const connect = await mongoose.connect(dbconfig.database);
		console.log(`MongoDB connected: ${connect.connection.host}`);
	} catch (err) {
		console.log(err);
		process.exit(1);
	}
};

module.exports = connectDB;
