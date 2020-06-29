class dataPoint {
  int time;
  float alt;
  float accel;
  dataPoint() {
    time = 0;
    alt = 0;
    accel = 0;
  }
}

public float byteArrayToFloat(byte test[]) { 
    int MASK = 0xff; 
    int bits = 0; 
    int i = 3; 
    for (int shifter = 3; shifter >= 0; shifter--) { 
    bits |= ((int) test[i] & MASK) << (shifter * 8); 
    i--; 
    } 
    return Float.intBitsToFloat(bits); 
} // Credit for conversion script cadomanis of the Processing Forum. 

int b2i(byte[] from, int offs) {
  return ( from[offs    ] & 0xff       ) |
         ((from[offs + 1] & 0xff) <<  8) |
         ((from[offs + 2] & 0xff) << 16) |
         ((from[offs + 3] & 0xff)  << 24);
} // this one subpixel of the Processing Forum.

String drv = "none";
final String s = java.io.File.separator;
File f;
File g;

void setup() {
  drv = pathToCard();
  
  if(drv != "none") { // If we found one:
    println("Found a recognized folder in drive "+drv+"\\, converting flights");
    g = new File(drv+s+"ardiu-processed");
    if(!g.exists()) {
      g.mkdir();
      println("\"Processed\" folder not found, creating new one");
    } else {
      println("\"Processed\" folder located");
    }
    for(int fileNum = 0; fileNum < 100; fileNum++) { // For each possible file number...
      f = new File(drv+s+"flight"+fileNum+".aiu");
      if(f.exists()) { // Does it exist?
        PrintWriter target = createWriter(g.getAbsolutePath()+s+"flight"+fileNum+".csv");
        target.print(toCSV(loadBytes(f.getAbsolutePath()))); // If so load it
        
        
        target.flush();
        target.close();
        println("Processed file "+f.getAbsolutePath()+" to "+g.getAbsolutePath()+s+"flight"+fileNum+".csv");
      }
    }
  } else { // We didn't find a drive
    println("No recognized drive found.");
  }
  exit();
}
