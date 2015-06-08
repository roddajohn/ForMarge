public class Stock {
  private String name, symbol, Comp1, Comp2, Comp3, Comp4, ED, EDD;
  private double currentValue, closeLastDay, openLastDay, BID, TargetEstimate, Beta, DaysRange, WeekVolume52, Volume, AvgVolume, MarketCapitalization, EPS, DividendsandYield, P2SR, FP2E, AEPS, QEPS, MeanRecomendations, PEGRatio;
  private double ExpectedTotalDifference;


  public Stock(String s) {
    symbol = s;
  }

  public Stock(String n, String s, double cv, double c, double o, double v, double d) {
    name = n;
    symbol = s;
    currentValue = cv;
    closeLastDay = c;
    openLastDay = o;
    Volume = v;
    DividendsandYield = d;
  }

  public void setCurrentValue(double d) {
    currentValue = d;
  }

  public void setCloseLastDay(double d) {
    closeLastDay = d;
  }

  public void setOpenLastDay(double d) {
    openLastDay = d;
  }

  public void setName(String s) {
    name = s;
  }

  public void setSymbol(String s) {
    symbol = s;
  }

  public void setVolume(double d) {
    Volume = d;
  }

  public void setDividendsandYield(double d) {
    DividendsandYield = d;
  }

  public String getSymbol() {
    return symbol;
  }

  public String getName() {
    return name;
  }

  public double getCurrentValue() {
    return currentValue;
  }

  public double getCloseLastDay() {
    return closeLastDay;
  }

  public double getOpenLastDay() {
    return openLastDay;
  }

  public double getVolume() {
    return Volume;
  }

  public double getDividendsandYield() {
    return DividendsandYield;
  }

  public String toString() {
    String toReturn = "";
    toReturn += symbol;
    return toReturn;
  }

  public String toString(boolean a) {
    String toReturn = "";
    toReturn += name + "," + symbol + "," + currentValue + "," + closeLastDay + "," + openLastDay + "," + Volume + "," + DividendsandYield;
    return toReturn;
  }
}

