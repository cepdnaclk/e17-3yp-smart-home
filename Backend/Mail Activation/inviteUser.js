const nodemailer = require('nodemailer');
const { google } = require('googleapis');
let jwt = require('jsonwebtoken');
const User = require('../models/users');
var config = require('../config/dbconfig');
const OAuth2 = google.auth.OAuth2;
const users = require('../models/users')
const homes = require('../models/homes');
const notification = require('../models/notification');

//Functions
let functions = {
	invite : async function (req,res){

		try{
			users.findOne({name: req.body.username}, (err, data)=>{
				if(err) return res.status(500).json({success:false, msg:err.message})
				if(data) return res.status(200).json({success:true, userid: data._id,username:data.name, msg:"User exist"})
				return res.status(201).json({success:false, msg:"user name does not exist,"})
			})
		}catch(err){
			return res.json({
                success: false,
                msg: err.message
            })
		}

},

	accept: function(req, res){
		try{
			if(req.body.notificationid){
				notification.findById(req.body.notificationid, (err, data)=>{
					if(err) return res.status(500).json({success:false, msg:err.message})
					let receiver = data.receiver
					let homeid = data.homeid
					users.findById(receiver, (err, doc)=>{
						console.log(doc.homes.includes(homeid), doc)
						if(!doc) return res.status(404).json({success: false, msg:"User Not exist!"})
						if(doc.homes.includes(homeid)) return res.status(408).json({success:false, msg:"invitation Already accepted"})
						doc.homes.push(homeid)
						doc.save()
						homes.findByIdAndUpdate(homeid, {$push:{ memberids: doc._id }},
							{new: true, useFindAndModify:false})

							return res.json({
								success: true,
								msg: "Success Fully accepted"
							})
					})
					
				})

			}else{
				return res.status(404).json({success: false, msg: "Send the notificationid"})
			}
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
	},

	sendnotification: async function(req, res){
		try{
			let newNotification = notification({
				sender: req.body.senderId,
				receiver: req.body.receiverId,
				homeid: req.body.homeid
			})
			newNotification.save(function(err, notific){
				if(err) return res.json({success:false, msg:err.message})
				return res.json({success:true, notification:notific, msg:"successfull" })
			})
			
		}catch(err){
			return res.json({
                success: false,
                msg: err.message
            })
		}
	},
	getNotification: async function (req, res){
		try{
			notification.findOne({receiver: req.body.receiverId}).populate('sender').populate('homeid').exec(function(err, doc){
				if (err){ return res.json({success:false, msg:err.message})
			}else{
				return res.status(200).json({success:true, senderName: doc.sender.name, home: doc.homeid.homename , homeid: doc.homeid, notificationid: doc._id})
			}
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