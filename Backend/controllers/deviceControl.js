const e = require('express')
let devices = require('../models/devices')
let rooms = require('../models/rooms')

let functions ={
    addDevice: async function(req, res){
        try{
            if (!req.body.roomid,
                !req.body.deviceType, 
                !req.body.devicename,
                !req.body.port)
            {
                    res.json({
                        success: false,
                        msg: "Enter all feilds for add device"
                    })
        }
            else{
                console.log("reached add device")
                devices.findOne({
                    devicename : req.body.devicename,
                }, (err, data) => {
                    if(err) res.json({success:false, msg:err.message})
                    if (data){
                        return res.status(404).json({
                        success: false,
                        msg: "name already in use"
                        })
                    }else{
                        let newdevice = new devices({
                            devicename : req.body.devicename,
                            deviceType : req.body.deviceType,
                            roomid: req.body.roomid,
                            port:parseInt(req.body.port)
                        })
                        devices.create(newdevice).then(devicedoc => {
                            console.log("Device Created");
							rooms.findByIdAndUpdate(req.body.roomid, 
								{ $push: { devices: devicedoc._id }},
								{ new: true, useFindAndModify: false },()=>{
									console.log("reached the update")
								}  );
                                return res.json({
                                    success: true,
                                    device: devicedoc,
                                    msg: "device successfully added"
                                })
                        }).catch((e) => {
                            console.log(e.message)
                            return res.json({success:false, msg: e.message})
                })
            }
        })
            }
}
        catch(err){
            console.log(err);
            return res.json({
                success: false,
                msg: err.message
            })
        }
    },
    getAllDevices:async function(req, res){
        try{
            if(req.body.roomid){
            let alldevices = await devices.find({roomid: req.body.roomid})
            return res.status(200).json({success: true, devices: alldevices})
            }else{
                return res.status(404).json({success:false, msg:"Entre the room id"})
            }
        }catch(err){
            
            return res.json({
                success: false,
                msg: err.message
            })
        }
    },
    deleteDevice: async function (req, res) {
        try {
            if (req.body.deviceid & req.body.roomid) {
                await devices.deleteOne({ _id: req.body.deviceid }, (err, doc) => {
                    if (err) {
                        return res.json({ success: false, msg: err.message });   
                    }
                    else if (doc) {
                        if (doc.userid != req.body.userid) {
                            return res.json({ success: false, msg: "Device_id not from this user" });
                        }                    
                    } else {
                        return res.json({success:false, msg: "Device id not found!"})
                    }
                });
                await rooms.findByIdAndUpdate(req.body.roomid, { $inc: { numberOfDevices: -1 } }, (err, doc) => {
                    if (err) {
                        return res.json({ success: false, msg: err.message });   
                    }
                    if (!doc) {
                        return res.json({success:false, msg: "room id not found!"})
                    }
                })
                return res.json({success:true, msg: "Device id not found!"})
            } else {
                return res.status(404).json({ success: false, msg: "Enter the device id" });
            }
        } catch(err){
            return res.json({
                success: false,
                msg: err.message
            })
        }
    }
}
module.exports = functions