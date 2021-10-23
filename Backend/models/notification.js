var mongoose = require('mongoose');
var schema = mongoose.Schema;


let notificationSchema = new schema({
    sender:{
        type:schema.Types.ObjectId,
		ref: 'users',
		require: true
    },
    receiver:{
        type:schema.Types.ObjectId,
		ref: 'users',
		require: true
    },
    homeid: {
        type: schema.Types.ObjectId,
		ref : 'homes',
        require: true
    }
})

module.exports = mongoose.model('notification', notificationSchema);