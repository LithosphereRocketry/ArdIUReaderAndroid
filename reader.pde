String drv = "none";
final String s = java.io.File.separator;
boolean canWrite = false;
File g;

//DataPoint[][] charts = new DataPoint[0][100];
Table[] charts = new Table[100];

void load() {
  textAlign(CENTER, CENTER);
  units = new Table();
  TableRow names = units.addRow();
  units.addColumn("Time");
  names.setString("Time", "s");
  units.addColumn("Altitude");
  names.setString("Altitude", "m");
  units.addColumn("Acceleration X");
  names.setString("Acceleration X", "g");
  units.addColumn("Acceleration Y");
  names.setString("Acceleration Y", "g");
  units.addColumn("Acceleration Z");
  names.setString("Acceleration Z", "g");
  units.addColumn("Tilt");
  names.setString("Tilt", "rad");
  
  drv = pathToCard();
  
  if(getOS().contains("Android")) {
    println("Asking permission...");
  }
  
  if(drv != "none") { // If we found one:
    println("Found a recognized folder in drive "+drv+s+", converting flights");
    g = new File(pathToWrite());
    if(!g.exists()) {
      println("\"Processed\" folder not found, creating new one at "+g.getAbsolutePath());
      if(!g.mkdir()) {
        println("mkdir failed");
      }
    } else {
      println("\"Processed\" folder located");
    }
    for(int fileNum = 0; fileNum < 100; fileNum++) { // For each possible file number...
    }
  } else { // We didn't find a drive
    println("No recognized drive found.");
  }
}

boolean loaded;
int fileNum;
String columnName = "Acceleration Y";
void draw() {
  background(255);
  fill(0);
  if(drv != "none") {
    if(!loaded) {
      frameRate(10000);
      text("Loading...", width/2, height/2);
      fill(255, 0, 0);
      rect(0, height*.9, width*fileNum/100, height*.1);
      
      File f = new File(drv+s+"flight"+fileNum+".aiu");
      if(f.exists()) { // Does it exist
        PrintWriter target = createWriter(pathToWrite()+s+"flight"+fileNum+".csv");
        byte[] file = loadBytes(f.getAbsolutePath());
        charts[fileNum] = logFromSource(file);
        
        target.print(logToCSV(charts[fileNum]));
        target.flush();
        target.close();
        println("Processed file "+f.getAbsolutePath()+" to "+g.getAbsolutePath()+s+"flight"+fileNum+".csv");
      }
      fileNum++;
      if(fileNum > 99) {
        fileNum = 0;
        loaded = true;
//        logToGraph(flights[fileNum], "Time", "Altitude");
      }
    } else {
      frameRate(60);
      text("flight"+fileNum+".aiu\n"+columnName, width/2, height/10);
   //   println(graphs[fileNum].getYData());
      XYChart graph = logToGraph(charts[fileNum], "Time", columnName);
      graph.showXAxis(true);
      graph.showYAxis(true);
      graph.setLineWidth(2);
      graph.draw(10, 10, (width - (width-height)/2)-20, height-20);
      fill(200);
      triangle(width-(width-height)*1/4, height*1/12,
               width-(width-height)*1/8, height*3/12,
               width-(width-height)*3/8, height*3/12);
      triangle(width-(width-height)*1/4, height*11/12,
               width-(width-height)*1/8, height*9/12,
               width-(width-height)*3/8, height*9/12);
      rect(width - (width-height)*3/8, height/2 - (width-height)*1/8, (width-height)*1/4, (width-height)*1/4);
      for(float time : getTransition(charts[fileNum], "Time", "Burnout")) {
        PVector min = graph.getDataToScreen(new PVector(time, graph.getMinY()));
        PVector max = graph.getDataToScreen(new PVector(time, graph.getMaxY()));
        line(min.x, min.y, max.x, max.y);
      }
    }
  } else {
    fill(0);
    text("No files detected", width/2, height/2);
  }
}
