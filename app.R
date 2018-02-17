    library(shiny)
    library(shinydashboard)
    library(readxl)
    library(plotly)
    library(quantmod)
    library(tidyquant)
    library(dplyr)
    library(magrittr)
    
    # ui = basicPage(
    #     actionButton("show", "Show modal dialog")
    # )
    # 
    

   


    dbHeader <- dashboardHeader(title = "IT Services Capital Mkts Dashboard", titleWidth = 450)
    
    dbSidebar <- dashboardSidebar(
        sidebarMenu(
            menuItem("Stock Prices",tabName = 'db1', icon = icon("dashboard")),
             menuItem("Sentiment Analysis", tabName = 'db2', icon = icon("bar-chart"))
            # menuItem("Thru the Years by Owner", tabName = 'db3', icon = icon("th")),
            # menuItem("The Best Team Names", tabName ='db4',icon =icon("trophy"))
        ), width = 200  
    )
    
    dbBody <- dashboardBody(
        tabItems(
            #FirstTab Open
            tabItem(tabName ='db1',h1("Stock Returns"),
                #  fluidPage(
                  fluidRow( box(title = 'Select Date Range',width = 4,height =275,solidHeader = TRUE, status ='primary',dateInput('sdateBox', h3('Begin Date'), min = '2015-01-01', max = Sys.Date()-1, value = '2017-01-01'),
                                dateInput('edateBox', h3('End Date'),  min = '2015-01-01', max = Sys.Date()-1,value = Sys.Date()-1)),
                            box(width =2, height = 275, solidHeader = TRUE, status ='primary', title = 'Select Company', selectInput("p1SelectCompany",label = "", choices = list("UIS","ACN","IBM","LDOS","CTSH","CSRA","CACI","S&P 500", "DJIA", "Russell 2000","BTCUSD=X"))),
                            box(width = 4, height = 275, solidHeader = TRUE, status = 'primary', title ='Select Moving Avg Length', sliderInput('MASlider', min = 5, max = 200,label = "", value = 50))
                            
                            
                            ),
                   fluidRow(
################################################FIRST PAGE FIRST ROW############################################################################################################
                              # box(title = 'Select Date Range',width = 2,height =300,solidHeader = TRUE, status ='primary',dateInput('sdateBox', h3('Begin Date'), min = '2015-01-01', max = Sys.Date()-1, value = '2017-01-01'),
                              #      dateInput('edateBox', h3('End Date'),  min = '2015-01-01', max = Sys.Date()-1,value = Sys.Date()-1)),
                              
                           box(width =12,plotOutput('SingleCompanyStockChart'), title = "Close Stock Prices",solidHeader = TRUE, status = 'primary')#,
                           # box(width =2, height = 150, solidHeader = TRUE, status ='primary', title = 'Select Company', selectInput("p1SelectCompany",label = "", choices = list("UIS","ACN","IBM","LDOS","CTSH","CSRA","CACI","S&P 500", "DJIA", "Russell 2000","BTCUSD=X")))
                           ),#closeFirstFluidRow
              
                                       
################################################FIRST PAGE SECOND ROW############################################################################################################           
                    fluidRow(box(width = 10,plotOutput('multiCompanyStockChart'),title = "Percentage Growth Over Time", solidHeader = TRUE, status = 'primary'),
                             box(width =2, height = 400, solidHeader = TRUE, status = 'primary', title = 'Select Stock/Index (5 Max)', checkboxGroupInput("p1SelectMultCompany",label = "",selected = c("UIS","ACN"), choices = list("UIS","ACN","IBM","LDOS","CTSH","CSRA","CACI","S&P 500", "DJIA", "Russell 2000","BTCUSD=X")))
                             )
                    
                    
                  #  )#closeFluidPage
                    
                    #FirstTabClose
                   ),
            #SecondTab Open
            tabItem(tabName = 'db2',h2("Sentiment Analysis"),
                    fluidPage(fluidRow(column(width =4,offset =0, style = 'padding:0px', box(tableOutput('TotalRecord'), title = 'Record since 2004', solidHeader = TRUE, status ='primary',width = 12 )),
                                       column(width = 8,offset =0, style = 'padding:0px', infoBox("Jgord","52.6% Win Rate", subtitle = "91-79-3", icon = icon('thumbs-up'), color ='light-blue'),
                                              infoBox("Jose","52.6% Win Rate", subtitle = "91-81-1", icon = icon('thumbs-up'), color ='lime'),
                                              infoBox("Lip","50.9% Win Rate", subtitle = "88-84-1", icon = icon('thumbs-up'), color ='orange'),
                                              infoBox("Z","49.7% Win Rate", subtitle = "86-84-3", icon = icon('thumbs-down'), color ='fuchsia'),
                                              infoBox("B","45.1% Win Rate", subtitle = "78-92-1", icon = icon('thumbs-down'), color ='aqua')
                                              
                                       )#end column 9
                                       
                                     
                                       
                    ),# close fluidRow
                    
                   
                    
                    fluidRow(column(width =6,offset = 0, style = 'padding:0px',box(plotOutput("Orig5Place"),title ='A distribution of Final Rankings', solidHeader = TRUE, status = 'primary',width = 12, background = 'light-blue')),
                             column(width =6,offset = 0, style ='padding:0px', tabBox(title = "", id = "tabSet1", width = 12,
                                                                                      tabPanel("PPG",plotOutput("PPGPlot")),
                                                                                      tabPanel('Diff/Gm',plotOutput("DiffGMPlot")),
                                                                                      tabPanel("Wins/Yr",plotOutput("WinsPerSeason")),
                                                                                      tabPanel('Avg Finish',plotOutput("AvgFinPlot")),
                                                                                      tabPanel('Moves/Yr',plotOutput("MovesYrPlot")),
                                                                                      tabPanel("# Playoffs",plotOutput("Top3Plot")))
                                    
                             )#closeColumn,
                             
                    )#closeFluidRow
                    
                   
                    )#close 2nd fluid page
                    
            )#SecondTabClose
            
        )#close TabItesm
        
     )#Clsoe Body
     
    
    
    ui <- dashboardPage(dbHeader,dbSidebar,dbBody)
    
    ################SERVER CODE#####################################################################################################################
   
    
    
     server <- function(input,output,session) {
         
    my_max <- 5
    my_min <-1
    ################OBSERVE - EVENT HANDLER - SET MIN/MAX in MULTI STOCK SELECTOR########################################################################## 
         observe({
             if(length(input$p1SelectMultCompany) > my_max)
             {
                 updateCheckboxGroupInput(session, "p1SelectMultCompany", selected= tail(input$p1SelectMultCompany,my_max))
             }
             if(length(input$p1SelectMultCompany) < my_min)
             {
                 updateCheckboxGroupInput(session, "p1SelectMultCompany", selected= "UIS")
             }
         })
         
        
     #######################FIRST PAGE SINGLE STOCK SELECTOR########################################################################################
         newInput <- reactive(
             
             {
              if (input$p1SelectCompany =='S&P 500') {
                  
                  tq_get("^GSPC", get='stock.prices', from = input$sdateBox, to = input$edateBox)
            
                  
              } else if (input$p1SelectCompany =='DJIA') {
                  tq_get("^DJI", get='stock.prices', from = input$sdateBox, to = input$edateBox)
              }
                 
             else if (input$p1SelectCompany =='Russell 2000') {
                 tq_get("^RUT", get='stock.prices', from = input$sdateBox, to = input$edateBox)
             }  
                 else {
                     tq_get(input$p1SelectCompany, get='stock.prices', from = input$sdateBox, to = input$edateBox)
                        }
                 
                    }
                )
         ##################################################################################################################################################################
         
        #############FUNCTION TO REMAP INDEX NAMES########################################################################################################################
         reMapIndexNames <- function(stockVector) {
        
        for ( i in 1:length(stockVector)) {
            
            if (stockVector[i]=='S&P 500') {
                stockVector[i] <- '^GSPC'
                
            }else if (stockVector[i]=='DJIA'){
                stockVector[i] <- '^DJI'
                
            }else if (stockVector[i]=='Russell 2000'){
                stockVector[i] <- '^RUT'
                
            }
            
            else{
                
            }
            
        }
        stockVector
    }
    
          ##################################################################################################################################################################
         
         #######################FIRST PAGE MULTIPLE STOCK SELECTOR###########################################################################################################
         multiInput <- reactive(
             
             {
                
                 perm.vector <- as.vector(input$p1SelectMultCompany)

                
                 #Apply function above to remap index names into tidy format 
                new.vector <- reMapIndexNames(perm.vector)
                    
                   if (length(input$p1SelectMultCompany)==1) {
                tidyquant::tq_get(new.vector, get='stock.prices', from = input$sdateBox, to = input$edateBox)  %>% mutate(Pct_Growth =adjusted/first(adjusted)-1)
                }else {
                    tidyquant::tq_get(new.vector, get='stock.prices', from = input$sdateBox, to = input$edateBox)  %>% group_by(symbol) %>% mutate(Pct_Growth =adjusted/first(adjusted)-1)
                  }
                }
             )
         ##################################################################################################################################################################
         
         #######################FPASS SELECTED STOCKS FROM MULTI SELECTOR INTO TQ GET RETRIEVE#############################################################################
          loadMultiData <- reactive (
             tidyquant::tq_get(multiInput(), get='stock.prices', from = input$sdateBox, to = input$edateBox)
 
         )
          #################################################################################################################################################################
        
         
          #######################FFIRST PAGE RENDER BOTTOM PLOT############################################################################################################
         output$multiCompanyStockChart<- renderPlot (
             if (length(input$p1SelectMultCompany)==0) {
                
             }
             
             else if (length(input$p1SelectMultCompany)==1) {
                 multiInput()  %>% ggplot(aes(x = date, y = Pct_Growth)) + geom_line(col = 'blue')

                 
             } else if (length(input$p1SelectMultCompany) >5) {
                 
             }else { multiInput()  %>% ggplot(aes(x = date, y = Pct_Growth, color = symbol)) + geom_line()


             } 
             
              )
         #################################################################################################################################################################
         
         #######################FFIRST PAGE RENDER TOP PLOT############################################################################################################
          output$SingleCompanyStockChart <- renderPlot(
         
              newInput() %>%
                  ggplot(aes(x = date, y = close)) +
                  geom_barchart(aes(open = open, high = high, low = low, close = close)) +
                  geom_ma(ma_fun = SMA, n = input$MASlider, linetype = 5, size = 1.25) +
                  labs(title = input$p1SelectCompany, y = "Closing Price", x = "") + 
                  theme_tq()
    
            #  chartSeries(newInput(),type = 'candlesticks',show.grid = FALSE,major.ticks = FALSE, minor.ticks = FALSE,name = paste(input$p1SelectCompany,"Candlestick Chart"),up.col = "green", dn.col = "red", theme = "white", TA = 'addSMA(n =50); addVo()')
             # candleChart(newInput(),up.col = "green", dn.col = "red", theme = "white", TA = 'addSMA(n=50); addSMA(n=100)')
          
           
        )#closeRenderPlot
         ################################################################################################################################################################# 
        
        
    }
    
    shinyApp(ui = ui,server = server)