const epress = require('express');
const router = express.Router();
const path = require('path');
const action = require('./methods/action');
router.post('/api/adduser', action.addNew);

module.exports = router;
