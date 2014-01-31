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
#include <WiFi.h>
// SD storage libraries
#include <SD.h>
// newSoftSerial
//#include <SoftwareSerial.h>
// GPS
//#include <Adafruit_GPS.h>

//SoftwareSerial mySerial(3, 2);
//Adafruit_GPS GPS(&mySerial);

String dataString; 
// On the Ethernet Shield, CS is pin 4. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 4;

uint32_t timer = millis();
uint32_t timer2 = millis();

File dataFile;

void setup()
{ 
  Serial.begin(9600);
  Serial.print("Initializing SD card...");
  
  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");
  //setupGPS();
}

void loop()
{
  delay(1000);
  getNetworks();
  //loopGPS();
}

void getNetworks(){
  if (millis() - timer2 > 10000) { 
    // scan for existing networks:
    listNetworks();
    // readSDCard(); // just for testing
    timer2 = millis();
  }
}












