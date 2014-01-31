void setupDatabase() {
  tableDatabase = "wifiMapped14";
  CREATE_DB_SQL = "CREATE TABLE "+tableDatabase+" ( id INTEGER PRIMARY KEY AUTOINCREMENT,lat double NOT NULL,lon double NOT NULL,accuracy float NOT NULL,`date` timestamp DEFAULT CURRENT_TIMESTAMP, wifi_name varchar(255) NOT NULL,macAddress varchar(255) NOT NULL,capabilities varchar(255) NOT NULL,frequency int(2) NOT NULL,level int(2) NOT NULL,street varchar(255),city varchar(255),country varchar(255));";
  try {
    if ( db.connect() )
    {
      // for initial app launch there are no tables so we make one
      if (!db.tableExists(tableDatabase)) {
        db.execute(CREATE_DB_SQL);
      }
    }
    else {
      println("Not conected");
    }
  }
  catch(Exception e) {
    println("error insert");
  }
}

void insertDataDB(String name, String macAddress, String capabilities, String level, String frequency, String timestamp ) {    
  try {
    if (!db.execute("INSERT into "+tableDatabase+" (`lat`,`lon`,`accuracy`,`wifi_name`,`macAddress`,`capabilities`,`level`,`frequency`) VALUES ('"+latitude+"','"+longitude+"','"+accuracy+"','"+name+"','"+macAddress+"','"+capabilities+"',"+level+","+frequency+")")) {
      //println("error w/sql insert");
    }
    else {
      //println("insert new row");
    }
  }
  catch(Exception e) {
    println("error insert");
  }
}

int isThisMacAddressInDB(String mac) {
  boolean out = true;
  int levelInDB = -1;
  try {
    if ( db.connect() )
    { 
      /*  
      db.query( "SELECT count(*) as total, level FROM "+tableDatabase+" WHERE macAddress='"+mac+"'");
      while (db.next ())
      {
        int totalResultInDB = db.getInt("total");
        if (totalResultInDB>0) out = false;
        
      }
      */
      db.query( "SELECT level FROM "+tableDatabase+" WHERE macAddress='"+mac+"'");
      while (db.next ())
      {
        levelInDB = db.getInt("level");
      }
    }
  }
  catch(Exception e) {
    //println("all records");
  }
  return levelInDB;
}

void getAllRecordsDB() {
  try {
    if ( db.connect() )
    {   
      db.query( "SELECT count(*) as total FROM "+tableDatabase );
      while (db.next ())
      {
        totalRecordsInDB = db.getInt("total");
      }
    }
  }
  catch(Exception e) {
    //println("all records");
  }
}

void updateDataDB(String macAddress, String level){
  try {
    if (!db.execute("UPDATE "+tableDatabase+"  SET `level`="+level+",`lat`='"+longitude+"',`lon`='"+latitude+"' where macAddress='"+macAddress+"'")) {
    }
  }
  catch(Exception e) {
    println("error insert");
  }
}


