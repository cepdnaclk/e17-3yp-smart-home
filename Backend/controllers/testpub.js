
let homes = require('../models/homes')


let mqtt = require('mqtt');
const clientId = "digitalHut_smartBulb"

let client = mqtt.connect("mqtt://127.0.0.1:1883");
client.on('connect', () => {
    setInterval(function () {
        var random = Math.random() * 50;
        console.log(random);
        if (random < 30) {
            client.publish('esp32/pub', "simple MQTT using HiveMQ")
        }
    }), 30000;
    
}
)

