const nodemailer = require('nodemailer');
const { google } = require('googleapis');
let jwt = require('jsonwebtoken');
const User = require('../models/users');
var config = require('../config/dbconfig');
const OAuth2 = google.auth.OAuth2;

const sendMail = async (user) => {
	// const userControl = require('../Mail Activation/activate.js');
	const email = process.env.Email;
	const clientId = process.env.CLIENT_ID;
	const clientSecret = process.env.CLIENT_SECRET;
	const refresh = process.env.REFRESH_TOKEN;
	const clientMail = user.mail;
	const redirect_uri = process.env.REDIRECT_URI;

	const oauth2Client = new OAuth2(clientId, clientSecret, redirect_uri);

	oauth2Client.setCredentials({
		refresh_token: refresh,
	});
	const newAccessToken = oauth2Client.getAccessToken();

	let transporter = nodemailer.createTransport(
		{
			service: 'Gmail',
			auth: {
				type: 'OAuth2',
				user: email,
				clientId: clientId,
				clientSecret: clientSecret,
				refreshToken: refresh,
				accessToken: newAccessToken,
			},
		},
		{
			// default message fields

			// sender info
			from: `From digitalHuT ${email}`,
		}
	);

	const createAccessToken = (user) => {
		return jwt.sign({ user }, config.secret, {
			expiresIn: '15m',
		});
	};
	const newtoken = await createAccessToken(user);
	// console.log('newtoken', newtoken);

	const createMail = async (token_1) => {
		// console.log('create Mail', token_1);
		const mailOptions = {
			from: email,
			to: clientMail,
			subject: 'Verify the Email',
			generateTextFromHTML: true,
			html: `<h2 style="color:green">digitalHuT<h2>Click <a href= " http://54.174.154.229:5001/api/user/validate?token=${token_1}"><button type="button">Verify!</button></a>`,
		};
		await transporter.sendMail(mailOptions, (error, response) => {
			error ? console.log(error) : console.log(response);
			transporter.close();
		});
	};
	createMail(newtoken);
};

module.exports = sendMail;
