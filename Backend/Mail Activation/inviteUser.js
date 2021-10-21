const nodemailer = require('nodemailer');
const { google } = require('googleapis');
let jwt = require('jsonwebtoken');
const User = require('../models/users');
var config = require('../config/dbconfig');
const OAuth2 = google.auth.OAuth2;
const users = require('../models/users')
const homes = require('../models/homes')

//Functions
let functions = {
	invite : async function (user){

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
        
    };
    await transporter.sendMail(mailOptions, (error, response) => {
        error ? console.log(error) : console.log(response);
        transporter.close();
    });

},

	accept: function(req, res){
		try{
			users.findOne({name: req.body.username}, (err, doc)=>{
				doc.update({$push:{homes: req.body.homeid}})
				homes.findByIdAndUpdate(req.body.homeid, {$push:{ memberids: doc._id }},
					{new: true, useFindAndModify:false})
			})

			return res.json({
				success: true,
				msg: "Success Fully accepted"
			})
			

		}catch(err){
			return res.json({
                success: false,
                msg: err.message
            })
		}
	}

}
module.exports = functions