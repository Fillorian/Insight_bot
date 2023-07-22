# set up shiny
library(shiny)
library(readxl)
library(ggplot2)
library(dplyr)

install.packages("forcats")
library(forcats)

# begin shiny
library(shiny)

ui <- fluidPage(
  # app title
  titlePanel("Proof of concept piece"),
  
  # I want to split to a filter (TL) and figure (TR), with table underneath
  verticalLayout(
    sidebarLayout(
      
      # a sidebar panel for filters and the plot output
      sidebarPanel(
        # have a list for product types and metrics
        selectInput("type", "TYPE:", choices = c(
          "RTW" = "Rtw",
          "Bags" = "Bags",
          "Shoes" = "Shoes"
        ),
        multiple = FALSE,
        width = '200px'),
        selectInput("metric", "METRIC:", choices = c(
          "Net SALES" = "NET_SALES",
          "Margin" = "MARGIN"
        ), width = '200px'),
        textInput("top_x", "Top x:",
                    value = 3,
                    width = "200px"),
        width = 2
        #varSelectInput("vars", "VARIABLES", 
        #  data = read_xlsx("Daily Sales/test.xlsx"),
        #  multiple = T)
      ),
      
      # main panel for output figure
      mainPanel(
        # histogram output
        plotOutput(outputId = "plot")
      )
    ),
    # beneath the sidebar a table output
    tableOutput(outputId = "table"),
    textOutput(outputId = "report")
  )
)

server <- function(input, output, session) {
  
  #reactive({
   # data <- read_xlsx("Daily Sales/test.xlsx") %>%
    #  filter(TYPE == input$type) %>%
     # arrange(desc(input$metric)) %>%
     # select(TITLE, BRAND, `NET SALES`, MARGIN) %>%
    #  slice(1:5)
 # })
  
  # filter top 5 rows/metric values
  
  output$table <- renderTable({
    read_xlsx("Daily Sales/test.xlsx") %>%
      filter(TYPE == input$type) %>%
      select(TITLE, BRAND, `NET SALES`, MARGIN) %>%
      rename(NET_SALES = `NET SALES`) %>%
      arrange(desc(across(input$metric))) %>%
      slice(1:input$top_x)
    })
  
  output$plot <- renderPlot({
    ggplot(
      data = read_xlsx("Daily Sales/test.xlsx") %>%
        filter(TYPE == input$type) %>%
        select(TITLE, BRAND, `NET SALES`, MARGIN) %>%
        rename(NET_SALES = `NET SALES`) %>%
        arrange(desc(across(input$metric))) %>%
        mutate(TITLE = factor(TITLE, levels = unique(TITLE))) %>%
        slice(1:input$top_x),
      aes_string(x = "TITLE", y = input$metric, fill = "BRAND") +
        geom_col() +
        scale_size_continuous(guide = "none") 
    )
  })
  
  output$report <- renderText({
    paste0(input$type, " category Titles with the top ", input$metric, " are:")
  })
}

shinyApp(ui, server)