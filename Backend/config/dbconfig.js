require('dotenv').config();

module.exports = {
	secret: process.env.DB_ENCRYPT,
	database: process.env.DB_URI,
};
