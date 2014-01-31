void drawUI()
{
  try {
    pushStyle();
    textAlign(LEFT);
    fill(0);
    stroke(255);
    if (activeRecordWifi) { 
      fill(0, 255, 0);
    }
    else { 
      fill(255, 0, 0);
    }
    rect(0, 0, width/3, 100);
    fill(0);
    rect(width/3, 0, width/3, 100);
    rect((width/3)*2, 0, width/3, 100);
    fill(255);
    text("Show wifis", 5, 60); 
    text("Show plot", width/3 + 5, 60); 
    text(Integer.toString(totalRecordsInDB), width/3*2 + 5, 60); //"Send database by email" 
    popStyle();

    pushStyle();
    textSize(80);
    textAlign(LEFT);
    fill(250, 255, 0);
    text(Integer.toString(wifilistNew.size()), 20, 200);
    text(Integer.toString(wifilistExisting.size()), 20, 280);
    // list all wifis
    textSize(20);
    for (int i = 0; i < wifilistNew.size(); i++) {
      int y= 180+(20*i);
      fill(255);
      text(wifilistNew.get(i), 120, y);
    }
    fill(250, 0, 0);
    for (int i = 0; i < wifilistExisting.size(); i++) {
      int y= 180+(20*(i+wifilistNew.size()));
      fill(255);
      text(wifilistExisting.get(i), 120, y);
    }
    popStyle();

    // GPS
    pushStyle();
    textSize(20);
    textAlign(LEFT);
    if (location.getLocation() == null) {
      fill(255, 0, 0);
      text("Location data is unavailable.Please check your location settings.", 120, 120, width, height);
    } 
    else {
      fill(0, 255, 0);
      text("Latitude: " + latitude + 
        " Longitude: " + longitude + 
        " Altitude: " + altitude +  
        " Accuracy: " + accuracy, 120, 120, width, height);
    }
    popStyle();
  }
  catch(Exception e) {
  }
}

