library(caret)
library(randomForest)
library(data.table)
library(inTrees)
library(shiny)

# we don't want to train the randomforest unless we need to
if( !file.exists("rfmodel.Rdata")){
  inTrain <- createDataPartition(y=adult$wages, p=0.70, list = FALSE)
  training <- adult[inTrain,]
  testing <- adult[-inTrain,]

  bestmtry <- tuneRF(training[-12], training$wages, ntreeTry=150, trace=TRUE, plot=TRUE, dobest=FALSE, sampsize = c(500,1000))
  mtry.use <- bestmtry[ bestmtry[3,] == min(bestmtry[3,]),][[1]]

  # since our data is relatively unbalanced, attempt to undersample the majority class ('<=50k') 
  # this increases specificity, but decreases sensitivity
  rf.model <-randomForest(wages~., data=training, mtry=mtry.use, ntree=1500, importance=TRUE, keep.forest = TRUE, sampsize = c(500,1000))
  
  # save our random forest since the computation is slooooow...
  save(rf.model, file="rfmodel.Rdata")
  
  preds <- predict(rf.model, newdata=testing)
  accuracy <- sum(testing$wages == preds)/nrow(testing)
  confusionMatrix(preds, testing$wages)
}

load(file="rfmodel.Rdata")

# Create two helper functions since I wanted to allow the user to select capital gains using a slider,
# but it was two separate fields in the source dataset
capGain <- function(x){
  i <- as.numeric(x)
  if(i > 0){
    return(i)
  } else {
    return(0)
  }
}

capLoss <- function(x){
  i <- as.numeric(x)
  if(i < 0){
    return(-1 * i)
  } else {
    return(0)
  }
}

shinyServer(function(input, output) {
    output$wageprediction <- renderPrint({
        df <- adult[1,]          # this is a hack to get the factor levels correct, otherwise the randomforest refuses to predict
        df[1,"age"] <- as.numeric(input$age)
        df[1,"workclass"] <- as.factor(input$workclass)
        df[1,"education"] <- as.factor(input$education)
        df[1,"marital.status"] <- as.factor(input$marital.status)
        df[1,"occupation"] <- as.factor(input$occupation)
        df[1,"race"] <- as.factor(input$race)
        df[1,"sex"] <- as.factor(input$sex)
        df[1,"capital.gain"] <- as.numeric(capGain(input$capitalGainLoss))
        df[1, "capital.loss"] <- as.numeric(capLoss(input$capitalGainLoss))
        df[1, "hours.wk"] <- as.numeric(input$hours.wk)
        df[1, "native.country"] <- as.factor(input$native.country)
        pred <- predict(rf.model, newdata=df)
        as.character(pred)
      })
  }
)
