
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
//char color_1 = 'w'; //Default color

//RGB 2
#define LED_PIN_2 2
CRGB leds_port_2[NUM_LEDS];
//char color_2 = 'w'; //Default color

//Global
unsigned char brtns=0;
unsigned char r1=0;
unsigned char g1=0;
unsigned char b1=0;
unsigned char r2=0;
unsigned char g2=0;
unsigned char b2=0;
unsigned char port=1;

WiFiClientSecure net = WiFiClientSecure();
MQTTClient client = MQTTClient(256);

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

void publishMessage()
{
  StaticJsonDocument<200> doc;
  doc["device_id"] = " 6379a517ffd5955fee9b320d";
  doc["port"] = "6";
  doc["Energy"] = 69;
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}

void rgb(unsigned r, unsigned g, unsigned b, unsigned char port, unsigned char br)
{
  //Serial.println("RGB.....");

  if(port == 1){
//    Serial.println(port);
//    Serial.println(r);
//    Serial.println(g);
//    Serial.println(b);
    for (unsigned char i = 0; i <= 44; i++) {
      leds_port_1[i] = CRGB ( r, g, b);
      //FastLED.setBrightness(br);
      //FastLED.show();
    }
    FastLED.setBrightness(br);
    FastLED.show();
  }
  else if(port == 2){
//    Serial.println(port);
    for (unsigned char i = 0; i <= 44; i++) {
      leds_port_2[i] = CRGB ( r, g, b);
    }
    FastLED.setBrightness(br);
    FastLED.show();
  }
  
}

void messageHandler(String &topic, String &payload ) {
  Serial.println("incoming: " + topic + " - " + payload);
  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  unsigned char d_t = doc["d_t"];  //RGB 1 // plug 2 // normal 3 //fan 4  //device type
  port = doc["port"];
  bool state = doc["state"];

  
//  Serial.println(doc);
    Serial.println(d_t);
    Serial.println(port);
    Serial.println(state);
  
  if (d_t == 1) // 49 is the ASCI value of 1
  {
    Serial.println("1. RGB Call");
    
    brtns = doc["brtns"];
    if(port==1){
      r1  = doc["r"];
      g1  = doc["g"];
      b1  = doc["b"];
    }
    if(port==2){
      r2  = doc["r"];
      g2  = doc["g"];
      b2  = doc["b"];
    }
    Serial.println(state);
    Serial.println(brtns);
    Serial.println(r1);
    Serial.println(g1);
    Serial.println(b1);

    if(state==1 && port==1){
      rgb(r1, g1, b1, port, brtns);  
    }if(state==1 && port==2){
      rgb(r2, g2, b2, port, brtns);  
    }else if(state==0 && port==1){
      r1=0;
      g1=0;
      b1=0;
      brtns=0;
      rgb(0,0,0,1,0);
    }else if(state==0 && port==2){
      r2=0;
      g2=0;
      b2=0;
      brtns=0;
      rgb(0,0,0,2,0);
    }
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
        digitalWrite(12, HIGH);
        Serial.print("12 low");
      }
    }
    if(port==4){
      Serial.println("port 4: ");
      if(state==1){
        digitalWrite(14, LOW); 
        Serial.print("14 high");
      }else{
        digitalWrite(14, HIGH);
        Serial.print("14 low");
      }
    }
    
  }

}


void setup() {
  Serial.begin(9600);
  connectAWS();

  //RGB
  FastLED.addLeds<WS2812, LED_PIN_1, GRB>(leds_port_1, NUM_LEDS);
  FastLED.addLeds<WS2812, LED_PIN_2, GRB>(leds_port_2, NUM_LEDS);
  rgb(0,0,0,1,0);
  rgb(0,0,0,2,0);

  //SMART PLUG
  pinMode(12, OUTPUT);

  //WHITE BULB
  pinMode(14, OUTPUT);
}

void loop() {
  publishMessage();
  client.loop();

  rgb(r1,g1,b1,1,brtns);
  rgb(r2,g2,b2,2,brtns);
  //delay(20);
}
