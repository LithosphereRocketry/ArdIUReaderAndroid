import java.io.File;

String getOS() {
  String os = System.getProperty("os.name");
  if(os.contains("Linux") && System.getProperty("java.runtime.name").equals("Android Runtime")) { // Detect Android
    os = "Linux/Android";
  }
  return os;
}

String pathToCard() {
  final String s = java.io.File.separator;
  
  File f;
  
  String os = getOS();
  //println(os);
  if(os.contains("Windows")) {
    char d = 'C';
    do {
      d++;
      f = new File(d+":"+s+"flight0.aiu");
    } while(d <= 'Z' && !f.exists()); // find the ArdIU drive
    if(d <= 'Z') {
      return d+":";
    } else {
      return "none";
    }
  } else if(os.contains("Linux")) {
    String out = "none";
    try {
      
      String[] cmd = {"cat", "/proc/mounts"};
      InputStream stream = exec(cmd).getInputStream();
      String result = "";
      do { result += (char) stream.read(); } while(stream.available() > 0);
      //println(result);
      String[] lines = result.split("\n");
      for(int i = 1; i < lines.length; i++) {
        String line = lines[i].split(" ")[1].replace("\\040", " ");
//        print(line);
        f = new File(line+s+"flight0.aiu");
        if(f.exists()) {
          out = line;
        }
//        println(" "+f.exists());
      }
      return out;
    } catch(Exception e) {
      e.printStackTrace();
      return "none";
    }
  } else {
    return "none";
  }
}
