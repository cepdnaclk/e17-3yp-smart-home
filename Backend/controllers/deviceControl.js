let homes = require('../models/homes')
let devices = require('../models/devices')
let rooms = require('../models/rooms')

let functions ={
    addDevice: async function(req, res){
        try{
            if(req.body.homeid && req.body.roomid && req.body.deviceType && req.body.devicename && req.body.cdeviceid && req.body.port){
                devices.findOne({
                    devicename : req.body.devicename,
                }, (err, data)=>{
                    if (data){
                        return res.status(404).json({
                        success: false,
                        msg: "name already in use"
                        })
                    }else{
                        let newdevice = new devices({
                            devicename : req.body.devicename,
                            deviceType : req.body.deviceType,
                            homeid : req.body.homeid,
                            roomid : req.body.roomid
                        })
                        devices.create(newdevice).then(devicedoc=>{
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
                }   )
            }
        })
    }
}
        catch(err){
            console.log(err);
            return res.json({
                success: false,
                msg: err
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
                msg: err
            })
        }
        
    }
    
}
module.exports = functions