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
	},
	cancel: function(req, res){
		try{
			return res.json({
				success : true,
				msg: "canceled"
			})
		}catch{
			return res.json({
                success: false,
                msg: err.message
            })
		}
	}

}
module.exports = functions