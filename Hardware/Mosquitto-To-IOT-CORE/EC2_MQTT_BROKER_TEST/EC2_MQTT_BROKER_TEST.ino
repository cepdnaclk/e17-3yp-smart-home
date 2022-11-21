#include "secrets.h"
#include <WiFiClientSecure.h>
#include <MQTTClient.h>
#include <ArduinoJson.h>
#include "WiFi.h"
#include <FastLED.h>

// The MQTT topics that this device should publish/subscribe
#define AWS_IOT_PUBLISH_TOPIC   "esp32/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/sub"

//RGBLights
#define NUM_LEDS 44

//RGB1
#define LED_PIN_1 4
CRGB leds_port_1[NUM_LEDS];

//RGB 2
#define LED_PIN_2 2
CRGB leds_port_2[NUM_LEDS];

//globals
unsigned char d_t = 1;
bool state =0;
unsigned char port =1;
unsigned char r = 0;
unsigned char g = 0;
unsigned char b = 0;
unsigned char brtns = 0;

WiFiClientSecure net = WiFiClientSecure();
MQTTClient client = MQTTClient(256);

//***************************************CONNECTAWS*********************************/
void connectAWS()
{
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
  client.onMessage(messageHandler);
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


//***************************************PUBLISH MESSAGE********************************
void publishMessage()
{
  StaticJsonDocument<200> doc;
  doc["time"] = millis();
  doc["sensor_a0"] = random(1000);
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}

//***************************************RGB FUNCTION***********************************
void rgb(unsigned char r, unsigned char g, unsigned char b, unsigned char port, unsigned char br)
{
  Serial.println("RGB.....");
  if(port == 1){    
    for (unsigned char i = 0; i <= 44; i++) {
      leds_port_1[i] = CRGB ( r, g, b);
      Serial.print(i);
    }
    FastLED.show();
  } //port==1
  
  else if(port == 2){
    Serial.println(port);
    for (unsigned char i = 0; i <= 44; i++) {
      leds_port_2[i] = CRGB ( r, g, b);;
    }
    FastLED.setBrightness(br);
    FastLED.show();
  }
  
}///RGB Function

//*********************************MESSAGE HANDLER*************************************
void messageHandler(String &topic, String &payload ) {
  Serial.println("incoming: " + topic + " - " + payload);
  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  d_t = doc["d_t"];  //RGB 1 // plug 2 // normal 3 //fan 4  //device type
  port = doc["port"];
  state = doc["state"];
  Serial.println(d_t);
  Serial.println(port);
  Serial.println(state);
  
  if (d_t == 1) 
  {
    Serial.println("1. RGB Call");
     brtns = doc["brtns"];
     r  = doc["r"];
     g  = doc["g"];
     b  = doc["b"];
    Serial.println("color");
    Serial.println(r);
    Serial.println(g);
    Serial.println(b);
    if(state==1)
      rgb(r, g, b, port, brtns);  
    else
      rgb(0,0,0,port,0); 
  }
  else if (d_t == 2) // 48 is the ASCI value of 0
  {
    Serial.println("2. Smart Plug/White Light call...");
    if(port==3){
      Serial.println("port 3: ");
      if(state==1){
        Serial.print("12 high");
        digitalWrite(12, LOW); 
      }else{
        digitalWrite(12, LOW);
        Serial.print("12 HIGH");
      }
    }
    if(port==4){
      Serial.println("port 4: ");
      if(state==1)
        digitalWrite(14, LOW); 
      else
        digitalWrite(14, HIGH);
    } 
  }
}


//**************************************SETUP FUNCTION******************************
void setup() {
  Serial.begin(115200);
  connectAWS();

  //RGB
  FastLED.addLeds<WS2812, LED_PIN_1, GRB>(leds_port_1, NUM_LEDS);
  FastLED.addLeds<WS2812, LED_PIN_2, GRB>(leds_port_2, NUM_LEDS);
  rgb(0,0,0,1,0);

  //SMART PLUG
  pinMode(12, OUTPUT);

  //WHITE BULB
  pinMode(14, OUTPUT);  
}

//*********************************LOOP RUNS*****************************************
void loop() {
  publishMessage();
  client.loop();
//  FastLED.show();
  delay(10);
  
}
