import java.io.*;
import java.net.*;
import java.nio.channels.*;
import java.util.*;

public class StockAPI {
    public final String BASEQUOTEURL = "http://download.finance.yahoo.com/d/quotes.csv?s=";
    public final String NAMEPROPERTY = "n";
    public final String SYMBOLPROPERTY = "s";
    public final String LATESTVALUEPROPERTY = "l1";
    public final String OPENLASTTRADINGDAYPROPERTY = "o";
    public final String CLOSELASTTRADINGDAYPROPERTY = "p";
    public final String USEPROPERTIES = "&f=";
    public final String ENDOFURLQUOTE = "&e=.csv";

    private final int BUFFER_SIZE = 4096;

    private ArrayList<Stock> stocks;
    private StockUpdateThread updateThread;

    public StockAPI() {
	stocks = new ArrayList<Stock>();
	updateThread = new StockUpdateThread();
	updateThread.start();
    }

    public String toString() {
	String toReturn = "";
	for (int i = 0; i < stocks.size(); i++) {
	    toReturn += stocks.get(i).getSymbol() + ",";
	}
	if (toReturn.length() != 0) {
	    toReturn = toReturn.substring(0, toReturn.length() - 1);
	}
	return toReturn;
    }

    public void importStock(ArrayList<Stock> s) {
	stocks = s;
	updateStocks();
    }

    public Stock getStock(String symbol) {
	Stock toReturn = null;
	for (int i = 0; i < stocks.size(); i++) {
	    if (stocks.get(i).getSymbol().equals(symbol)) {
		toReturn = stocks.get(i);
		System.out.println("In get stock " + toReturn.toString());
	    }
	}
	if (toReturn == null) {
	    addStockToFollow(symbol);
	    updateStocks();
	    toReturn = getStock(symbol);
	    System.out.println("In get stock " + toReturn.toString());
	    removeStockToFollow(symbol);
	}
	return toReturn;
    }

    public boolean hasStock(String symbol) {
	for (int i = 0; i < stocks.size(); i++) {
	    if (stocks.get(i).getSymbol().equals(symbol)) {
		return true;
	    }
	}
	return false;
    }

    public void addStockToFollow(String symbol) {
	stocks.add(new Stock(symbol));
	updateStocks();
	System.out.println("Updated in addStockToFollow");
    }

    public ArrayList<Stock> getStocks() {
	return stocks;
    }

    public void removeStockToFollow(String symbol) {
	for (int i = 0; i < stocks.size(); i++) {
	    if (stocks.get(i).getSymbol().equals(symbol)) {
		stocks.remove(i);
	    }
	}
    }
    
    /**
     * Downloads a file from a URL
     * @param fileURL HTTP URL of the file to be downloaded
     * @param saveDir path of the directory to save the file
     * @throws IOException
     *
     *  CODE NOT ORIGINAL -- CODE FROM http://www.codejava.net/java-se/networking/use-httpurlconnection-to-download-file-from-an-http-url
     */
    private void downloadFile(String fileURL, String saveDir)
	throws IOException {
        URL url = new URL(fileURL);
        HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
        int responseCode = httpConn.getResponseCode();
 
        // always check HTTP response code first
        if (responseCode == HttpURLConnection.HTTP_OK) {
            String fileName = "";
            String disposition = httpConn.getHeaderField("Content-Disposition");
            String contentType = httpConn.getContentType();
            int contentLength = httpConn.getContentLength();
 
            if (disposition != null) {
                // extracts file name from header field
                int index = disposition.indexOf("filename=");
                if (index > 0) {
                    fileName = disposition.substring(index + 10,
						     disposition.length() - 1);
                }
            } else {
                // extracts file name from URL
                fileName = fileURL.substring(fileURL.lastIndexOf("/") + 1,
					     fileURL.length());
            }
 
           // opens input stream from the HTTP connection
            InputStream inputStream = httpConn.getInputStream();
            String saveFilePath = saveDir;
            // opens an output stream to save into file
            FileOutputStream outputStream = new FileOutputStream(saveFilePath);
 
            int bytesRead = -1;
            byte[] buffer = new byte[BUFFER_SIZE];
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
 
            outputStream.close();
            inputStream.close();

        } else {
	    System.out.println("Error");
        }
        httpConn.disconnect();
    }

    private void removeExtraneousQuotationMarks() {
	BufferedReader br = null;
	String line = "";
	String toWrite = "";
	try {
	    br = new BufferedReader(new FileReader("quotes.csv"));
	    while ((line = br.readLine()) != null) {
	        toWrite += line + "\n";
	    }	
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	toWrite = toWrite.replace("\"", "");
	try {
	    PrintWriter writer = new PrintWriter("quotes.csv");
	    writer.print(toWrite);
	    writer.close();
	}
	catch (FileNotFoundException e) {
	    e.printStackTrace();
	}
    }

    private void updateStocks() {
	String url = "";
	if (stocks.size() != 0) {
	    url += BASEQUOTEURL;
	    for (int i = 0; i < stocks.size(); i++) {
		url += stocks.get(i).getSymbol() + ",";
	    }
	    System.out.println("URL = " + url);
	    url = url.substring(0, url.length() - 1);
	    url += USEPROPERTIES + NAMEPROPERTY + SYMBOLPROPERTY + LATESTVALUEPROPERTY + "p0" + "o0" + "v0" + "d0" + ENDOFURLQUOTE;
	    try {
		downloadFile(url, "quotes.csv");
	    }
	    catch (IOException e) {
		e.printStackTrace();
	    }
	    removeExtraneousQuotationMarks();
	    BufferedReader br = null;
	    String line = "";
	    try {
		br = new BufferedReader(new FileReader("quotes.csv"));
		int i = 0; 
		while ((line = br.readLine()) != null) {
		    System.out.println("Getting line: " + line);
		    String[] parsed = line.split(",");
		    stocks.get(i).setName(parsed[0]);
		    stocks.get(i).setSymbol(parsed[1]);
		    stocks.get(i).setCurrentValue(Double.parseDouble(parsed[2]));
		    if (parsed[3].equals("N/A")) {
			stocks.get(i).setCloseLastDay(-1);
		    }
		    else {
			stocks.get(i).setCloseLastDay(Double.parseDouble(parsed[3]));
		    }
		    if (parsed[4].equals("N/A")) {
			stocks.get(i).setOpenLastDay(-1);
		    }
		    else {
			stocks.get(i).setOpenLastDay(Double.parseDouble(parsed[4]));
		    }
		    if (parsed[5].equals("N/A")) {
			stocks.get(i).setVolume(-1);
		    }
		    else {
			stocks.get(i).setVolume(Double.parseDouble(parsed[5]));
		    }
		    if (parsed[6].equals("N/A")) {
			stocks.get(i).setDividendsandYield(-1);
		    }
		    else {
			stocks.get(i).setDividendsandYield(Double.parseDouble(parsed[6]));
		    }
		    i++;
		}
	    }
	    catch (FileNotFoundException e) {
		e.printStackTrace();
	    }
	    catch (IOException e) {
		e.printStackTrace();
	    }
	    catch (Exception e) {
		e.printStackTrace();
	    }
	    try {
		br.close();
	    }
	    catch (IOException e) {
		e.printStackTrace();
	    }
	} 
    }
    
    private class StockUpdateThread extends Thread {
	private ArrayList<String> stocks;
	public StockUpdateThread() {}
	
	public void run() {
	    while (1 == 1) {
		updateStocks();
		try {
		    sleep(10000);
		}
		catch (InterruptedException e) {
		    
		}
	    }
	}    
    }
}
