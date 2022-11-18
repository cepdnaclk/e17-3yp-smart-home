#include "secrets.h"
#include <WiFiClientSecure.h>
#include <MQTTClient.h>
#include <ArduinoJson.h>
#include "WiFi.h"
#include <FastLED.h>

// The MQTT topics that this device should publish/subscribe
#define AWS_IOT_PUBLISH_TOPIC   "esp32/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/sub"

//Light
#define lamp 23
#define NUM_LEDS 44
#define LED_PIN 4

bool state = 0;
CRGB leds[NUM_LEDS];
TaskHandle_t NetTaskHandle;


WiFiClientSecure net = WiFiClientSecure();
MQTTClient client = MQTTClient(256);

/***********************CONNECT TO AWS*********************************/
void connectAWS()
{
//  Connect to wifi
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.println("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }
  // Configure WiFiClientSecure to use the AWS IoT device credentials
  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);
  // Connect to the MQTT broker on the AWS endpoint we defined earlier
  client.begin(AWS_IOT_ENDPOINT, 8883, net);
  // Create a message handler
  client.onMessage(messageHandler);   //Handle the Subscribed message from server
  Serial.print("Connecting to AWS IOT");
  while (!client.connect(THINGNAME)) {
    Serial.print(".");
    delay(100);
    
  }
  if(!client.connected()){
    Serial.println("AWS IoT Timeout!");
    return;
  }
  // Subscribe to a topic
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
  Serial.println("AWS IoT Connected!");
}

/*********************************MESSAGE PUBLISHER***************8**************************/
void publishMessage()
{
  StaticJsonDocument<200> doc;
  doc["time"] = millis();
  doc["sensor_a0"] = random(1000);
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}

/***********************************RUN RGB******************************************/
void rgb()
{
  Serial.println("RGB ON.....");
  for (unsigned char i = 0; i <= 44; i++) {
  leds[i] = CRGB ( 255, 0, 0);
    FastLED.show();
    delay(1000);
    state = 0;
  } 
}


/***********************************MESSAGE HANDLER************************************************/
void messageHandler(String &topic, String &payload ) {
  Serial.println("incoming: " + topic + " - " + payload);
  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  unsigned char d_t = doc["d_t"];  //RGB 1 // plug 2 // normal 3 //fan 4
  unsigned char led = doc["port"];
  if (d_t == 1) // 49 is the ASCI value of 1
  {
    Serial.println(led);
    digitalWrite(lamp, HIGH);
    Serial.println("Lamp_State changed to HIGH");
    state = 1;
    Serial.println(state);
  }
  else if (d_t == 0) // 48 is the ASCI value of 0
  {
    digitalWrite(lamp, LOW);
    Serial.println("Lamp_State changed to LOW");
  }
  Serial.println();
}

//****************************SETUP ********************************************/
void setup() {
  Serial.begin(115200);
  connectAWS();     //Connect to the AWS
  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
}

//*******************************LOOP******************************************/
void loop() {
  publishMessage();
  client.loop();
  if(state){
    rgb();
  }else{
      Serial.println("RGB ON.....");
  for (unsigned char i = 0; i <= 44; i++) {
  leds[i] = CRGB ( 0, 0, 0);
    FastLED.show();
    delay(1000);
  }
  delay(50);
}
}
