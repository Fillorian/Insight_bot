# set up shiny
install.packages("readxl")
library(shiny)
library(readxl)

data <- read_xlsx("Daily Sales/test.xlsx")

# begin shiny
library(shiny)

ui <- fluidPage(
  # app title
  titlePanel("Prrof of concept piece")
  
  # I want to split to a slider (L) and figure (R)
  sidebarLayout(
    
    # a sidebar panel for input
    sidebarPanel(
      # have a slider for top X brands
      sliderInput(inputId = "topx",
                  label = "Top X Brands with Net Sales",
                  min = 1,
                  max = 10,
                  value = 3)
      
    )
    
    # main panel for output figure
    mainPanel(
      # histogram output
      plotOutput(outputId = "topx_plots")
    )
  )
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)