import org.gicentre.utils.spatial.*;
import org.gicentre.utils.network.*;
import org.gicentre.utils.network.traer.physics.*;
import org.gicentre.utils.geom.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.colour.*;
import org.gicentre.utils.text.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.traer.animation.*;
import org.gicentre.utils.io.*;

Table logFromSource(byte[] source) {
  Table tgt = new Table();
  
  int version = b2i(source, 0);
  
  switch(version) {
   case 3:
    tgt.addColumn("Time");
    tgt.addColumn("Altitude");
    tgt.addColumn("Acceleration X");
    tgt.addColumn("Acceleration Y");
    tgt.addColumn("Acceleration Z");
    tgt.addColumn("Tilt");
    tgt.addColumn("Battery Voltage");
    tgt.addColumn("Liftoff");
    tgt.addColumn("Burnout");
    tgt.addColumn("Apogee");
    for(int i = 0; i < 8; i++) { tgt.addColumn("Continuity ch"+i); }
    tgt.addColumn("IMU OK");
    tgt.addColumn("SD OK");
    tgt.addColumn("Baro OK");
    
    for(int filePos = 4; filePos < source.length-27; filePos += 28) {
      TableRow row = tgt.addRow();
      
      float time = b2i(source, filePos) / 1000.0; // read the time
      row.setFloat("Time", time);
      
      int state = b2i(source, filePos+4);
      row.setFloat("Battery Voltage", (state & 255) / 16.0);
      for(int i = 0; i < 8; i++) {
        row.setInt("Continuity ch"+i, state & (1 << 8+i));
      }
      row.setInt("IMU OK", state & (1 << 16));
      row.setInt("SD OK", state & (1 << 17));
      row.setInt("Baro OK", state & (1 << 18));
      
      row.setInt("Liftoff", state & (1 << 24));
      row.setInt("Burnout", state & (1 << 25));
      row.setInt("Apogee", state & (1 << 26));
      
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(source, filePos+8, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      row.setFloat("Altitude", alt);
      
      byte[] accXBytes = new byte[4]; // read the acceleration x
      arrayCopy(source, filePos+12, accXBytes, 0, 4);
      float accX = byteArrayToFloat(accXBytes);
      row.setFloat("Acceleration X", accX);
      
      byte[] accYBytes = new byte[4]; // read the acceleration y
      arrayCopy(source, filePos+16, accYBytes, 0, 4);
      float accY = byteArrayToFloat(accYBytes);
      row.setFloat("Acceleration Y", accY);
      
      byte[] accZBytes = new byte[4]; // read the acceleration z
      arrayCopy(source, filePos+20, accZBytes, 0, 4); 
      float accZ = byteArrayToFloat(accZBytes);
      row.setFloat("Acceleration Z", accZ);
      
      byte[] tiltBytes = new byte[4]; // read the tilt
      arrayCopy(source, filePos+24, tiltBytes, 0, 4);
      float tilt = byteArrayToFloat(tiltBytes);
      row.setFloat("Tilt", tilt);
    }
    break;
   case 2:
    tgt.addColumn("Time");
    tgt.addColumn("Altitude");
    tgt.addColumn("Acceleration X");
    tgt.addColumn("Acceleration Y");
    tgt.addColumn("Acceleration Z");
    tgt.addColumn("Tilt");
    
    for(int filePos = 4; filePos < source.length-23; filePos += 24) {
      
      TableRow row = tgt.addRow();
      
      float time = b2i(source, filePos) / 1000.0; // read the time
      row.setFloat("Time", time);
      print(row.getFloat("Time")+" : ");
      
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(source, filePos+4, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      row.setFloat("Altitude", alt);
      
      
      byte[] accXBytes = new byte[4]; // read the acceleration x
      arrayCopy(source, filePos+8, accXBytes, 0, 4);
      float accX = byteArrayToFloat(accXBytes);
      row.setFloat("Acceleration X", accX);
      
      byte[] accYBytes = new byte[4]; // read the acceleration y
      arrayCopy(source, filePos+12, accYBytes, 0, 4);
      float accY = byteArrayToFloat(accYBytes);
      row.setFloat("Acceleration Y", accY);
      
      byte[] accZBytes = new byte[4]; // read the acceleration z
      arrayCopy(source, filePos+16, accZBytes, 0, 4); 
      float accZ = byteArrayToFloat(accZBytes);
      row.setFloat("Acceleration Z", accZ);
      
      byte[] tiltBytes = new byte[4]; // read the tilt
      arrayCopy(source, filePos+20, tiltBytes, 0, 4);
      float tilt = byteArrayToFloat(tiltBytes);
      row.setFloat("Tilt", tilt);
    }
    break;
   case 1:
    tgt.addColumn("Time");
    tgt.addColumn("Altitude");
    tgt.addColumn("Acceleration");
    
    for(int filePos = 4; filePos < source.length-11; filePos += 12) {
      
      TableRow row = tgt.addRow();
      
      float time = b2i(source, filePos) / 1000.0; // read the time
      row.setFloat("Time", time);
      
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(source, filePos+4, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      row.setFloat("Altitude", alt);
      
      
      byte[] accXBytes = new byte[4]; // read the acceleration x
      arrayCopy(source, filePos+8, accXBytes, 0, 4);
      float accX = byteArrayToFloat(accXBytes);
      row.setFloat("Acceleration", accX);
    }
    break;
   case 0: // source format 0: time[int32] alt[float32]
   default: // Default for unrecognized formats
    tgt.addColumn("Time");
    tgt.addColumn("Altitude");
    
    for(int filePos = 4; filePos < source.length; filePos += 12) {
      TableRow row = tgt.addRow();
      
      float time = b2i(source, filePos) / 1000.0; // read the time
      row.setFloat("Time", time);
      
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(source, filePos+4, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      row.setFloat("Altitude", alt);
    }
  }
  
  return tgt;
}

Table units;

XYChart logToGraph(Table data, String xIndex, String yIndex) {
  XYChart graph = new XYChart(this);
  float[] xPts = data.getFloatColumn(xIndex);
  float[] yPts = data.getFloatColumn(yIndex);
  graph.setData(xPts, yPts);
  graph.setXFormat("########## "+units.getString(0, xIndex));
  graph.setYFormat("########## "+units.getString(0, yIndex));
  return graph;
}

String logToCSV(Table data) {
  String out = "Time (ms),Altitude (m),Acceleration X (G),Acceleration Y (G),Acceleration Z (G),Tilt (rad),Battery voltage (V),Liftoff,Burnout,Apogee,Continuity,IMU/SD/Baro\n";
  for(TableRow row : data.rows()) {
    String contStr = "";
    for(int i = 0; i < 8; i++) {
      if(row.getInt("Continuity ch"+i) > 0) {
        contStr += 'Y';
      } else {
        contStr += 'n';
      }
    }
    String system = "";
    if(row.getInt("IMU OK") > 0) { system += 'Y'; } else { system += 'n'; } 
    if(row.getInt("SD OK") > 0) { system += 'Y'; } else { system += 'n'; }
    if(row.getInt("Baro OK") > 0) { system += 'Y'; } else { system += 'n'; }
    
    out += row.getFloat("Time")+","+
           row.getFloat("Altitude")+","+
           row.getFloat("Acceleration X")+","+row.getFloat("Acceleration Y")+","+row.getFloat("Acceleration Z")+","+
           row.getFloat("Tilt")+","+
           row.getFloat("Battery Voltage")+","+
           (row.getFloat("Liftoff")>0)+","+(row.getFloat("Burnout")>0)+","+(row.getFloat("Apogee")>0)+","+
           contStr+","+system+"\n";
  }
  
  return out;
}
float[] getTransition(Table data, String x, String state) {
  float[] t = new float[0];
  
  boolean firstRun = true;
  int last = 0;
  for(TableRow row : data.rows()) {
    if(row.getInt(state) != last && !firstRun) {
      t = append(t, row.getFloat(x));
    }
    firstRun = false;
    last = row.getInt(state);
  }
  return t;
}
