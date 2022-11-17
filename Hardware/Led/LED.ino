#include <FastLED.h>

#define LED_PIN     4
#define NUM_LEDS    44

CRGB leds[NUM_LEDS];

void setup() {

  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
  
}

void loop() {

  for (unsigned char i = 0; i <= 44; i++) {
    leds[i] = CRGB ( 0, 0, 255);
    FastLED.show();
    delay(120);
  }
  for (unsigned char i = 44; i >= 0; i--) {
    leds[i] = CRGB ( 255, 0, 0);
    FastLED.show();
    delay(120);
  }
    for (unsigned char i = 44; i >= 0; i--) {
    leds[i] = CRGB ( 200, 100, 100);
    FastLED.show();
    delay(120);
  }
}
