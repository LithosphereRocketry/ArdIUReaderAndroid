final int[] lineSizes = {8, 12, 24, 28};

String toCSV(byte[] file, DataPoint[] flight) {
  String out = csvHeader;
  
  int fileVersion = b2i(file, 0); // check the version header
  for(int i = 4; i < file.length-lineSizes[fileVersion]+1; i += lineSizes[fileVersion]) {
    byte[] line = new byte[lineSizes[fileVersion]];
    arrayCopy(file, i, line, 0, lineSizes[fileVersion]);
    DataPoint lineObject = new DataPoint();
    lineObject.read(line, fileVersion);
    out += lineObject.csv();
    flight = (DataPoint[]) append(flight, lineObject);
  }
  return out;
}
