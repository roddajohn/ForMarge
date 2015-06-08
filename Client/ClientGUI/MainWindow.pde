import controlP5.*;
import javax.swing.*;

public class MainWindow extends JFrame {
  private final int w = 600;
  private final int h = 400;  

  private Client client; 
  private ControlP5 c;
  private PApplet main;

  // STILL HAVE TO DEAL WITH CLOSING ISSUES, ie, ALL WINDOWS CLOSED BUT IT IS STILL RUNNING
  public void quit() {
    dispose();
  }

  // STILL HAVE TO DEAL WITH CLOSING ISSUES, ie, ALL WINDOWS CLOSED BUT IT IS STILL RUNNING

  // Add an administrator command that pushes the player, and StockAPI information to a file for easier viewing...

  // Fix issues that occur when you search for a stock that doesn't exist...

  public MainWindow(Client c, PApplet m) {
    main = m;
    client = c;
    setBounds(100, 75, 600, 400);

    this.setResizable(false);
    PApplet p = new secondApplet();
    add(p);
    p.init();
    show();
  }

  private class secondApplet extends PApplet {
    private ArrayList<Stock> stocks;

    private ArrayList<String> portfolio;
    private ArrayList<Integer> amts;

    private ArrayList<String> history;

    private Textfield search, amount, sellAmount;

    private Textlabel name, symbol, current, open, close, volume, dividends, moneyLabel;

    private ChartAPI charts;

    private Toggle chart1, chart2, chart3;

    private int tabState, chartState;

    public boolean chartsReady;

    private ChartThread t;

    private double money;

    ListBox l, h;

    String stock;

    public void setup() {


      println(dataPath(""));

      background(255); 
      c = new ControlP5(this);

      c.getTab("default").activateEvent(true).setLabel("Search for Stock").setId(1).setWidth(w / 3).setHeight(20);
      c.addTab("portfolio").activateEvent(true).setLabel("View your Portfolio").setId(2).setWidth(w / 3).setHeight(20);
      c.addTab("algorithm").activateEvent(true).setLabel("View your Automated Trading Settings").setWidth(w / 3).setHeight(20);

      history = new ArrayList<String>();
      money = 0.0;
      chartsReady = false;
      charts = new ChartAPI();
      tabState = 0;
      chartState = 0;
      stocks = new ArrayList<Stock>();
      portfolio = new ArrayList<String>();
      amts = new ArrayList<Integer>();
      stock = "";

      background(255);
      c = new ControlP5(this);

      c.getTab("default").setLabel("Search").setWidth(600 / 4).setHeight(40).setId(1).activateEvent(true);
      c.addTab("tab2").setLabel("Portfolio").setWidth(600 / 4).setHeight(40).setId(2).activateEvent(true);
      c.addTab("tab3").setLabel("Algorithm").setWidth(600 / 4).setHeight(40).setId(3).activateEvent(true);
      c.addTab("tab4").setLabel("History -- Temporary").setWidth(600 / 4).setHeight(40).setId(11).activateEvent(true);

      // Setup of the PORTFOLIO tab

      moneyLabel = c.addTextlabel("Money: ").setPosition(10, 50).moveTo("tab2").setColor(0);
      l = c.addListBox("Portfolio").setPosition(10, 80).moveTo("tab2").setHeight(280).setWidth(100).setItemHeight(15).setBarHeight(10).setId(10).actAsPulldownMenu(false).activateEvent(true).disableCollapse(); // 100 x 20
      c.addTextlabel("sellLabel").setText("Sell: ").setPosition(130, 340).moveTo("tab2").setColor(0);
      sellAmount = c.addTextfield("sellAmount").setPosition(160, 335).setWidth(100).setHeight(20).moveTo("tab2");
      c.addButton("sellButton").setId(12).setPosition(280, 335).setSize(50, 20).moveTo("tab2").setLabel("Sell");

      // HISTORY TAB SETUP

      h = c.addListBox("History -- The Newest Transactions are at the Bottom").setPosition(10, 60).moveTo("tab4").setHeight(300).setWidth(565).setItemHeight(15).setBarHeight(10);

      // SETUP OF ALGORITHM

      // Setup of the SEARCH tab

      c.addTextlabel("search").setText("Search: ").setLabel("").setPosition(15, 55).setColor(0).moveTo("default");
      search = c.addTextfield("searchField").setLabel("").setPosition(65, 50).moveTo("default").setWidth(100).moveTo("default").setFocus(true);
      c.addButton("searchButton").setLabel("Search").setPosition(180, 50).setSize(50, 20).setId(4).moveTo("default");
      c.addButton("refreshButton").setLabel("Refresh").setPosition(250, 50).setSize(50, 20).setId(5).moveTo("default");
      c.addTextlabel("buyLabel").setText("Buy: ").setPosition(315, 55).moveTo("default").setColor(0);
      amount = c.addTextfield("amountEnteringField").setLabel("").setPosition(350, 50).moveTo("default").setWidth(150).setFocus(false);
      c.addButton("buyButton").setLabel("Buy").setPosition(525, 50).setId(9).moveTo("default").setSize(50, 20);
      c.addTextlabel("name").setText("Name: ").setPosition(15, 95).moveTo("default").setColor(0);
      c.addTextlabel("symbol").setText("Symbol: ").setPosition(15, 120).moveTo("default").setColor(0);
      c.addTextlabel("currentValue").setText("Current Price: ").setPosition(15, 145).moveTo("default").setColor(0);
      c.addTextlabel("closeLastDay").setText("Close Last Day: ").setPosition(15, 170).moveTo("default").setColor(0);
      c.addTextlabel("open").setText("Open: ").setPosition(15, 195).moveTo("default").setColor(0);
      c.addTextlabel("volume").setText("Volume: ").setPosition(15, 220).moveTo("default").setColor(0);
      c.addTextlabel("dividendsandyield").setText("Dividends and Yield: ").setPosition(15, 245).moveTo("default").setColor(0);

      name = c.addTextlabel("nameT").setText("").setPosition(45, 95).moveTo("default").setColor(0);
      symbol = c.addTextlabel("symbolT").setText("").setPosition(55, 120).moveTo("default").setColor(0);
      current = c.addTextlabel("currentT").setText("").setPosition(75, 145).moveTo("default").setColor(0);
      close = c.addTextlabel("closeT").setText("").setPosition(85, 170).moveTo("default").setColor(0);
      open = c.addTextlabel("openT").setText("").setPosition(45, 195).moveTo("default").setColor(0);
      volume = c.addTextlabel("volumeT").setText("").setPosition(60, 220).moveTo("default").setColor(0);
      dividends = c.addTextlabel("dividendsT").setText("").setPosition(100, 245).moveTo("default").setColor(0);

      chart1 = c.addToggle("chart1").setPosition(181, 81).setWidth(139).setHeight(20).setId(6).moveTo("default");
      chart1.setBroadcast(false);
      chart1.setValue(true);
      chart1.setBroadcast(true);
      chart2 = c.addToggle("chart2").setPosition(320, 81).setWidth(139).setHeight(20).setId(7).moveTo("default");
      chart2.setBroadcast(false);
      chart2.setValue(false);
      chart2.setBroadcast(true);
      chart3 = c.addToggle("chart3").setPosition(459, 81).setWidth(140).setHeight(20).setId(8).moveTo("default");
      chart3.setBroadcast(false);
      chart3.setValue(false);
      chart3.setBroadcast(true);

      // Moving to correct tabs

      c.getController("search").moveTo("default");
      c.getController("searchField").moveTo("default");
      c.getController("searchButton").moveTo("default");
    }
    public void draw() {
      background(255);
      if (tabState == 0) {
        line(0, 80, 800, 80);
        line(180, 80, 180, 400);
        if (!stock.equals("")) {
          for (Stock s : stocks) {
            if (s.getSymbol().equals(stock)) {
              name.setText(s.getName());
              if (s.getName().length() > 25) {
                name.setText(s.getName().substring(0, 25));
              }
              symbol.setText(s.getSymbol());
              current.setText("" + s.getCurrentValue());
              close.setText("" + s.getCloseLastDay());
              open.setText("" + s.getOpenLastDay());
              volume.setText("" + s.getVolume());
              dividends.setText("" + s.getDividendsandYield());
            }
          }
          if (chartsReady) {
            PImage img = loadImage(charts.getChartAddress(chartState + 1, stock));
            try {
              image(img, 190, 110, 400, 250);
            }
            catch (NullPointerException e) {
              fill(0);
              textSize(48);
              text("ERROR", 300, 200);
            }
            img = null;
          } else {
            fill(0);
            textSize(48);
            text("Loading...", 300, 200);
          }
        }
      } else if (tabState == 1) {
        if (chartsReady) {
          PImage img = loadImage(charts.getChartAddress(1, stock));
          try {
            image(img, 130, 50, 460, 275);
          }
          catch (NullPointerException e) {
            fill(0);
            textSize(48);
            text("ERROR", 300, 200);
          }

          img = null;
        } else if (!stock.equals("")) {
          fill(0);
          textSize(48);
          text("Loading...", 300, 200);
        }

        line(120, 40, 120, 400);
        line(120, 320, 600, 320);

        moneyLabel.setText("Money: " + (int)money);
      } else if (tabState == 2) {
      } else if (tabState == 3) {
        h.clear();
        for (int i = 0; i < history.size (); i++) {
          h.addItem(history.get(i), i);
        }
      }
    }

    public void updateMoney() {
      money = Double.parseDouble(client.recieveInformation("money"));
    }

    public void updatePortfolio() {
      portfolio.clear();
      amts.clear();
      String information = client.recieveInformation("portfolio");
      println("Recieved this information: " + information);
      if (!information.equals("")) {
        println("inside");
        String[] parsed = information.split(";");
        for (int i = 0; i < parsed.length; i++) {
          String[] a = parsed[i].split(",");
          println("have: " + a[0]);
          portfolio.add(a[0]);
          amts.add(Integer.parseInt(a[1]));
        }
      }
      l.clear();
      for (int i = 0; i < portfolio.size (); i++) {
        l.addItem(portfolio.get(i) + " " + amts.get(i), i);
      }
      l.updateListBoxItems();
      l.updateEvents();
      l.update();
      println("Got through update portfolio");
    }

    public void updateStock(String st) {
      if (!stock.equals("")) {
        chartsReady = false;
        boolean found = false;
        for (Stock s : stocks) {
          if (s.getSymbol().equals(st)) {
            String input = client.recieveInformation("get " + st);
            if (input.equals("-1")) {
              errorMessage("We have experienced an error, please contact Rodda");
            } else {
              String[] parsed = input.split(",");
              s.setName(parsed[0]);
              s.setSymbol(parsed[1]);
              s.setCurrentValue(Double.parseDouble(parsed[2]));
              s.setCloseLastDay(Double.parseDouble(parsed[3]));
              s.setOpenLastDay(Double.parseDouble(parsed[4]));
              s.setVolume(Double.parseDouble(parsed[5]));
              s.setDividendsandYield(Double.parseDouble(parsed[6]));
              found = true;
            }
          }
        }
        if (!found) {
          String input = client.recieveInformation("get " + st);
          if (input.equals("-1")) {
            errorMessage("We have experienced an error, please contact Rodda");
          } else {
            String[] parsed = input.split(",");
            stocks.add(new Stock(parsed[0], parsed[1], Double.parseDouble(parsed[2]), Double.parseDouble(parsed[3]), Double.parseDouble(parsed[4]), Double.parseDouble(parsed[5]), Double.parseDouble(parsed[6])));
          }
        }
        ChartThread t = new ChartThread(charts, st);
        t.start();
      }
    }

    public void keyPressed() {
      if (tabState == 0) {
        if (keyCode == 10) {
          if (search.getText().equals("")) {
            errorMessage("You cannot leave the search field blank");
          } else {
            stock = search.getText();
            updateStock(stock);
          }
        } /*else if (keyCode == 82) {
         updateStock(stock);
         } */
        else if (keyCode == 9) {
          if (search.isFocus()) {
            search.setFocus(false);
          } else {
            search.setFocus(true);
          }
        }
      } else if (tabState == 2) {
        if (keyCode == 10) {
          if (!stock.equals("") && !sellAmount.getText().equals("")) {
            try {
              int shares = Integer.parseInt(sellAmount.getText());
              if (client.sendMessage("sell " + stock + " " + shares)) {
                double d = 0.0;
                updateStock(stock);
                for (Stock s : stocks) {
                  if (s.getSymbol().equals(stock)) {
                    d = s.getCurrentValue();
                  }
                }
                message("Success -- you just sold " + shares + " shares of " + stock + " at " + d + " a share!");
                history.add("Sold " + shares + " shares of " + stock);
              } else {
                errorMessage("You don't have that many shares");
              }
            }
            catch (NumberFormatException a) {
              errorMessage("Please enter a number into the amount field");
            }
          } else {
            errorMessage("Ensure that you have entered an amount and that you have selected the stock you wish to sell.");
          }
          amount.setText("");
          updatePortfolio();
          updateMoney();
        }
      }
    }

    public void controlEvent(ControlEvent e) {
      switch(e.getId()) {
      case 1:
        stock = "";
        chartsReady = false;
        tabState = 0;
        break;

      case 2:
        tabState = 1;
        updatePortfolio();
        updateMoney();
        chartsReady = false;
        stock = "";
        break;

      case 3:
        tabState = 2;
        break;

      case 11:
        tabState = 3;
        break;

      case 4:
        if (search.getText().equals("")) {
          errorMessage("You cannot leave the search field blank");
        } else {
          stock = search.getText();
          updateStock(stock);
        }
        break;

      case 5:
        updateStock(stock);
        break;

      case 6:
        if (chartState == 0) {
          chart1.setBroadcast(false);
          chart1.setValue(true);
          chart1.setBroadcast(true);
        } else {
          chart1.setBroadcast(false);
          chart2.setBroadcast(false);
          chart3.setBroadcast(false);
          chart1.setValue(true);
          chart2.setValue(false);
          chart3.setValue(false);
          chart1.setBroadcast(true);
          chart2.setBroadcast(true);
          chart3.setBroadcast(true);
          chartState = 0;
        }

        break;
      case 7:
        if (chartState == 1) {
          chart2.setBroadcast(false);
          chart2.setValue(true);
          chart2.setBroadcast(true);
        } else {
          chart1.setBroadcast(false);
          chart2.setBroadcast(false);
          chart3.setBroadcast(false);
          chart1.setValue(false);
          chart2.setValue(true);
          chart3.setValue(false);
          chart1.setBroadcast(true);
          chart2.setBroadcast(true);
          chart3.setBroadcast(true);
          chartState = 1;
        }

        break;
      case 8:
        if (chartState == 2) {
          chart3.setBroadcast(false);
          chart3.setValue(true);
          chart3.setBroadcast(true);
        } else {
          chart1.setBroadcast(false);
          chart2.setBroadcast(false);
          chart3.setBroadcast(false);
          chart1.setValue(false);
          chart2.setValue(false);
          chart3.setValue(true);
          chart1.setBroadcast(true);
          chart2.setBroadcast(true);
          chart3.setBroadcast(true);
          chartState = 2;
        }
        break;

      case 9:
        if (!stock.equals("") && !amount.getText().equals("")) {
          try {
            int shares = Integer.parseInt(amount.getText());
            if (client.sendMessage("buy " + stock + " " + shares)) {
              double d = 0.0;
              updateStock(stock);
              for (Stock s : stocks) {
                if (s.getSymbol().equals(stock)) {
                  d = s.getCurrentValue();
                }
              }
              message("Success -- you just bought " + shares + " shares of " + stock + " at " + d + " a share!");
              history.add("Bought " + shares + " shares of " + stock);
            } else {
              errorMessage("You don't have enough money, the purchase did not go through");
            }
          }
          catch (NumberFormatException a) {
            errorMessage("Please enter a number into the amount field");
          }
        } else {
          errorMessage("Please enter something into both text fields, and make sure that you have already searched the stock.");
        }
        sellAmount.setText("");
        break;

      case 10:
        stock = portfolio.get((int)e.group().value());
        chartsReady = false;
        t = new ChartThread(charts, stock);
        t.start();
        break;

      case 12:
        if (!stock.equals("") && !sellAmount.getText().equals("")) {
          try {
            int shares = Integer.parseInt(sellAmount.getText());
            if (client.sendMessage("sell " + stock + " " + shares)) {
              double d = 0.0;
              updateStock(stock);
              for (Stock s : stocks) {
                if (s.getSymbol().equals(stock)) {
                  d = s.getCurrentValue();
                }
              }
              message("Success -- you just sold " + shares + " shares of " + stock + " at " + d + " a share!");
              history.add("Sold " + shares + " shares of " + stock);
            } else {
              errorMessage("You don't have that many shares");
            }
          }
          catch (NumberFormatException a) {
            errorMessage("Please enter a number into the amount field");
          }
        } else {
          errorMessage("Ensure that you have entered an amount and that you have selected the stock you wish to sell.");
        }
        amount.setText("");
        updatePortfolio();
        updateMoney();
        break;
      }
    } 


    public void stop() {
      client.sendMessage("logout");
      main.exit();
      quit();
      exit();
    }


    public void errorMessage(String e) {
      JOptionPane.showMessageDialog(new JFrame(), e, "Error", JOptionPane.ERROR_MESSAGE);
    }

    public void message(String e) {
      JOptionPane.showMessageDialog(new JFrame(), e);
    }

    private class ChartThread extends Thread {
      ChartAPI charts;
      String symbol;
      public ChartThread(ChartAPI c, String s) {
        symbol = s;
        charts = c;
      }

      public void run() {
        charts.loadCharts(symbol);
        chartsReady = true;
      }
    }
  }
}

