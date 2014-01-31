void listNetworks() {
  // scan for nearby networks:
  Serial.println("** Scan Networks **");
  byte numSsid = WiFi.scanNetworks();
  // print the list of networks seen:
  Serial.print("number of available networks:");
  Serial.println(numSsid);
  // print the network number and name for each network found:
  String w ="";
  if(numSsid>0){
    for (int thisNet = 0; thisNet<numSsid; thisNet++) {
      Serial.print(thisNet);
      Serial.print(") ");
      Serial.print(WiFi.SSID(thisNet));
      Serial.print("\tSignal: ");
      Serial.print(WiFi.RSSI(thisNet));
      Serial.print(" dBm");
      Serial.print("\tEncryption: ");
      Serial.println(WiFi.encryptionType(thisNet));
      // Save to SD
      w += String(WiFi.SSID(thisNet))+","+String(WiFi.RSSI(thisNet))+","+String(WiFi.encryptionType(thisNet))+",\n";
    }
    
    // writting in micro-SD
    delay(500);
    Serial.print("\tStart saving SD ");
    openSDCard();
    saveInSDCard(w);
    closeSDCard();
    Serial.print("\tEnd saving SD ");
    
  }
}
