library(quantmod)
library(plotly)

stocks <- c("UIS","ACN","IBM","LDOS","SAIC")

sDate <- '2015-01-01'
eDate <- Sys.Date()-1


getSymbols(stocks, src = 'google', from = sDate, to = eDate)


candleChart(UIS, up.col = "black", dn.col = "red", theme = "white")
addSMA(n = c( 50, 200))