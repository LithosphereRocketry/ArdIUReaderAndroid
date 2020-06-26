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

char d = 'C';
File f;
File g;

void setup() {
  do {
    d++;
    f = new File(d+":\\flight0.aiu");
  } while(d <= 'Z' && !f.exists()); // find the ArdIU drive
  if(d <= 'Z') { // If we found one:
    println("Found a recognized folder in drive "+d+":\\, converting flights");
    g = new File(d+":\\ardiu-processed");
    if(!g.exists()) {
      g.mkdir();
      println("\"Processed\" folder not found, creating new one");
    } else {
      println("\"Processed\" folder located");
    }
    for(int fileNum = 0; fileNum < 100; fileNum++) { // For each possible file number...
      f = new File(d+":\\flight"+fileNum+".aiu");
      if(f.exists()) { // Does it exist?
        byte file[] = loadBytes(f.getAbsolutePath()); // If so load it
        int fileVersion = b2i(file, 0); // check the version header
        //dataPoint[] flight = new dataPoint[0];
        PrintWriter target = createWriter(g.getAbsolutePath()+"\\flight"+fileNum+".csv");
        switch(fileVersion) {
         case 3:
          target.println("Time (ms),Altitude (m),Acceleration X (G),Acceleration Y (G),Acceleration Z (G),Tilt (rad),Battery voltage (V),Liftoff,Burnout,Apogee,Continuity,IMU/SD/Baro");
          for(int filePos = 4; filePos < file.length-27; filePos += 28) {
            int time = b2i(file, filePos); // read the time
            int state = b2i(file, filePos+4);
            float voltage = (state & 255) / 16.0;
            String cont = "";
            for(int i = 0; i < 8; i++) {
              if((state & (1 << 8+i)) > 0) {
                cont += 'Y';
              } else {
                cont += 'n';
              }
            }
            String system = "";
            for(int i = 0; i < 3; i++) {
              if((state & (1 << 16+i)) > 0) {
                system += 'Y';
              } else {
                system += 'n';
              }
            }
            boolean liftoff = (state & (1 << 24)) > 0;
            boolean burnout = (state & (1 << 25)) > 0;
            boolean apogee = (state & (1 << 26)) > 0;
            byte[] altBytes = new byte[4]; // read the altitude
            arrayCopy(file, filePos+8, altBytes, 0, 4);
            float alt = byteArrayToFloat(altBytes);
            byte[] accXBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+12, accXBytes, 0, 4);
            float accX = byteArrayToFloat(accXBytes);
            byte[] accYBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+16, accYBytes, 0, 4);
            float accY = byteArrayToFloat(accYBytes);
            byte[] accZBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+20, accZBytes, 0, 4);
            float accZ = byteArrayToFloat(accZBytes);
            byte[] tiltBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+24, tiltBytes, 0, 4);
            float tilt = byteArrayToFloat(tiltBytes);
            target.println(time+","+alt+","+accX+","+accY+","+accZ+","+tilt+","+voltage+","+liftoff+","+burnout+","+apogee+","+cont+","+system); // write it all to the file
          }
          break;
         
         case 2:
          target.println("Time (ms),Altitude (m),Acceleration X (G),Acceleration Y (G),Acceleration Z (G),Tilt (rad)");
          for(int filePos = 4; filePos < file.length-23; filePos += 24) {
            int time = b2i(file, filePos); // read the time
            byte[] altBytes = new byte[4]; // read the altitude
            arrayCopy(file, filePos+4, altBytes, 0, 4);
            float alt = byteArrayToFloat(altBytes);
            byte[] accXBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+8, accXBytes, 0, 4);
            float accX = byteArrayToFloat(accXBytes);
            byte[] accYBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+12, accYBytes, 0, 4);
            float accY = byteArrayToFloat(accYBytes);
            byte[] accZBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+16, accZBytes, 0, 4);
            float accZ = byteArrayToFloat(accZBytes);
            byte[] tiltBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+20, tiltBytes, 0, 4);
            float tilt = byteArrayToFloat(tiltBytes);
            target.println(time+","+alt+","+accX+","+accY+","+accZ+","+tilt); // write it all to the file
          }
          break;
         case 1: // File format 1: time[int32] alt[float32] acc[float32]
          target.println("Time (ms),Altitude (m),Acceleration (G)");
          for(int filePos = 4; filePos < file.length; filePos += 12) {
            int time = b2i(file, filePos); // read the time
            byte[] altBytes = new byte[4]; // read the altitude
            arrayCopy(file, filePos+4, altBytes, 0, 4);
            float alt = byteArrayToFloat(altBytes);
            byte[] accBytes = new byte[4]; // read the acceleration
            arrayCopy(file, filePos+8, accBytes, 0, 4);
            float acc = byteArrayToFloat(accBytes);
            target.println(time+","+alt+","+acc); // write it all to the file
          }
          break;
         case 0: // File format 0: time[int32] alt[float32]
         default: // Default for unrecognized formats
          target.println("Time (ms),Altitude (m)");
          for(int filePos = 4; filePos < file.length; filePos += 12) {
            int time = b2i(file, filePos); // read the time
            byte[] altBytes = new byte[4]; // read the altitude
            arrayCopy(file, filePos+4, altBytes, 0, 4);
            float alt = byteArrayToFloat(altBytes);
            target.println(time+","+alt);
          }
        }
        target.flush();
        target.close();
        println("Processed file "+f.getAbsolutePath()+" with data format "+fileVersion+", size "+file.length+" bytes, to "+g.getAbsolutePath()+"\\flight"+fileNum+".csv");
      }
    }
  } else { // We didn't find a drive
    println("No recognized drive found.");
  }
  exit();
}
