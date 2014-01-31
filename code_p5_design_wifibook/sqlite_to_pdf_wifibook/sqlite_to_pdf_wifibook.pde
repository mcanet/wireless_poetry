import de.bezier.data.sql.*;
import processing.pdf.*;

SQLite db;
// variables
PFont font;
PFont fontTitles;
int counterItemsPerPage = 0;
int counterItemsPerColumn = 0;
int maxItemsPerColumn = 46;
int maxItemsPerPage = maxItemsPerColumn*2;
int columnNum = 0;
int startPosX = 50;
int startPosY = 50;
int lineHeight = 11;
//int sizeColumn = 150;
int sizeColumn_wifiName  = 150;
int sizeColumn_macAdress = 80;
int sizeColumn_fullcolumns = 380;

int marginTopY = 30;
int marginDownY = 40;
int marginLeftX = 40;
int pageCounter = 11;

float mapGeoLeft;
float mapGeoRight;
float mapGeoTop;
float mapGeoBottom;

float mapScreenWidth;
float mapScreenHeight;

void setup()
{
  size(843,595, PDF, "wifiBook.pdf");
  mapScreenWidth = width-50;
  mapScreenHeight = height-50;
}

void draw()
{
  render();
}

void render(){
  font = loadFont("ACaslonPro-Regular-8.vlw");
  fontTitles = loadFont("ACaslonPro-Regular-24.vlw");
  // Render by parts:
  
  // Itaewon
  mapGeoLeft=37.531524658203125;
  mapGeoRight=37.54029083251953;
  mapGeoTop=126.99307250976562;
  mapGeoBottom=127.00196838378906;
  openDBAndRender("gps_1.sqlite","wifiMapped10","Itaewon","22/01/2013",37.540052,126.992083);
  
  // City hall
  mapGeoLeft=37.57;//54151916503906;
  mapGeoRight=37.58332824707031;
  mapGeoTop=126.96;//90869140625;
  mapGeoBottom=126.98250579833984; 
  openDBAndRender("gps_2.sqlite","wifiMapped11","City hall","02/02/2013",37.54151876370069,126.90868985596958);
  
  // Doksan
  mapGeoLeft=37.46711730957031;
  mapGeoRight=37.473426818847656;
  mapGeoTop=126.8912582397461;
  mapGeoBottom=126.90328216552734;
  openDBAndRender("gps_2.sqlite","wifiMapped13","Doksan","02/02/2013",37.46923671795895,126.8922523784);
  
  // Hongik university
  mapGeoLeft=37.545;//46883010864258;
  mapGeoRight=37.557132720947266;
  mapGeoTop=126.915;//89138793945312;
  mapGeoBottom=126.92852783203125;
  openDBAndRender("gps_3.sqlite","wifiMapped12","Hongik University","05/02/2013",37.556833,126.923775);
  
  // Gangnam
  mapGeoLeft=37.50;//47386169433594;
  mapGeoRight=37.52336883544922;
  mapGeoTop=127.01;//8941879272461;
  mapGeoBottom=127.03070068359375;
  openDBAndRender("gps_4.sqlite","wifiMapped14","Gangnam","11/02/2013",37.47386140758133,126.89418986896708);
  
  exit();
}

PVector pixelToGeo(PVector screenLocation)
{
    return new PVector(mapGeoLeft + (mapGeoRight-mapGeoLeft)*(screenLocation.x)/mapScreenWidth,mapGeoTop - (mapGeoTop-mapGeoBottom)*(screenLocation.y)/mapScreenHeight);
}

PVector geoToPixel(PVector geoLocation)
{
    return new PVector(mapScreenWidth*(geoLocation.x-mapGeoLeft)/(mapGeoRight-mapGeoLeft), mapScreenHeight - mapScreenHeight*(geoLocation.y-mapGeoBottom)/(mapGeoTop-mapGeoBottom));
}

double gps2m(float lat_a, float lng_a, float lat_b, float lng_b) {
    float pk = (float) (180/3.14169);
    
    float a1 = lat_a / pk;
    float a2 = lng_a / pk;
    float b1 = lat_b / pk;
    float b2 = lng_b / pk;

    float t1 = cos(a1)*cos(a2)*cos(b1)*cos(b2);
    float t2 = cos(a1)*sin(a2)*cos(b1)*sin(b2);
    float t3 = sin(a1)*sin(b1);
    double tt = acos(t1 + t2 + t3);

    return 6366000*tt;
}

double distanceGeo(double lat1, double lon1, double lat2, double lon2) {
  char unit ='K';
  double theta = lon1 - lon2;
  float dist = sin(radians((float)lat1)) * sin(radians((float)lat2)) + cos(radians((float)lat1)) * cos(radians((float)lat2)) * cos(radians((float)theta));
  dist = acos(dist);
  dist = degrees(dist);
  dist = dist * 60 * 1.1515;
  if (unit == 'K') {
    dist = dist * 1.609344;
  } else if (unit == 'N') {
    dist = dist * 0.8684;
  }
  return (dist);
}

void openDBAndRender(String database,String table, String areaTitle, String date,double orig_lat,double orig_lon){
  double maxLat=0;
  double minLat=999;
  double maxLon=0;
  double minLon=999;
  println("start render pdf :: "+areaTitle);
  background(255);
  db = new SQLite( this, database );  // open database file
  String query = "SELECT MIN("+table+".id) AS ID, "+table+".macAddress as macAddress, "+table+".wifi_name as wifi_name, "+table+".lat as lat,"+table+".lon as lon  FROM "+table+" GROUP BY "+table+".macAddress ORDER BY ID ASC";
  int totalWifis = 0;
  if ( db.connect() )
  {
    db.query(query );   
    while (db.next())
    {
      double lat = (double)db.getFloat("lat");
      double lon = (double)db.getFloat("lon");
      if(table=="wifiMapped10"){
        double tempLat = lat;  
        lat = lon;
        lon = tempLat;  
      }
      
      if(lat!=0 && lon!=0 ){
        if(lat>maxLat) maxLat = lat;
        if(lat<minLat) minLat = lat;
        if(lon>maxLon) maxLon = lon;
        if(lon<minLon) minLon = lon;
      }
  
       totalWifis += 1;
    }
  }

  println("maxLat:"+String.valueOf(maxLat)+" | minLat:"+String.valueOf(minLat)+" | maxLon:"+String.valueOf(maxLon)+" | minLon:"+String.valueOf(minLon));
  // extra page to start in odd
  if(pageCounter%2==0){ 
    pageCounter += 1;
    newPDF_page();
  }
  
  // title
  
  textFont(fontTitles);
  fill(0);
  String totalWifisStr = "Total wifis: "+Integer.toString(totalWifis);
  String dateStr = "Date: "+date;
  String placeStr = "Location: "+areaTitle;
  
  text(placeStr,startPosX+700-textWidth(placeStr),startPosY+400);//+sizeColumn_fullcolumns/2
  text(totalWifisStr,startPosX+700-textWidth(totalWifisStr),startPosY+40+400);//
  text(dateStr,startPosX+700-textWidth(dateStr),startPosY+80+400);
  newPDF_page();
  newPDF_page();
  pageCounter += 2;
  
  // map
  /*
  mapGeoLeft = (float)maxLat;
  mapGeoRight = (float)minLat;
  mapGeoTop = (float)maxLon;
  mapGeoBottom = (float)minLon;
  */
  stroke(0);
  strokeWeight(1.5);
  noFill();
  rect(25,25,width-50,height-50);
  fill(0);
  strokeWeight(1);
  float lastX=0;
  float lastY=0;
  if ( db.connect() )
  {
    db.query(query );   
    /*
    while (db.next())
    {
      double lat = (double)db.getFloat("lat");
      double lon = (double)db.getFloat("lon");
      if(table=="wifiMapped10"){
        double tempLat = lat;  
        lat = lon;
        lon = tempLat;  
      }
      if(lat>=mapGeoLeft && lat<=mapGeoRight && lon>=mapGeoTop && lon<=mapGeoBottom ){
        PVector geoLocation = new PVector((float)lat,(float)lon);
        PVector screenLocation = geoToPixel(geoLocation);
        fill(200);
        if(lastX!=0){
          line(lastX+25, lastY+25,screenLocation.x+25,screenLocation.y+25);
        }
        lastX = screenLocation.x;
        lastY = screenLocation.y;
      }
    }*/
    while (db.next())
    {
      double lat = (double)db.getFloat("lat");
      double lon = (double)db.getFloat("lon");
      if(table=="wifiMapped10"){
        double tempLat = lat;  
        lat = lon;
        lon = tempLat;  
      }
      if(lat>=mapGeoLeft && lat<=mapGeoRight && lon>=mapGeoTop && lon<=mapGeoBottom ){
        PVector geoLocation = new PVector((float)lat,(float)lon);
        PVector screenLocation = geoToPixel(geoLocation);
        fill(0);
        ellipse(screenLocation.x+25,screenLocation.y+25,2,2);
      }
      //fill(255,0,0);
      //text(db.getString("id"),screenLocation.x+25,screenLocation.y+25);
    }
  }
  newPDF_page();
  newPDF_page();
  pageCounter += 2;
  
  textFont(font);
  if ( db.connect() )
  {
    counterItemsPerPage = 0;
    counterItemsPerColumn = 0;
    columnNum = 0;
    // list table names  
    db.query(query);   
    while (db.next())
    {
      String lat = db.getString("lat");
      String lon = db.getString("lon");
      double latf = (double)db.getFloat("lat");
      double lonf = (double)db.getFloat("lon");
      if(table=="wifiMapped10"){
        String tempLat = lat;  
        lat = lon;
        lon = tempLat;  
      }
      String wifiName = db.getString("wifi_name");
      String macAddress = db.getString("macAddress");
      
      pushMatrix();
      if(pageCounter%2==1){
        marginLeftX = 50;//60
        startPosX = marginLeftX+10;
        marginTopY = 40;
        startPosY = marginTopY+20;
      }else{
        marginLeftX = 35;//25
        startPosX = marginLeftX+10;
        marginTopY = 30;
        startPosY = marginTopY+20;
      }
      if(columnNum==1){
        translate((sizeColumn_fullcolumns),0);
      }
      fill(0);
      if(counterItemsPerColumn==0){
        text("Wifi name",startPosX,startPosY+(lineHeight*-1.5));
        // mac address
        text("Mac address",startPosX+(sizeColumn_wifiName),startPosY+(lineHeight*-1.5));
        // location
        text("Location",startPosX+(sizeColumn_wifiName+sizeColumn_macAdress),startPosY+(lineHeight*-1.5));
        line(marginLeftX,marginTopY+(lineHeight),marginLeftX+sizeColumn_fullcolumns,marginTopY+(lineHeight));
      }
      // location
      text(lat+","+lon,startPosX+(sizeColumn_wifiName+sizeColumn_macAdress),startPosY+(lineHeight*counterItemsPerColumn));
      // mac address
      text(macAddress,startPosX+(sizeColumn_wifiName),startPosY+(lineHeight*counterItemsPerColumn));
      // wifi
      text(wifiName,startPosX,startPosY+(lineHeight*counterItemsPerColumn));
           
      counterItemsPerColumn+=1;
      counterItemsPerPage+=1;
      
      if( counterItemsPerColumn == maxItemsPerColumn ){
        // middle lines between columns
        line(marginLeftX+sizeColumn_wifiName,marginTopY,marginLeftX+sizeColumn_wifiName,marginTopY+(height-marginTopY-marginDownY));
        line(marginLeftX+sizeColumn_wifiName+sizeColumn_macAdress,marginTopY,marginLeftX+sizeColumn_wifiName+sizeColumn_macAdress,marginTopY+(height-marginTopY-marginDownY));
        // double line dividing two
        if(columnNum ==0){
          line(marginLeftX+sizeColumn_fullcolumns,marginTopY,marginLeftX+sizeColumn_fullcolumns,marginTopY+(height-marginTopY-marginDownY));
          line(marginLeftX+sizeColumn_fullcolumns+2,marginTopY,marginLeftX+sizeColumn_fullcolumns+2,marginTopY+(height-marginTopY-marginDownY));
        }
        columnNum +=1;
        counterItemsPerColumn = 0;
        //println("end column");
      }
      
      if(counterItemsPerPage==maxItemsPerPage){
        if(pageCounter%2==1){
          text(String.valueOf(pageCounter),startPosX+sizeColumn_fullcolumns-textWidth(String.valueOf(pageCounter)),startPosY+(lineHeight*(maxItemsPerColumn+1)));
        }else{
         text(String.valueOf(pageCounter),startPosX-sizeColumn_fullcolumns-textWidth(String.valueOf(pageCounter)),startPosY+(lineHeight*(maxItemsPerColumn+1))); 
        }
        newPDF_page();
        background(255);
        //println("end page"+Integer.toString(pageCounter));
        counterItemsPerPage = 0;
        columnNum = 0;
        pageCounter +=1;
        //if(pageCounter==3) break;
      }
      popMatrix();
    }
  }
  
  println("end render pdf :: "+areaTitle+" -"+Integer.toString(pageCounter));
}

void newPDF_page(){
    PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
}
