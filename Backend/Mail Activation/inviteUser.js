const nodemailer = require('nodemailer');
const { google } = require('googleapis');
let jwt = require('jsonwebtoken');
const User = require('../models/users');
var config = require('../config/dbconfig');
const OAuth2 = google.auth.OAuth2;

let invite = async()=>{

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

    const mailOptions = {
        from: email,
        to: clientMail,
        subject: 'Verify the Email',
        generateTextFromHTML: true,
        html: '<h2 style="color:green">digitalHuT</h2>Click <a href= " http://localhost:5001/api/user/validate?"><button type="button">Verify!</button></a>',
    };
    await transporter.sendMail(mailOptions, (error, response) => {
        error ? console.log(error) : console.log(response);
        transporter.close();
    });
}