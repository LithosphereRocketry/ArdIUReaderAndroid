String pathToCard() {
  final String s = java.io.File.separator;
  
  String os = System.getProperty("os.name");
  println(os);
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
      InputStream stream = exec("df","--output=target").getInputStream();
      String result = "";
      do { result += (char) stream.read(); } while(stream.available() > 0);
      String[] lines = result.split("\n");
      for(int i = 1; i < lines.length; i++) {
        print(lines[i]);
        f = new File(lines[i]+s+"flight0.aiu");
        if(f.exists()) {
          out = f.getAbsolutePath();
        }
      }
    } catch(Exception e) {
      e.printStackTrace();
    }
    return out;
  } else {
    return "none";
  }
}
