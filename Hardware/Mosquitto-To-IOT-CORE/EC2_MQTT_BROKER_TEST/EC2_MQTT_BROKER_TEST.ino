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
  doc["time"] = millis();
  doc["sensor_a0"] = random(1000);
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}

void rgb(unsigned r, unsigned g, unsigned b, unsigned char port, unsigned char br)
{
  Serial.println("RGB.....");

  if(port == 1){
    Serial.println(port);
    Serial.println(r);
    Serial.println(g);
    Serial.println(b);
    for (unsigned char i = 0; i <= 44; i++) {
      leds_port_1[i] = CRGB ( r, g, b);
      //FastLED.setBrightness(br);
      //FastLED.show();
    }
    FastLED.setBrightness(br);
    FastLED.show();
  }
  else if(port == 2){
    Serial.println(port);
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
  unsigned char port = doc["port"];
  unsigned char r  = doc["r"];
  unsigned char g  = doc["g"];
  unsigned char b  = doc["b"];
  
  if (d_t == 1) // 49 is the ASCI value of 1
  {
    Serial.println("RGB Call");
    //digitalWrite(lamp, HIGH);
    rgb(r, g, b, port, 255);   
  }
  else if (d_t == 0) // 48 is the ASCI value of 0
  {
    //digitalWrite(lamp, LOW);
    Serial.println("Lamp_State changed to LOW");
  }
  Serial.println();
}


void setup() {
  Serial.begin(115200);
  connectAWS();
  FastLED.addLeds<WS2812, LED_PIN_1, GRB>(leds_port_1, NUM_LEDS);
  FastLED.addLeds<WS2812, LED_PIN_2, GRB>(leds_port_2, NUM_LEDS);
//  rgb(0,0,255,2,255);
//  delay(3000);
//  rgb(0,0,255,2,50);
//  delay(3000);
}

void loop() {
  publishMessage();
  client.loop();

  Serial.println("!!!");
  
}
