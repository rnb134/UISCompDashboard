library(plotly)
library(quantmod)
library(magrittr)

  #set start  & end date
  startDate <-as.Date('12/1/2017')
  endDate<-as.Date('2/9/2018')

  #ticker Array  
  stockTickerArray <- c("UIS","ACN","IBM","LDOS")
  
  #return Matrix from Google
  getSymbols(stockTickerArray, src = 'google', from = startDate, to = endDate)
  
  #createDataFrame & add date column from Matrix
  use <- data.frame(as.xts(merge(UIS,ACN,IBM,LDOS)))
  use$Date <- time(UIS)
  
  #create Candle Chart
  # candleChart(UIS, up.col = "black", dn.col = "red", theme = "white")
  # addSMA(n = c(50,200))
  
  plotVar <- 'UIS'
  # openVar <-paste0(plotVar,".Open")
  # closeVar <-paste0(plotVar,".Close")
  # highVar <-paste0(plotVar,".High")
  # lowVar <-paste0(plotVar,".Low")
  #create sick plotly chart
  p <- use %>% 
    plot_ly(x=use$Date,  type="candlestick",
            open = use[,paste0(plotVar,'.Open')], close = use[,paste0(plotVar,'.Close')],
            high = use[,paste0(plotVar,'.High')], low = use[,paste0(plotVar,'.Low')]) %>%
    add_lines(x = use$Date, y = "", line = list(color = 'black', width = 0.75), inherit = F) %>%
    layout(showlegend = FALSE, yaxis = list(title = "Stock Price"))
  
#  p 
  
  #VOlume Chart
  pp <- use %>%
    plot_ly(x=use$Date, y=use[,paste0(plotVar,".Volume")], type='bar', name = paste(plotVar," Volume"), marker = list(color = 'rgb(55, 83, 109)')) %>%
    layout(yaxis = list(title = "Volume"))
  
 # pp
  
  #combine Two Charts
  q <- subplot(p, pp, heights = c(0.7,0.2), nrows=2,
               shareX = TRUE, titleY = TRUE) %>% layout(showlegend = FALSE)
  q
  
  