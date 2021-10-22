const { json } = require('body-parser');
var cdevice = require('../models/centralDevice');
var nonActiveCDevice = require('../models/nonActiveCDevice');

let functions = {

    addNonActive: async function(req, res){
        try{
            nonActiveCDevice.findOne({cdeviceNumber: req.body.cdeviceNumber},(err,data)=>{
                if(err) return res.json({success: false, msg: err.message})
                if(data) return res.json({success:false, msg:"CDevive Number Already in NonActive devices"})
                
                let device =  nonActiveCDevice({
                    cdeviceNumber : req.body.cdeviceNumber,
                    password : req.body.password
                })
                device.save()
                return res.json({success: true, msg:"SuccessFully added!"})
            })

        }catch (err) {
			console.log( err.message);
			return res.json({
                success: false,
                msg: err.message
            })
		}
    },
    
    removeByNumber : function(req, res){
        try{
            nonActiveCDevice.findOne({cdeviceNumber:req.body.cdeviceNumber}, (err, doc)=>{
                if(err) return res.json({success: false, msg: err.message})
                if(!data) return res.json({success:false, msg:"CDevive Number Not in NonActive devices"})
                doc.remove()
                return res.json({ success: true, msg: "SuccessFully Remob=ved"})
            })

        }catch(err){
            return res.json({ success: false, msg: err.message})
        }
    }



}

module.exports = functions