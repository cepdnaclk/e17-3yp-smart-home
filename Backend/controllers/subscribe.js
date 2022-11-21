const mqtt = require('mqtt')
const devices = require('../models/devices');
const nodeSchedule = require("node-schedule")

const clientId = "nodeJs_Application"
const options = {
    clientId,
}
let topic = "esp32/pub"


const subscribe = async function () {
    try {
        let client = mqtt.connect("mqtt://127.0.0.1:1883", options);
        client.on('connect', () => {
            console.log('Connected to MQTT broker...')
            client.subscribe([topic])
            console.log(`Subscribed to ${topic}`)
        })
        client.on('message', function (topic, message) {
            console.log("Message received", message.toString())
            let payload = JSON.parse(message.toString());
            // if (payload.d_t === 1) {
            //     console.log("rgb")
            // }
            console.log(payload); 
        })
    } catch (e) {
        console.log(e.message);
    }

} 
subscribe()



module.exports = subscribe