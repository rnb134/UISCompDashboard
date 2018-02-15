    library(shiny)
    library(shinydashboard)
    library(readxl)
    library(plotly)
    library(quantmod)
    library(tidyquant)
    library(dplyr)
   
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
                   fluidRow(
                       
                              box(title = 'Select Date Range',width = 2,height =400,solidHeader = TRUE, status ='success',dateInput('sdateBox', h3('Begin Date'), min = '2015-01-01', max = Sys.Date()-1, value = '2017-01-01'),
                                   dateInput('edateBox', h3('End Date'),  min = '2015-01-01', max = Sys.Date()-1,value = Sys.Date()-1)),
                              
                           box(width =8,plotOutput('SingleCompanyStockChart'), title = "Close Stock Prices",solidHeader = TRUE, status = 'primary'),
                           box(width =2, height = 400, solidHeader = TRUE, status = 'success', title = 'Select Company', selectInput("p1SelectCompany",label = "", choices = list("UIS","ACN","IBM","LDOS")))
                           ),#closeFirstFluidRow
              # fluidRow(textOutput(outputId = 'testText')),
                                       
             
                    fluidRow(box(width = 10,plotOutput('multiCompanyStockChart')),
                             box(width =2, height = 400, solidHeader = TRUE, status = 'success', title = 'Select Company', checkboxGroupInput("p1SelectMultCompany",label = "",selected = c("UIS","ACN"), choices = list("UIS","ACN","IBM","LDOS")))
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
                                       
                                       #div(style = "height:50px;width:100%;background-color: #999999;border-style: solid;border-color: #000000"),
                                       
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
    
    ################SERVER CODE###############################################################################################
   
    
    
     server <- function(input,output) {
         
        
     
   
         
         newInput <- reactive(
             
             {
               
               getSymbols(input$p1SelectCompany, srce ='google',auto.assign = FALSE,
                                   from = input$sdateBox,
                                   to = input$edateBox)
                    
                 }
                )
        
      
         multiInput <- reactive(
             
             {
                
                 perm.vector <- as.vector(input$p1SelectMultCompany)
                perm.vector
            
                if (length(input$p1SelectMultCompany)==1) {
                tidyquant::tq_get(perm.vector, get='stock.prices', from = input$sdateBox, to = input$edateBox)  %>% mutate(Pct_Growth =adjusted/first(adjusted)-1)
                }else {
                    tidyquant::tq_get(perm.vector, get='stock.prices', from = input$sdateBox, to = input$edateBox)  %>% group_by(symbol) %>% mutate(Pct_Growth =adjusted/first(adjusted)-1)
                }
               #tidyStocks <- tidyStocks %>% group_by(symbol) %>% mutate(Pct_Growth =adjusted/first(adjusted)-1)
                   
                   
                }
         )
        
         loadMultiData <- reactive (
             tidyquant::tq_get(multiInput(), get='stock.prices', from = input$sdateBox, to = input$edateBox)
             
         
            
         )
         
        
         
         output$multiCompanyStockChart<- renderPlot (
             if (length(input$p1SelectMultCompany)==0) {
                 showModal(modalDialog(
                     title = "","Please Select at Least 1 Company",
                     fade = TRUE, easyClose = TRUE, size = 's'))
             }
             
             else if (length(input$p1SelectMultCompany)==1) {
                 multiInput()  %>% ggplot(aes(x = date, y = Pct_Growth)) + geom_line(col = 'blue')
             } else {
              multiInput()  %>% ggplot(aes(x = date, y = Pct_Growth, color = symbol)) + geom_line()
             }
             
              )
         
          output$SingleCompanyStockChart <- renderPlot(
         
    
              chartSeries(newInput(),type = 'candlesticks',show.grid = FALSE,major.ticks = FALSE, minor.ticks = FALSE,name = paste(input$p1SelectCompany,"Candlestick Chart"),up.col = "green", dn.col = "red", theme = "white", TA = 'addSMA(n =50); addVo()')
             # candleChart(newInput(),up.col = "green", dn.col = "red", theme = "white", TA = 'addSMA(n=50); addSMA(n=100)')
          
           
        )#closeRenderPlot
          
        
        
    }
    
    shinyApp(ui = ui,server = server)