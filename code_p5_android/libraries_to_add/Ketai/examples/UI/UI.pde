import android.content.*;
import android.content.*;
import android.net.wifi.*;
import ketai.sensors.*; 
import ketai.data.*;

KetaiSQLite db;
String CREATE_DB_SQL = "CREATE TABLE data ( _id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER NOT NULL DEFAULT '0');";
double longitude, latitude, altitude;
KetaiLocation location;
WifiManager wifi;
List<ScanResult> wifiList;
WifiReceiver receiverWifi;

ArrayList<String> wifilist;
boolean activeRecordWifi;
int lastScanMillis = 0;

void setup()
{
  orientation(LANDSCAPE);
  textSize(28);
  textAlign(CENTER);
  wifilist = new ArrayList<String>();
  activeRecordWifi = false;
  location = new KetaiLocation(this);
  db = new KetaiSQLite(this);
  //setupDatabase();
}

void draw()
{
  background(0, 0, 0);
  drawUI();
  if (activeRecordWifi && (millis()-lastScanMillis)>5000) {
    getWifis();
  }
}

void mousePressed()
{
  if (mouseY < 100)
  {
    if (mouseX < width/3) {
      activeRecordWifi = true;
    }
    else if (mouseX > width/3 && mouseX < width-(width/3)) {
      // pause
      activeRecordWifi = false;
      unregisterReceiver(receiverWifi);
    }
    else {
      sendEmail();
    }
  }
}

void drawUI()
{
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
  text("Record wifi's", 5, 60); 
  text("Stop recording", width/3 + 5, 60); 
  text("Send database by email", width/3*2 + 5, 60); 
  popStyle();
  try {
    pushStyle();
    textSize(80);
    textAlign(LEFT);
    fill(250, 255, 0);
    text(Integer.toString(wifilist.size()), 20, 200);
    // list all wifis
    textSize(20);
    for (int i = 0; i < wifilist.size(); i++) {
      int y= 180+(20*i);
      fill(255);
      text(wifilist.get(i), 120, y);
    }
    popStyle();
  }
  catch(Exception e) {
  }
  // GPS
  pushStyle();
  textSize(20);
  textAlign(LEFT);
  if (location.getProvider() == "none") {
    fill(255, 0, 0);
    text("Location data is unavailable.Please check your location settings.", 120, 120, width, height);
  } 
  else {
    fill(0, 255, 0);
    text("Latitude: " + latitude + 
      "Longitude: " + longitude + 
      "Altitude: " + altitude +  
      "Provider: " + location.getProvider(), 120, 120, width, height);
  }
  popStyle();
}

void getWifis() {
  wifi = (WifiManager) getSystemService(Context.WIFI_SERVICE);
  // Get WiFi status
  receiverWifi = new WifiReceiver();
  registerReceiver(receiverWifi, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
  wifi.startScan();
}

class WifiReceiver extends BroadcastReceiver {
  public void onReceive(Context c, Intent intent) {
    wifiList = wifi.getScanResults();
    wifilist.clear();
    for (int i = 0; i < wifiList.size(); i++) {
      wifilist.add((wifiList.get(i)).toString());
    }
  }
}

void sendEmail() {
  Intent i = new Intent(Intent.ACTION_SEND);
  i.setType("message/rfc822");
  i.putExtra(Intent.EXTRA_EMAIL, new String[] {
    "mar.canet@gmail.com"
  }
  );
  i.putExtra(Intent.EXTRA_SUBJECT, "subject of email");
  i.putExtra(Intent.EXTRA_TEXT, "body of email");
  try {
    startActivity(Intent.createChooser(i, "Send mail..."));
  } 
  catch (android.content.ActivityNotFoundException ex) {
    //Toast.makeText(MyActivity.this, "There are no email clients installed.", Toast.LENGTH_SHORT).show();
  }
}

void onLocationEvent(double _latitude, double _longitude, double _altitude)
{
  longitude = _longitude;
  latitude = _latitude;
  altitude = _altitude;
  println("lat/lon/alt: " + latitude + "/" + longitude + "/" + altitude);
}

void setupDatabase() {
  if ( db.connect() )
  {
    // for initial app launch there are no tables so we make one
    if (!db.tableExists("data"))
      db.execute(CREATE_DB_SQL);
  }
}

void insertDataDB(String wifiName, int strength, float lat, float lon ) {    
    if (!db.execute("INSERT into data (`name`,`age`) VALUES ('person"+(int)random(0, 100)+"', '"+(int)random(1, 100)+"' )")) {
      println("error w/sql insert");
    }
}

void getAllRecordsDB() {
  if ( db.connect() )
  {   
    // read all in table "table_one"
    db.query( "SELECT * FROM data" );

    while (db.next ())
    {
      println("----------------");
      print( db.getString("name") );
      print( "\t"+db.getInt("age") );
      println("\t"+db.getInt("foobar"));   //doesn't exist we get '0' returned
      println("----------------");
    }
  }
}

