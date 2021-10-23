var mongoose = require('mongoose');
var schema = mongoose.Schema;

let deviceStatus = new schema({
    deviceid:{
        type:  schema.Types.ObjectId,
        ref: 'devices',
        require: true
    },
    Energy: {
		type: Number,
	},
	status: {
		type: Number,
		default: 0,
	},
    color:{
		type: String,
		default: '#FFFFFF'
	},

	brightness:{
		type : Number,
		default: 0
	},
	StartTime :{
		type: Date, default: Date.now
	},

	EndTime :{
		type: Date,
		default:Date.now
	},

	Schedule:{
		type: Date
		
	}
})