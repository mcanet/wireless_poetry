void openSDCard(){
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  dataFile = SD.open("datalog.txt", FILE_WRITE);
}

void closeSDCard(){
  if (dataFile) {
    dataFile.close();
    delay(2000);
    // print to the serial port too:
  }
}

void saveInSDCard(String stringDataToSave){
  if (dataFile) {
    dataFile.println(stringDataToSave);
  } 
}

void readSDCard(){
  // re-open the file for reading:
  dataFile = SD.open("datalog.txt");
  if (dataFile) {
    //Serial.println("datalog.txt:");
    
    // read from the file until there's nothing else in it:
    while (dataFile.available()) {
        Serial.write(dataFile.read());
    }
    // close the file:
    dataFile.close();
  } else {
    // if the file didn't open, print an error:
    //Serial.println("error opening test.txt");
  }
}
