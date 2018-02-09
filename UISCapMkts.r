library(shiny)
library(shinydashboard)
library(readxl)
library(plotly)

dbHeader <- dashboardHeader(title = "Unisys Capital Mkts Dashboard", titleWidth = 450)

dbSidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Stock Prices",tabName = 'db1', icon = icon("dashboard")),
         menuItem("The Original 5", tabName = 'db2', icon = icon("bar-chart"))
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
                   
                          box(title = 'Select Date Range',width = 2,height =400,solidHeader = TRUE, status ='success',dateInput('sdate', h3('Begin Date'), min = '2016-08-12', max = '2017-08-11', value = '2017-08-11'),
                               dateInput('date', h3('End Date'),  min = '2016-08-12', max = '2017-08-11',value = '2017-08-11')),
                          
                       box(width =10,plotOutput('LeagueOverview'), title = "Close Stock Prices",solidHeader = TRUE, status = 'primary')),
                                   
         
                fluidRow(box(width = 12,plotOutput('Top3Finishes')))
                
                
              #  )#closeFluidPage
                
                #FirstTabClose
               ),
        #SecondTab Open
        tabItem(tabName = 'db2',h2("The Original 5"),
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
    
    
    
}

shinyApp(ui = ui,server = server)