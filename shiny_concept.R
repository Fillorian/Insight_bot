# set up shiny
library(shiny)
library(readxl)
library(ggplot2)
library(dplyr)

# begin shiny
library(shiny)

ui <- fluidPage(
  # app title
  titlePanel("Proof of concept piece"),
  
  # I want to split to a dataset (L) and figure (R)
  sidebarLayout(
    
    # a sidebar panel for dataset
    sidebarPanel(
      # have a slider for top X brands
      tableOutput(outputId = "topx_table")
    ),
    
    # main panel for output figure
    mainPanel(
      # histogram output
      plotOutput(outputId = "topx_plots")
    )
  )
)

server <- function(input, output, session) {
  
  # import the data
  data <- read_xlsx("Daily Sales/test.xlsx")
  # sort it by net sales and select key variables
  data_o <- data %>% 
    arrange(desc(`NET SALES`)) %>%
    select(SKU, BRAND, `NET SALES`, MARGIN)
  # filter top 3 rows = top 3 net sales
  data_f <- data_o[2:4,]
  
  output$topx_table <- renderTable(data_f)
  
  output$topx_plots <- renderPlot({
    ggplot(data = data_f, aes(x = BRAND, y = `NET SALES`, size = 2)) +
      geom_point()
  })
}

shinyApp(ui, server)