import android.content.*;
import android.content.*;
import android.net.wifi.*;
import android.view.*;
import android.os.*;
import android.app.*;
import ketai.sensors.*; 
import ketai.data.*;
/*
import android.content.Context;
import android.location.Criteria;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
*/
import android.view.WindowManager;
import android.view.View;
import android.os.Bundle;

KetaiSQLite db;
String CREATE_DB_SQL;
double longitude, latitude, altitude, accuracy;
//KetaiLocation location;
ALocation location;
WifiManager wifi;
List<ScanResult> wifiList;
WifiReceiver receiverWifi;

ArrayList<String> wifilistNew;
ArrayList<String> wifilistExisting;
boolean activeRecordWifi;
int lastScanMillis = 0;
int totalRecordsInDB;
String tableDatabase;
int lastmillis;


void setup()
{
  orientation(LANDSCAPE);
  textSize(28);
  textAlign(CENTER);
  wifilistNew = new ArrayList<String>();
  wifilistExisting = new ArrayList<String>();
  location = new ALocation(this);
  db = new KetaiSQLite(this, "gps.sqlite");
  setupDatabase();
  getAllRecordsDB();
  lastmillis = millis();// for gsp
  frameRate(5);
  activeRecordWifi = true;
}

void onResume()
{
  super.onResume();
}

// set app to avoid sleep without activity
void onCreate(Bundle bundle) 
{
  super.onCreate(bundle);
  // fix so screen doesn't go to sleep when app is active
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void draw()
{
  background(0, 0, 0);
  drawUI();
  if (activeRecordWifi && (millis()-lastScanMillis)>2500) {
    getLocation();
    getWifis();
    getAllRecordsDB();
    lastScanMillis = millis();
  }
}

void mousePressed()
{
  if (mouseY < 100)
  {
    if (mouseX < width/3) {

    }
    else if (mouseX > width/3 && mouseX < width-(width/3)) {

    }
    else {
      sendEmail();
    }
  }
}




