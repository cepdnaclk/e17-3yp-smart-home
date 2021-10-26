// const dotenv = require('dotenv');
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const mongodbConnect = require('./config/dbs');
const rateLimit = require("express-rate-limit");
const passport = require('passport');
const bodyParser = require('body-parser');
const route = require('./routes/UserRoute');
const homeRoutes = require('./routes/homeRoute');
const roomRoutes = require('./routes/roomRoute')
const deviceRoute = require('./routes/deviceRoute')
const cdevice = require('./routes/cdeviceRoute')
const nonActive = require('./routes/NonActiveCdeviceRoute')
//connect to database
mongodbConnect();

const app = express();
app.use(
	rateLimit({
	  windowMs:  60 * 60 * 1000, // 1 hour duration in milliseconds
	max: 2000,
	message: "You exceeded 200 requests in 1 hour limit!",
	headers: true,
	})
);


app.use(cors());
// app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.json());
app.use( route);
app.use(homeRoutes);
app.use(roomRoutes);
app.use(deviceRoute);
app.use(cdevice);
app.use(nonActive);
app.use(passport.initialize());
require('./config/passport')(passport);

/*
Concise output colored by response status for development use. 
The :status token will be colored 
green for success codes,
red for server error codes, 
yellow for client error codes, 

and uncolored for information codes.
*/
if (process.env.NODE_ENV === 'development') {
	app.use(morgan('dev'));
}
// console.log("server");

//Port Declaring
const PORT = process.env.PORT || 5005;
app.listen(
	PORT,
	console.log(
		` Servever Listening to ${process.env.NODE_ENV} mode on port ${PORT} `
	)
);
