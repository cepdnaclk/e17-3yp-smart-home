#include <FastLED.h>
#define LED_PIN 4
#define NUM_LEDS 3

CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
  FastLED.setMaxPowerInVoltsAndMilliamps(5, 500);
  FastLED.clear();
  FastLED.show();
}

void loop() {
  // RED Green Blue
for (int i=0; i<NUM_LEDS; i++ )
{
    leds[i] = CRGB(0, 255-6*i, 20*i );
    FastLED.setBrightness(255);
    FastLED.show();
    delay (250);
} 
for (int i=NUM_LEDS; i> 0; i-- )
{
    leds[i] = CRGB(20*i, 0, 255-20*i );
    FastLED.setBrightness(100);
    FastLED.show();
        delay (250);
}

for (int i=NUM_LEDS; i> 0; i-- )
{
    leds[i] = CRGB(20*i, 0, 255-20*i );
    FastLED.setBrightness(10);
    FastLED.show();
        delay (250);

}
}
