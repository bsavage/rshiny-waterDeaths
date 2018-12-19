#
# Shiny app that reads 2017 water-borne deaths by country
# and allows user to select country and age range
# Plots bar chart and shows data associated with plot.
# (B. Savage)
#

library(shiny)
library(RCurl)
library(ggplot2)

url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vTaeUxOEdnPozmASycL-5Jhv7GZ2mGLXdBYzjz9T-AsgYVgTGYA2LCQm-JoQA76HzPohusxGn_9t26x/pub?output=csv"
csv <- getURL(url,.opts=list(ssl.verifypeer=FALSE))
df <-  read.csv(textConnection(csv), header=TRUE)

# Get unique countries
countries <- unique(df$location)
sex <- unique(df$sex)
age <- unique(df$age)

# Define UI for application
ui <- fluidPage(
  
  # Setup title and two user input menus
  titlePanel("Water-borne deaths by country and age (2017)"),
  fluidRow(
    column(4,
           selectInput("country","Country :", 
                       choices = countries )),
    column(4,
           selectInput("age","Age category :", 
                       choices = age )),
    br(),

    # Define are for plot and table
    mainPanel(" ",
              plotOutput(outputId = "barPlot"),
              br(),
              br(),
              dataTableOutput('table')
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #Reactive data frame that will dynamically change based on what is  chosen
  user_data <- reactive({    
    
    #subset data frame by user selections and including only relevant columns
    subdata = subset(df, location==input$country & age==input$age
                     & (sex=="Male" | sex=="Female")
                     & (cause!="All causes"))
    
  })
  
  output$barPlot <- renderPlot({
    # Check amount of user data (send to console)
    print(nrow(user_data()))
  
      ggplot(data=user_data(), aes(sex,y=deaths, fill=cause) )+
      geom_bar(stat="identity")+xlab("Gender") + ylab("Deaths") +labs(fill = "Cause")

    })
  output$table <- renderDataTable(user_data())
                                  
}

# Run the application 
shinyApp(ui = ui, server = server)

