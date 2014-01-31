class WifiReceiver extends BroadcastReceiver {
  public void onReceive(Context c, Intent intent) {
    try {
      wifiList = wifi.getScanResults();
      wifilistNew.clear();
      wifilistExisting.clear();
      if (activeRecordWifi) {
        for (int i = 0; i < wifiList.size(); i++) {
          String wifiSpotRawStr = (wifiList.get(i)).toString();
          String[] listAr = split(wifiSpotRawStr, ",");
          String name          = split(listAr[0], ":")[1];
          String macAddress    ="";
          String macAddressAr[]= split(listAr[1], ":");
          for (int j=1;j<macAddressAr.length;j++) {
            macAddress    +=macAddressAr[j]+":";
          }
          macAddress = macAddress.substring(0, macAddress.length()-1);
          String capabilities  = split(listAr[2], ":")[1];
          String level         = split(listAr[3], ":")[1];// in db
          String frequency     = split(listAr[4], ":")[1];// channels
          String timestamp     = split(listAr[5], ":")[1];
          int levelBefore = isThisMacAddressInDB(macAddress);
          println(levelBefore);
          if (levelBefore==-1) {
            insertDataDB(name, macAddress, capabilities, level, frequency, timestamp);
            wifilistNew.add(wifiSpotRawStr);
          }
          else {
            wifilistExisting.add(wifiSpotRawStr);
            int currentWifiLevel = int(level);
            // if db are high and have good gps accuracy update from inicial
            if(levelBefore>currentWifiLevel && accuracy < 32.0){
              updateDataDB(macAddress,level);
            }
          }
        }
      }
    }
    catch(Exception e) {
      println("Error on receive wifis");
    }
  }
}

void getWifis() {
  try {
    wifi = (WifiManager) getSystemService(Context.WIFI_SERVICE);
    // Get WiFi status
    receiverWifi = new WifiReceiver();
    registerReceiver(receiverWifi, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
    wifi.startScan();
  }
  catch(Exception e) {
    println("error getWifis");
  }
}

