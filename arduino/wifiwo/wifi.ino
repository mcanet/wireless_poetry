void listNetworks() {
  // scan for nearby networks:
  //Serial.println("** Scan Networks **");
  byte numSsid = WiFi->scanNetworks();
  // print the list of networks seen:
  //Serial.print("number of available networks:");
  //Serial.println(numSsid);
  // print the network number and name for each network found:
  
  if(numSsid>0){
    openSDCard();
    for (int thisNet = 0; thisNet<numSsid; thisNet++) {
      String w = "";
      /*
      Serial.print(thisNet);
      Serial.print(") ");
      Serial.print(WiFi->SSID(thisNet));
      Serial.print("\tSignal: ");
      Serial.print(WiFi->RSSI(thisNet));
      Serial.print(" dBm");
      Serial.print("\tEncryption: ");
      Serial.println(WiFi->encryptionType(thisNet));
      */
      // Save to SD
      w = String(WiFi->SSID(thisNet))+","+String(WiFi->RSSI(thisNet))+","+String(WiFi->encryptionType(thisNet))+","+latitude+","+longitude;
      saveInSDCard(w);
    }
    closeSDCard();
    
    // calculate time for scroll wifi name in lcd
    totalWifis = numSsid;
    timeUpdateWifis = 30/numSsid;
    if(timeUpdateWifis<2000) timeUpdateWifis = 2000;
    //Serial.print("\tEnd saving SD ");
  }
}
