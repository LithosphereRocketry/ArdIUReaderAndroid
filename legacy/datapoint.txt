final String csvHeader = "Time (ms),Altitude (m),Acceleration X (G),Acceleration Y (G),Acceleration Z (G),Tilt (rad),Battery voltage (V),Liftoff,Burnout,Apogee,Continuity,IMU/SD/Baro\n";

class DataPoint {
  int time;
  float alt;
  PVector accel;
  float tilt;
  boolean[] cont;
  float voltage;
  boolean isIMU;
  boolean isSD;
  boolean isBaro;
  boolean liftoff, burnout, apogee;
  DataPoint() {
    time = 0;
    alt = 0;
    tilt = 0;
    voltage = 0;
    accel = new PVector();
    cont = new boolean[8];
  }
  void setAccel(float x, float y, float z) {
    accel = new PVector(x, y, z);
  }
  void read(byte[] data, int version) {
    switch(version) {
     case 3:
      if(data.length >= 28) {
        time = b2i(data, 0); // read the time
        int state = b2i(data, 4);
        
        voltage = (state & 255) / 16.0;
        for(int i = 0; i < 8; i++) {
          cont[i] = (state & (1 << 8+i)) > 0;
        }
        isIMU = (state & (1 << 16)) > 0;
        isSD = (state & (1 << 17)) > 0;
        isBaro = (state & (1 << 18)) > 0;
        
        liftoff = (state & (1 << 24)) > 0;
        burnout = (state & (1 << 25)) > 0;
        apogee = (state & (1 << 26)) > 0;
        
        byte[] altBytes = new byte[4]; // read the altitude
        arrayCopy(data, 8, altBytes, 0, 4);
        alt = byteArrayToFloat(altBytes);
        
        byte[] accXBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 12, accXBytes, 0, 4);
        float accX = byteArrayToFloat(accXBytes);
        byte[] accYBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 16, accYBytes, 0, 4);
        float accY = byteArrayToFloat(accYBytes);
        byte[] accZBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 20, accZBytes, 0, 4);
        float accZ = byteArrayToFloat(accZBytes);
        setAccel(accX, accY, accZ);
        
        byte[] tiltBytes = new byte[4]; // read the tilt
        arrayCopy(data, 24, tiltBytes, 0, 4);
        tilt = byteArrayToFloat(tiltBytes);
      }
    break;
     case 2:
      if(data.length >= 24) {
        time = b2i(data, 0); // read the time
        
        byte[] altBytes = new byte[4]; // read the altitude
        arrayCopy(data, 4, altBytes, 0, 4);
        alt = byteArrayToFloat(altBytes);
        
        byte[] accXBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 8, accXBytes, 0, 4);
        float accX = byteArrayToFloat(accXBytes);
        byte[] accYBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 12, accYBytes, 0, 4);
        float accY = byteArrayToFloat(accYBytes);
        byte[] accZBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 16, accZBytes, 0, 4);
        float accZ = byteArrayToFloat(accZBytes);
        setAccel(accX, accY, accZ);
        
        byte[] tiltBytes = new byte[4]; // read the tilt
        arrayCopy(data, 20, tiltBytes, 0, 4);
        tilt = byteArrayToFloat(tiltBytes);
      }
    break;
     case 1: // data format 1: time[int32] alt[float32] acc[float32]
      if(data.length >= 12) {
        time = b2i(data, 0); // read the time
        byte[] altBytes = new byte[4]; // read the altitude
        arrayCopy(data, 4, altBytes, 0, 4);
        alt = byteArrayToFloat(altBytes);
        byte[] accBytes = new byte[4]; // read the acceleration
        arrayCopy(data, 8, accBytes, 0, 4);
        accel.x = byteArrayToFloat(accBytes);
      }
    break;
     case 0: // data format 0: time[int32] alt[float32]
     default: // Default for unrecognized formats
      if(data.length >= 8) {
        time = b2i(data, 0); // read the time
        byte[] altBytes = new byte[4]; // read the altitude
        arrayCopy(data, 4, altBytes, 0, 4);
        alt = byteArrayToFloat(altBytes);
      }
    }
  }
  String csv() {
    String line = "";
    String contStr = "";
    for(int i = 0; i < 8; i++) {
      if(cont[i]) {
        contStr += 'Y';
      } else {
        contStr += 'n';
      }
    }
    String system = "";
    if(isIMU) { system += 'Y'; } else { system += 'n'; } 
    if(isSD) { system += 'Y'; } else { system += 'n'; }
    if(isBaro) { system += 'Y'; } else { system += 'n'; }
    line += time+","+alt+","+accel.x+","+accel.y+","+accel.z+","+tilt+","+voltage+","+liftoff+","+burnout+","+apogee+","+contStr+","+system+"\n";
    
    return line;
  }
  float getValue(String column) {
    switch(column.toLowerCase()) {
     case "time": return time;
     case "alt": return alt;
     case "accx": return accel.x;
     case "accy": return accel.y;
     case "accz": return accel.z;
     case "tilt": return tilt;
     default:
      return -1;
    }
  }
}
