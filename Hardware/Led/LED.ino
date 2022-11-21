#include <FastLED.h>

// How many leds in your strip?
#define NUM_LEDS 44

// For led chips like Neopixels, which have a data line, ground, and power, you just
// need to define DATA_PIN.  For led chipsets that are SPI based (four wires - data, clock,
// ground, and power), like the LPD8806 define both DATA_PIN and CLOCK_PIN
#define DATA_PIN 4

// Define the array of leds
CRGB leds[NUM_LEDS];

void setup() { 
       FastLED.addLeds<WS2812, DATA_PIN, RGB>(leds, NUM_LEDS);
}

void loop() { 
  // Turn the LED on, then pause
  for(int i=0;i<NUM_LEDS;i++){
    leds[i] = CRGB::Red;
  }
  FastLED.show();
  delay(500);
  for(int i=0;i<NUM_LEDS;i++){
    leds[i] = CRGB::Green;
  }
  FastLED.show();
  delay(500);
  for(int i=0;i<NUM_LEDS;i++){
    leds[i] = CRGB::Blue;
  }
  FastLED.show();
  delay(500);
  // Now turn the LED off, then pause
  for(int i=0;i<NUM_LEDS;i++){
    leds[i] = CRGB::Black;
  }
  FastLED.show();
  delay(500);
}
