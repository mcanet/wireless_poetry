/*

 1. Using SD card using the SD library.
 2. Taking wifi names 
 3. GPS

 --------------------------------------------------------	
 The circuit:
 * analog sensors on analog ins 0, 1, and 2
 * SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13
 ** CS - pin 4	 
 --------------------------------------------------------
 */
// Wifi shield libraries
#include <SPI.h>
#include <WiFiwo.h>
// SD storage libraries
#include <SD.h>
// newSoftSerial
//#include <SoftwareSerial.h>
// GPS
#include <Adafruit_GPS.h>
// LCD
#include <LiquidCrystal.h>
// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

Adafruit_GPS GPS(&Serial);

String dataString; 
// On the Ethernet Shield, CS is pin 4. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 4;

uint32_t timer = millis();
uint32_t timer2 = millis();
uint32_t timer3 = millis();

File dataFile;

WiFiClass* WiFi;

int counter = 0;
String latitude;
String longitude;

String listWifiNames[15];

int totalWifis;
int timeUpdateWifis;
int i;

void setup()
{ 
  // 9600 NMEA is the default baud rate for Adafruit MTK GPS's- some use 4800
  Serial.begin(9600);
  //Serial.print("Initializing SD card...");
  
  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  //Serial.println("card initialized.");
  WiFi = new WiFiClass();
  latitude = "";
  longitude = "";
  i = 0;
  totalWifis = 0;
}

void loop()
{
  delay(1000);
  getNetworks();
  loopGPS();
}

void getNetworks(){
  if (millis() - timer2 > 30000) { 
    // scan for existing networks:
    listNetworks();
    // readSDCard(); // just for testing
    timer2 = millis();
    counter += 1;
    delete WiFi;
    WiFi = new WiFiClass();
  }
}












