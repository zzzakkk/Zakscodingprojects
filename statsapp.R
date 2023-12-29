# This is the beginning of Zak's greatest app that shows a stocks price trend. 

library(shiny)
library(shinyWidgets)
library(shinythemes)
library(plotly)
library(tidyverse)
library(tidyquant)
library(lubridate)


ui <- fluidPage( tags$head(
  tags$style(HTML("
            body {background-color: pink; }"))
  ),
  titlePanel("Zak's Stock Portfolio"),
  
  HTML("<p>Welcome to Zak's Stock Portfolio app! Enter stock symbols (comma-separated) and select a time period to visualize the stock price trends.</p>"),
  
  # what sidebar does here it organizes and displays units. This allows me to then put buttons that can be used when the app is run.
  sidebarLayout(
    sidebarPanel(width = 3,
                 # type in your stock symbol 
                 textInput("stock_symbol", "Enter stock symbols (comma-separated):", ""),
                 # button to get different periods in time of the stock
                 radioButtons("period", label = h4("Period"),
                              choices = list("1 month" = 1, "3 months" = 2, "6 months" = 3, "12 months" = 4, "YTD" = 5), 
                              selected = 4)),
    
    # Plot the results from above
    mainPanel(
      plotlyOutput("plot", height = 800))))

#what server does is it works with the UI hand in hand and is important for the whole function of this app. Basically it gives instructions what happens

server <- function(input, output, session) {
  stock_prices <- reactive({
    input$stock_symbol  # This line makes stock prices reactive to changes in the stock symbol input
    input$period        # This line makes stock prices reactive to changes in the period input
    
    # Process the input stock symbols to correctly identify the stock
    tickers <- strsplit(input$stock_symbol, ",\\s*")[[1]]
    
    # Check if you typed something or not
    if (nchar(input$stock_symbol) > 0) {
      # Determine the 'from' date based on the selected period
      from_date <- switch(as.character(input$period),
                          "1" = today() - months(1),
                          "2" = today() - months(3),
                          "3" = today() - months(6),
                          "4" = today() - months(12),
                          "5" = make_date(year = lubridate::year(today()), month = 1, day = 1) )
      
      # Get the specific stock prices that has been typed 
      tq_get(tickers, 
             get  = "stock.prices",
             from = from_date,
             to   = today(),
             complete_cases = FALSE) %>%
        select(symbol, date, close)
    } else {
      NULL }})
  
  # Create plot
  output$plot <- renderPlotly({
    prices <- stock_prices()
    if (!is.null(prices)) {
      ggplotly(
        prices %>%
          ggplot(aes(date, close, color = symbol)) +
          geom_line(size = 1, alpha = .9) +
          theme_minimal(base_size = 16) +
          theme(
            axis.title = element_blank(),
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            panel.grid = element_blank(),
            legend.text = element_text(colour = "white") ))
    } else {
      ggplot() +
        ggtitle("Please enter stock symbols to view data")
    }
  })
}

# Run it
shinyApp(ui = ui, server = server)


