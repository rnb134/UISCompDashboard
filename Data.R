library(quantmod)
library(plotly)


# dateInput <- reactive( {
# 
# stocks <- c("UIS","ACN","IBM","LDOS","SAIC")
# indices <- c("^GSPC","^DJI","^RUT")
# fixedIncome <-c("DGS10","DGS2","T10Y2Y")

# sDate <- '2017-01-01'
# eDate <- Sys.Date()-1


# getSymbols(stocks, src = 'google', from = input$sdateBox, to = input$edateBox)
# getSymbols(indices,auto.assign = TRUE, from = input$sdateBox, to =input$edateBox)
# getSymbols(fixedIncome, auto.assign = TRUE, src = 'FRED', from = input$sdateBox, to = input$edateBox)
# 
# df <- as.data.frame(cbind(UIS,ACN,LDOS,IBM))
# df$date <- time(UIS)

# candleChart(UIS, up.col = "black", dn.col = "red", theme = "white")
# addSMA(n = c( 50, 200))


# dataInput <- reactive({
#     getSymbols(input$symb, src = "google",
#                from = input$dates[1],
#                to = input$dates[2],
#                auto.assign = FALSE)
# })

# }
# )

# newInput <- reactive(
#     
#     {
#         getSymbols(input$p1SelectCompany, src = "google",
#                    from = input$sdateBox[1],
#                    to = input$edateBox[2],
#                    auto.assign = FALSE)
#         
#     }
# )