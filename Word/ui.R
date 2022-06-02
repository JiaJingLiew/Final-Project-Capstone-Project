#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinyWidgets)
library(grDevices)
suppressWarnings(library(shiny))
suppressWarnings(library(markdown))


# Define UI for application that draws a histogram
shinyUI(navbarPage(

    # Application title
    titlePanel(h4("Word Prediction App")),
    setBackgroundImage(src = "https://wallpapercave.com/dwp1x/wp4778521.jpg"),
    # Sidebar with a slider input for number of bins
    tabPanel(h3("Word Predictor"),
      sidebarLayout(
        sidebarPanel(
          textInput("inputString", "Enter Word",value = ""),
          submitButton('NextWord'),
          br(),
          br(),
          br(),
          br()
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          h4("The Suggested Next Word"),
          verbatimTextOutput("prediction"),
          tags$style(type='text/css', '#text1 {background-color: rgba(255,255,0,0.40); color: blue;}'), 
          textOutput('text1')
        ))),
    tabPanel(h3("Overview"),
             mainPanel(includeMarkdown("Overview.md"))
    )
        )
    )

