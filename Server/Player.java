import java.util.*;

public class Player {
    private ArrayList<Stock> stocks;
    private ArrayList<Integer> amounts;
    private double money;
    private String username;
    private String password;
    private boolean administrator;
    
    public Player(String u, String p) {
	username = u;
	password = p;
	stocks = new ArrayList<Stock>();
	amounts = new ArrayList<Integer>();
	money = 100000.0;
	administrator = false;
	// For creating a new user
    }

    public Player(String u, String p, double m, ArrayList<Stock> stcks, ArrayList<Integer> amts, boolean a) {
	username = u;
	password = p;
	money = m;
	stocks = stcks;
	amounts = amts;
	administrator = a;
	// For loading a user from file
    }

    public ArrayList<Stock> getStocks() {
	return stocks;
    }

    public ArrayList<Integer> getAmounts() {
	return amounts;
    }

    public void removeStocksWithZeros() {
	for (int i = 0; i < stocks.size(); i++) {
	    if (amounts.get(i) == 0) {
		amounts.remove(i);
		stocks.remove(i);
		i--;
	    }
	}
    }
    
    public String toString() {
	String toReturn = "";
	toReturn += username + "," + password + "," + money + ",";
	for (int i = 0; i < stocks.size(); i++) {
	    toReturn += stocks.get(i).toString() + ";";
	}
	toReturn = toReturn.substring(0, toReturn.length() - 1);
	toReturn += ",";
	for (int i = 0; i < amounts.size(); i++) {
	    toReturn += amounts.get(i) + ";";
	}
	toReturn = toReturn.substring(0, toReturn.length() - 1);
	toReturn += ",";
	if (administrator) {
	    toReturn += "true";
	}
	else {
	    toReturn += "false";
	}
	return toReturn;
    }

    public String printPortfolio() {
	String toReturn = "";
	for (int i = 0; i < stocks.size(); i++) {
	    toReturn += stocks.get(i).getSymbol() + "," + amounts.get(i) + ";";
	}
	try {
	    return toReturn.substring(0, toReturn.length() - 1);
	}
	catch (Exception e) {
	    return "";
	}
    }

    public boolean isAdministrator() {
	return administrator;
    }

    public double getMoney() {
	return money;
    }

    public String getUsername() {
	return username;
    }
    public String getPassword() {
	return password;
    }

    public void addMoney(double d) {
	money += d;
    }

    public void setMoney(double d) {
	money = d;
    }

    public void addStock(Stock s) {
	stocks.add(s);
	amounts.add(0);
    }

    public boolean hasStock(String s) {
	for (Stock i : stocks) {
	    if (i.getSymbol().equals(s)) {
		return true;
	    }
	}
	return false;
    }

    public boolean buyStock(String s, int amt) { // The stock needs to already be in the stocks list
	for (int i = 0; i < stocks.size(); i++) {
	    if (stocks.get(i).getSymbol().equals(s)) {
		if (stocks.get(i).getCurrentValue() * amt > money) {
		    return false;
		}
		else {
		    amounts.set(i, amounts.get(i) + amt);
		    money -= stocks.get(i).getCurrentValue() * amt;
		    return true;
		}
	    }
	}
	return false;
    }

    public boolean sellStock(String s, int amt) {
	for (int i = 0; i < stocks.size(); i++) {
	    if (stocks.get(i).getSymbol().equals(s)) {
		if (amounts.get(i) < amt) {
		    return false;
		}
		else {
		    amounts.set(i, amounts.get(i) - amt);
		    money += stocks.get(i).getCurrentValue() * amt;
		    return true;
		}
	    }
	}
	return false;
    }
}
