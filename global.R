# we need the 'adult' dataset so that our shiny UI has values, if it only exists in server.R then it isn't visible
# when the UI is rendered the first time and errors out

if(!file.exists("adult.data")){
  download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", destfile="adult.data", method="curl")
}
adult <- read.csv("adult.data", header = FALSE, sep = ",", strip.white=TRUE,  na.strings=c("NA","NaN", "", "?"))
adult <- setNames(adult, c("age","workclass","fnlwgt","education","education.num","marital.status","occupation","relationship","race","sex","capital.gain", "capital.loss", "hours.wk", "native.country","wages"))

# we can't deal with NA predictors in the random forest, so we're going to omit them from our predictions
adult <- adult[complete.cases(adult),]

# we won't be able to come up with meaningful values for fnlwgt from our shiny app, so remove it
adult$fnlwgt <- NULL

# also, we'll use education factors over the numeric value
adult$education.num <- NULL

# relationship didn't make much sense and wasn't a useful predictor
adult$relationship <- NULL
