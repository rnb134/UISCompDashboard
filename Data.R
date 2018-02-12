library(quantmod)
library(plotly)

stocks <- c("UIS","ACN","IBM","LDOS","SAIC")
indices <- c("^GSPC","^DJI","^RUT")
fixedIncome <-c("DGS10","DGS2","T10Y2Y")

sDate <- '2017-01-01'
eDate <- Sys.Date()-1


getSymbols(stocks, src = 'google', from = sDate, to = eDate)
getSymbols(indices,auto.assign = TRUE, from = sDate)
getSymbols(fixedIncome, auto.assign = TRUE, src = 'FRED', from = sDate, to = eDate)


candleChart(UIS, up.col = "black", dn.col = "red", theme = "white")
addSMA(n = c( 50, 200))