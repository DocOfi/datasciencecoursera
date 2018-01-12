#ui.R
shinyUI(pageWithSidebar(
  headerPanel("I know what you're going to say..."),
  sidebarPanel(
    helpText(h3("Are you tired of reading the same stories 
              in the news everyday? Do you think you can 
              predict tomorrow's HEADLINE in the paper?",
              style = "color:steelblue")),
    textInput(inputId="text1", label = "Enter phrase"),
    actionButton("goButton", "Next"),
    helpText(h3("Type a short phrase or sentence and leave
             the last word out. Click on Next to see if 
             the last word you had in mind is the same 
             word you'd find in the news"))
    ),
  mainPanel(
      h3('Results of prediction'),
      h3('You entered'),
      verbatimTextOutput("text1"),
      h3('Which resulted in a prediction of'),
      verbatimTextOutput("text2"),
      tabsetPanel(type = "tabs",
         tabPanel("Motivation", includeHTML("capmotiv.html")),
         tabPanel("Summary", includeHTML("finaltxt.html")),
         tabPanel("Word Cloud", includeHTML("fivgwdcld.html"))
      )
  )
  )
  )
