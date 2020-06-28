String pathToCard() {
  String os = System.getProperty("os.name");
  switch(os) {
   case "Windows":
    char d = 'C';
    do {
      d++;
      f = new File(d+":\\flight0.aiu");
    } while(d <= 'Z' && !f.exists()); // find the ArdIU drive
    if(d <= 'Z') {
      return d+":";
    } else {
      return "none";
    }
   case "Linux":
    try {
      InputStream stream = exec("df","--output=target").getInputStream();
      String result = "";
      do { result += (char) stream.read(); } while(stream.available() > 0);
      String[] lines = result.split("\n");
      for(int i = 1; i < lines.length; i++) {
        print(lines[i]);
        f = new File(lines[i]+"/flight0.aiu");
        println(" "+f.exists());
      }
    } catch(Exception e) {
      e.printStackTrace();
    }
   default:
    return "none";
  }
}
