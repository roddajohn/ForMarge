import java.util.*;
import java.net.*;
import java.io.*;

public class Controller {
    private ArrayList<Player> players;
    private StockAPI api;
    private ArrayList<ClientHandlingThread> threads;
    private final int port = 55564;
    private ServerSocket socket;
   
    public Controller() {
	api = new StockAPI();
	players = new ArrayList<Player>();
	threads = new ArrayList<ClientHandlingThread>();
	CommandLine c = new CommandLine();
	c.start();
	loadAPIFromFile();
	loadPlayersFromFile();
	startServer();
    }

    private String printPlayers() {
	String toReturn = "Players: ";
	for (int i = 0; i < players.size(); i++) {
	    toReturn += "Username: " + players.get(i).getUsername();
	    toReturn += " Money: " + players.get(i).getMoney();
	    toReturn += " Portfolio: " + players.get(i).printPortfolio();
	}
	return toReturn;
    }

    private void loadPlayersFromFile() {
	BufferedReader in = null;
	try {
	    in = new BufferedReader(new FileReader("players.csv"));
	}
	catch (FileNotFoundException e) {
	    e.printStackTrace();
	}
	String line = "";
	try {
	    while ((line = in.readLine()) != null) {
		String[] input = line.split(",");
		ArrayList<Stock> s = new ArrayList<Stock>();
		ArrayList<Integer> j = new ArrayList<Integer>();
		boolean a = false;
		try {
		    String[] stocks = input[3].split(";");
		    String[] amts = input[4].split(";");
		    for (int i = 0; i < stocks.length; i++) {
			s.add(api.getStock(stocks[i]));
		    }
		    for (int i = 0; i < amts.length; i++) {
			j.add(Integer.parseInt(amts[i]));
		    }
		    if (input[5].equals("true")) {
			a = true;
		    }
		}
		catch (ArrayIndexOutOfBoundsException e){
		    if (input[3].equals("true")) {
			a = true;
		    }
		}
		players.add(new Player(input[0], input[1], Double.parseDouble(input[2]), s, j, a));
	    }
	    in.close();
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
    }

    private void loadAPIFromFile() {
	BufferedReader in = null; 
	try {
	    in = new BufferedReader(new FileReader("api.csv"));
	}
	catch (FileNotFoundException e) {
	    e.printStackTrace();
	}
	String line = "";
	try {
	    while ((line = in.readLine()) != null) {
		String[] input = line.split(",");
		ArrayList<Stock> s = new ArrayList<Stock>();
		for (int i = 0; i < input.length; i++) {
		    s.add(new Stock(input[i]));
		}
		api.importStock(s);
	    }
	    in.close();
	}
	catch (IOException e) {
	    e.printStackTrace();
	}	
    }
    
    private void startServer() {
	socket = null;
	try {
	    socket = new ServerSocket(port);
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	
	Socket client = null;
	while (1 == 1) {
	    try {
		client = socket.accept();
		ClientHandlingThread c = new ClientHandlingThread(client);
		c.start(); 
		threads.add(c);
	    }
	    catch (IOException e) {
		e.printStackTrace();
		break;
	    }
	    catch (NullPointerException e) {
		e.printStackTrace();
	    }
	}
    }

    private boolean buyStock(Player p, String symbol, int amt) {
	if (!api.hasStock(symbol)) {
	    api.addStockToFollow(symbol);
	}
	if (!p.hasStock(symbol)) {
	    p.addStock(api.getStock(symbol));
	}
	return p.buyStock(symbol, amt);
    }

    private boolean sellStock(Player p, String symbol, int amt) {
	return p.sellStock(symbol, amt);
    }

    private void shutDown() {
	savePlayersToFile();
	saveStockAPIToFile();
	try {
	    socket.close();
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	for (int i = 0; i < threads.size(); i++) {
	    threads.get(0).sendQuitMessage();
	    threads.remove(0);
	}
	// This will shut down the server -- please also save all of the players states so that nothing breaks !  And/Or so that data isn't lost
    }

    private void savePlayersToFile() {
	PrintWriter writer = null;
	try {
	    writer = new PrintWriter("players.csv", "UTF-8");
	    for (Player p : players) {
		writer.println(p.toString());
	    }
	    writer.close();
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	// Outputs the players to a file, to be loaded later
    }

    private void saveStockAPIToFile() {
	PrintWriter writer = null;
	try {
	    writer = new PrintWriter("api.csv");
	}
	catch(FileNotFoundException e) {
	    e.printStackTrace();
	}
	writer.println(api.toString());
	writer.close();
	// Outputs the stockAPI to a file
    }
    
    private Player createUser(String username, String password) {
	// This will create a new user
	Player p = new Player(username, password);
	players.add(p);
	return p;
    }

    private void quitThread(ClientHandlingThread c) {
	threads.remove(c);
    }

    private class ClientHandlingThread extends Thread { 
	private Player player;
	private Socket socket;
	public ClientHandlingThread(Socket s) {
	    super("Client thread");
	    this.socket = s;
	}

	public void sendQuitMessage() {
	    try {
		PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
		BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

		out.println("quit");
	    }
	    catch (Exception e) {
		e.printStackTrace();
	    }
	}

	public void setMoney(String username, double money) {
	    for (Player p : players) {
		if (p.getUsername().equals(username)) {
		    p.setMoney(money);
		}
	    }
	}

	public void run() {
	    try {
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                String inputLine = "";                                                                        
                while ((inputLine = in.readLine()) != null) {                                          
                    String[] input = inputLine.split(" ");
		    if (input[0].equals("logout")) {
       			quitThread(this);
		    }
		    /*
		      To add, check to make sure the username is unique when added
		      If they get the username right, don't make them enter it again and again...
		     */
		    if (player == null) {
			if (input[0].equals("create")) {
			    boolean isUsed = false;
			    for (int i = 0; i < players.size(); i++) {
				if (players.get(i).getUsername().equals(input[1])) {
				    isUsed = true;
				}
			    }
			    if (!isUsed) {
				player = createUser(input[1], input[2]);
				out.println("success");
			    }
			    else {
				out.println("error");
			    }
			}
			else if (input[0].equals("login")) {
			    for (Player p : players) {
				if (p.getUsername().equals(input[1]) && p.getPassword().equals(input[2])) {			
				    player = p;
				}
			    }
			    if (player != null) {
				out.println("success");
			    }
			    else {
				out.println("error");
			    }
			}
			else {
			    out.println("error");
			}
		    }
		    else {
			if (player.isAdministrator() && input[0].equals("players")) {
			    out.println(printPlayers());
			}
			else if (player.isAdministrator() && input[0].equals("player")) {
			    try {
				if (input[1].equals("set")) {
				    if (input[2].equals("money")) {
					setMoney(input[3], Double.parseDouble(input[4]));
					out.println("success");
				    }
				    else {
					out.println("error");
				    }
				}
				else {
				    out.println("error");
				}
			    }
			    catch (ArrayIndexOutOfBoundsException e) {
				out.println("error");
			    }
			    catch (NumberFormatException e) {
				out.println("error");
			    }
			}
			else if (input[0].equals("get")) {
			    out.println(api.getStock(input[1]).toString(true));
			    System.out.println(api.getStock(input[1]).toString(true));
			}
			else if (input[0].equals("money")) {
			    out.println(player.getMoney());
			}
			else if (input[0].equals("portfolio")) {
			    out.println(player.printPortfolio());
			}
			else if (input[0].equals("buy")) {
			    try {
				if (buyStock(player, input[1], Integer.parseInt(input[2]))) {
				    out.println("success");
				}
				else {
				    out.println("error");
				}
			    }
			    catch (ArrayIndexOutOfBoundsException e) {
				out.println("error");
			    }
			}
			else if (input[0].equals("sell")) {
			    try {
				if (sellStock(player, input[1], Integer.parseInt(input[2]))) {
				    out.println("success");
				    player.removeStocksWithZeros();
				}
				else {
				    out.println("error");
				}
			    }
			    catch (ArrayIndexOutOfBoundsException e) {
				out.println("error");
			    }
			}
			else {
			    out.println("error");
			}
		    }
		}
               socket.close();
	       out.close();
	       in.close();
            }
            catch (IOException e) {
	    }
	}
	// This is a class that will be created to deal with any client who has connected, the constructor will have a player passed in so that it know how do deal with that player.
    }

    private class CommandLine extends Thread {
	public CommandLine() {

	}

	public void run() {
	    Scanner console = new Scanner(System.in);
	    while (1 == 1) {
		System.out.print("Command: ");
		String line = "";
		while ((line = console.nextLine()) != null) {
		    if (line.equals("shutdown")) {
			shutDown();
		    }
		    System.out.println();
		    System.out.print("Command: ");
		}
	    }
	}
	// This takes input from the server command line to run commands, currently, only the shutDown() function
    }
}
