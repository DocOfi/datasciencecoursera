#server.R
library(shiny)
source("helpers.R")
shinyServer(
  function(input, output) {
    mydf <- readRDS("./data/final5gdf.rds")
    output$text1 <- renderText({input$text1})
    output$text2 <- renderText({
      input$goButton
      isolate(findnxtw(input$text1))
    })
     
  }
)