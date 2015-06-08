import java.net.*;
import java.io.*;

public class ChartAPI {

  private final String BASEURL = "http://chart.finance.yahoo.com/z?s=";
  private final String TIMESPAN = "&t=";
  private final String ONEYEAR = "1y";
  private final String SIXMONTHS = "6m";
  private final String FIVEDAYS = "5d";
  private final String TYPEOFGRAPH = "&q=l";
  private final String SIZEOFGRAPH = "&z=s";
  
  String path;

  private final int BUFFER_SIZE = 4096;
  
  public ChartAPI() {
    path = dataPath(""); 
  }

  public String getChartAddress(int chartNumber, String symbol) {
    return path + symbol + ("" + chartNumber) + ".jpg";
  }

  public boolean loadCharts(String symbol) {
    try {
      println("URL = " + BASEURL + symbol + TIMESPAN + ONEYEAR + TYPEOFGRAPH + SIZEOFGRAPH);
      String url1 = BASEURL + symbol + TIMESPAN + ONEYEAR + TYPEOFGRAPH + SIZEOFGRAPH;
      String url2 = BASEURL + symbol + TIMESPAN + SIXMONTHS + TYPEOFGRAPH + SIZEOFGRAPH;
      String url3 = BASEURL + symbol + TIMESPAN + FIVEDAYS + TYPEOFGRAPH + SIZEOFGRAPH;
      String save1 = path + symbol + "1.jpg";
      String save2 = path + symbol + "2.jpg";
      String save3 = path + symbol + "3.jpg";
      saveImage(url1, save1);  
      saveImage(url2, save2);  
      saveImage(url3, save3);
    }
    catch (IOException e) {
      return false;
    }
    return true;
  }

  public boolean refreshCharts(String symbol) {
    return loadCharts(symbol);
  }  

  public void saveImage(String imageUrl, String destinationFile) throws IOException {
    URL url = new URL(imageUrl);
    InputStream is = url.openStream();
    OutputStream os = createOutput(destinationFile);

    byte[] b = new byte[4096];
    int length;

    while ( (length = is.read (b)) != -1) {
      os.write(b, 0, length);
    }

    is.close();
    os.close();
  }
}

