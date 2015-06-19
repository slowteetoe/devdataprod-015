library(shiny)
shinyUI(fluidPage(
  titlePanel("Wage Prediction based on Demographic Data"),
  inputPanel(
    selectInput("workclass", label = "Work Classification",
                choices=sort(unique(as.character(adult$workclass))), selected = "Private"),
    sliderInput("age", label="Age", min=16, max=120, step=1, value=39),
    selectInput("education", label="Education Level:", choices=sort(unique(as.character(adult$education))), selected="Bachelors"),
    selectInput("marital.status", label="Marital Status:", choices=sort(unique(as.character(adult$marital.status))), selected=""),
    selectInput("occupation", label="Occupation:", choices=sort(unique(as.character(adult$occupation))), selected = "Exec-managerial"),
    selectInput("race", label="Ethnicity:", choices=sort(unique(as.character(adult$race))), selected="White"),
    radioButtons("sex", label="Sex:", choices=sort(unique(as.character(adult$sex)))),
    sliderInput("capitalGainLoss", label="Capital Gain/Loss:", min=-10000, max=10000, step=100, value=0),
    sliderInput("hours.wk", label="# Hours Worked per Week:", min=1, max=100, step=1, value=45),
    selectInput("native.country", label="Native country", choices=sort(unique(as.character(adult$native.country))), selected="United-States")
  ),
  tags$p("Wage prediction:"),
  verbatimTextOutput("wageprediction")
))