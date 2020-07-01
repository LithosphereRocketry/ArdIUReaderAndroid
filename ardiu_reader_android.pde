import android.content.*;

String pathToWrite() {
  final String s = java.io.File.separator;
  if(System.getProperty("java.runtime.name").equals("Android Runtime")) {

    Context context = this.getActivity().getApplicationContext();
    File[] locations = context.getExternalFilesDirs(null);
    if(locations.length <= 1) { return "none"; } else {
      String safedir = locations[1].getAbsolutePath();
      return safedir+s+"ardiu-processed";
    }
  } else { return pathToCard()+s+"ardiu-processed"; }
}

void setup() {
  fullScreen(P2D);
  load();
}
