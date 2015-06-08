 public class TradingAlgorithm{
  
  private double currentValue, closeLastDay, openLastDay, BID, TargetEstimate, Beta, DaysRange, Week52Volume, Volume, AvgVolume, MarketCapitalization, EPS, DividendsandYield, P2SR,  FP2E, AEPS, QEPS, MeanReccomendations, PEGRatio;
 
    
        private double currentValue1, closeLastDay1, openLastDay1, BID1, TargetEstimate1, Beta1, DaysRange1, Week52Volume1, Volume1, AvgVolume1, MarketCapitalization1, EPS1, 	DividendsandYield1, P2SR1,  FP2E1, AEPS1, QEPS1, MeanReccomendations1, PEGRatio1; 
     
      private double WcurrentValue, WcloseLastDay, WopenLastDay, WBID, WTargetEstimate, WBeta, WDaysRange, WWeek52Volume, WVolume, WAvgVolume, WMarketCapitalization, WEPS, WDividendsandYield, WP2SR,  WFP2E, WAEPS, WQEPS, WMeanReccomendations, WPEGRatio;
        
     private ArrayList StocksConsidered;
     private ArrayList StocksSharesPerMinute, ExpectedDifference, Wieghts;
     
     private double MinIndex, MaxIndex;
     
     private Stock MinStock, MaxStock;
     
   


     public void TradingMaster(boolean TF, Player player1){
         double SharesPerSecondActual;
        
         while (TF) {
              
              StocksConsidered = player1.getStocks();
         StocksSharesPerMinute = player1.getStockSharesPerMinute();
              ExpectedDifference = player1.getExpectedDifference();
              StocksSharesPerMinute = player1.getWeights();
             
              StockTrades();
                          
            SharesPerSecondActual = (StocksSharesPerMinute.get(MaxIndex)  +  StocksSharesPerMinute.get(MinIndex)/60);  
             player1.buyStock((StocksConsidered.get(MinIndex).getSymbol()), SharesPerSecondActual);
             player1.sellStock(StocksConsidered.get(MinIndex).getSymbol(), SharesPerSecondActual);
             
            
         
         wait(1000);
         }  
         
     }
         
    //Array list of expected diffrences in the player class
                                     
         
     public void StockTrades(){
         int Min = (ExpectedDifference.get(0));
         int Max = (ExpectedDifference.get(0));
         MinIndex = -1;
         MaxIndex = -1;
         
         for (int i = 0; i < StocksConsidered.size(); i++){
             if (ExpectedDifference.get(i) < Min){
                 Stock MinStock = StocksConsidered.get(i);
                 MinIndex = i;
                 
                 
             }
             
               if (ExpectedDifference.get(i) > Max){
                 Stock MaxStock = ExpectedDifference.get(i);
                 MaxIndex = i;
                    
             }      
             
         }
         
         
         
     }
                                     
     
        public double AllExpectedDifference(){
              double ExpectedDifference12 = 0;                           
              ExpectedDifference12 += (currentValue - currentValue1) * WcurrentValue;
            ExpectedDifference12 += (closeLastDay - closeLastDay1) * WcloseLastDay;
            ExpectedDifference12 += (openLastDay - openLastDay1) * WopenLastDay;
            ExpectedDifference12 += (BID - BID1) * WBID;
            ExpectedDifference12 += (TargetEstimate - TargetEstimate1) * WTargetEstimate;
            ExpectedDifference12 += (Beta - Beta1) * WBeta;
            ExpectedDifference12 += (DaysRange - DaysRange1) * WDaysRange;
            ExpectedDifference12 += (Week52Volume - Week52Volume1) * WWeek52Volume;
            ExpectedDifference12 += (Volume - Volume1) * WVolume;
            ExpectedDifference12 += (AvgVolume - AvgVolume1) * WAvgVolume;
            ExpectedDifference12 += (MarketCapitalization - MarketCapitalization1) * WMarketCapitalization;
            ExpectedDifference12 += (EPS - EPS1) * WEPS;
            ExpectedDifference12 += (DividendsandYield - DividendsandYield1) * WDividendsandYield;
            ExpectedDifference12 += (P2SR - P2SR1) * WP2SR;                               
            ExpectedDifference12 += (FP2E - FP2E1) * WFP2E;
            ExpectedDifference12 += (AEPS - AEPS1) * WAEPS;
            ExpectedDifference12 += ( QEPS -  QEPS1) * WQEPS;
            ExpectedDifference12 += (MeanReccomendations - MeanReccomendations1) * WMeanReccomendations;
            ExpectedDifference12 += (PEGRatio - PEGRatio1) * WPEGRatio;
            ExpectedDifference12 += (currentValue - currentValue1) * WcurrentValue;  
            
            return ExpectedDifference12;
        }
 
                                     //Set the  Actual Values
    public void setCurrentValue(double d) {
	currentValue = d;
    }

    public void setCloseLastDay(double d) {
	closeLastDay = d;
    }

    public void setOpenLastDay(double d) {
	openLastDay = d;
    }

    
    public void setBid(double d){
	BID = d;      
    }
    
    public void set1YrTargetEstimate(double d){
	TargetEstimate = d;        
    }
    
    public void setBeta(double d){
	Beta = d;
    }
    
    public void setDaysRange(double d) {
	DaysRange = d;
        
    }
    
    public void set52WeekVolume(double d) {     
	Week52Volume = d;
    }
    
    public void setVolume(double d) {
	Volume = d;
    }
    
    public void setAvgVolume(double d) {
	AvgVolume = d; 
    }
    
    public void setMarketCapitalization(double d) {
	MarketCapitalization = d;
    }
    
    public void setEPS(double d) {
	EPS = d;
    }
    
    public void setDividendsandYield(double d) {
	DividendsandYield = d;   
    }
    
    public void setPricetoSalesRatio(double d) {
	P2SR = d;    
    }
    
    public void setForwardPricetoEarnings(double d){
	FP2E = d;
    }
   
    
    public void setAnnualEarningsperShare(double d) {
	AEPS = d;
    }
    
    public void setQuarterlyEarningsPerShareEstimated(double d) {
	QEPS = d;
    }
    
    public void setMeanRecomendations(double d) {
	MeanReccomendations = d;
    }
    
    public void setPEGRatio(double d) {
	PEGRatio = d;
    }     
                                     
                                     // Set the desired values
                                     
     
    public void setCurrentValue1(double d) {
	currentValue1 = d;
    }

    public void setCloseLastDay1(double d) {
	closeLastDay1 = d;
    }

    public void setOpenLastDay1(double d) {
	openLastDay1 = d;
    }

    
    public void setBid1(double d){
	BID1 = d;      
    }
    
    public void set1YrTargetEstimate1(double d){
	TargetEstimate1 = d;        
    }
    
    public void setBeta1(double d){
	Beta1 = d;
    }
    
    public void setDaysRange1(double d) {
	DaysRange1 = d;
        
    }
    
    public void set52WeekVolume1(double d) {     
	Week52Volume1 = d;
    }
    
    public void setVolume11(double d) {
	Volume1 = d;
    }
    
    public void setAvgVolume1(double d) {
	AvgVolume1 = d; 
    }
    
    public void setMarketCapitalization1(double d) {
	MarketCapitalization1 = d;
    }
    
    public void setEPS1(double d) {
	EPS1 = d;
    }
    
    public void setDividendsandYield1(double d) {
	DividendsandYield1 = d;   
    }
    
    public void setPricetoSalesRatio1(double d) {
	P2SR1 = d;    
    }
    
    public void setForwardPricetoEarnings1(double d){
	FP2E1 = d;
    }
  
    
    public void setAnnualEarningsperShare1(double d) {
	AEPS1 = d;
    }
    
    public void setQuarterlyEarningsPerShareEstimated1(double d) {
	QEPS1 = d;
    }
    
    public void setMeanRecomendations1(double d) {
	MeanReccomendations1 = d;
    }
    
    public void setPEGRatio1(double d) {
	PEGRatio1 = d;
    }
                                     
                                    //Set the wieghts for each value
                                     
                                     

    public void WsetCurrentValue(double d) {
	WcurrentValue = d;
    }

    public void WsetCloseLastDay(double d) {
	WcloseLastDay = d;
    }

    public void WsetOpenLastDay(double d) {
	WopenLastDay = d;
    }

    
    public void WsetBid(double d){
	WBID = d;      
    }
    
    public void Wset1YrTargetEstimate(double d){
	WTargetEstimate = d;        
    }
    
    public void WsetBeta(double d){
	WBeta = d;
    }
    
    public void WsetDaysRange(double d) {
	WDaysRange = d;
        
    }
    
    public void Wset52WeekVolume(double d) {     
	WWeek52Volume = d;
    }
    
    public void WsetVolume(double d) {
	WVolume = d;
    }
    
    public void WsetAvgVolume(double d) {
	WAvgVolume = d; 
    }
    
    public void WsetMarketCapitalization(double d) {
	WMarketCapitalization = d;
    }
    
    public void WsetEPS(double d) {
	WEPS = d;
    }
    
    public void WsetDividendsandYield(double d) {
	WDividendsandYield = d;   
    }
    
    public void WsetPricetoSalesRatio(double d) {
	WP2SR = d;    
    }
    
    public void WsetForwardPricetoEarnings(double d){
	WFP2E = d;
    }
 
    
    public void WsetAnnualEarningsperShare(double d) {
	WAEPS = d;
    }
    
    public void WsetQuarterlyEarningsPerShareEstimated(double d) {
	WQEPS = d;
    }
    
    public void WsetMeanRecomendations(double d) {
	WMeanReccomendations = d;
    }
    
    public void WsetPEGRatio(double d) {
	WPEGRatio = d;
    }                                     
                                     
                                         
 }
