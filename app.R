#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RCurl)

url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vTaeUxOEdnPozmASycL-5Jhv7GZ2mGLXdBYzjz9T-AsgYVgTGYA2LCQm-JoQA76HzPohusxGn_9t26x/pub?output=csv"
csv <- getURL(url,.opts=list(ssl.verifypeer=FALSE))
df <-  read.csv(textConnection(csv), header=TRUE)

# Get unique countries
countries <- unique(df$location)
sex <- unique(df$sex)
age <- unique(df$age)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Read data sheet"),
   # Sidebar
   sidebarLayout(
      sidebarPanel(
          selectInput("country","Country :", 
                      choices = countries ),
        selectInput("sex","Gender :", 
                    choices = sex ),
        selectInput("age","Age category :", 
                    choices = age )
   ),

      mainPanel("main panel",
        plotOutput(outputId = "distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$distPlot <- renderPlot({

    selection <- subset(df, location==input$country & sex==input$sex & age==input$age)
    print("selection")
    print(selection)
    print("hello")
    print(selection$deaths)
    plot(selection$country, selection$deaths, type="b",
         xlim=range(dd$country), ylim=range(dd$deaths))
    # hist(selection$deaths, col = "#75AADB", border = "white",
    #      xlab = "deaths",
    #      main = "Histogram of water")
    
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

