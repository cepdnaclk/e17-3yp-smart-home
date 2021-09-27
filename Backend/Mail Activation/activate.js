const nodemailer = require('nodemailer');
const { google } = require('googleapis');
const OAuth2 = google.auth.OAuth2;

const sendMail = (user) => {
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
	let token = randomString(user);
	const mailOptions = {
		from: email,
		to: clientMail,
		subject: 'Verify the Email',
		generateTextFromHTML: true,
		html: `<h2 style="color:green">digitalHuT<h2>Click <a href= " http://localhost:5005/api/user/validate/${uniqueString}"><button type="button">Verify!</button></a>`,
	};

	transporter.sendMail(mailOptions, (error, response) => {
		error ? console.log(error) : console.log(response);
		transporter.close();
	});
};
//Create jwt token with only mail
const randomString = (user) => {
	jwt.sign({ mail }, config.secret, { expiresIn: '2h' }, (err, token) => {
		if (user) {
			return res.json({ success: false, msg: err });
		} else {
			// var payload = jwt.decode(token, config.secret);
			return token;
		}
	});
};
module.exports = sendMail;
