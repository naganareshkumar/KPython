# this script reads a csv file with feature of the bands in a training set,
# for a neural network classifier to identify the band and its label,
# for a decomposition of a chromosome. 
# Created by Naresh Konatham and MG in July 2023
# library are used to train a perceptron
library(nnet)
library(neuralnet)

# returns a list containing  neural network labels in the predictions
roundResults <- function(predictions){
  
  # read in the chromosome data
  chromData <- read.csv("BandLabel-NK.csv",header = TRUE)
  labels <- chromData$NN.Label
  nlabels <- length(labels)
  
  # rounds a prediction to the nearest labels and store them
  roundedPreds <- list()
  for(i in 1:length(predictions)){
    # calculate the absolute differences from all the labels
    absDiff <- abs(labels - predictions[i])
    # find the nearest label
    nearestInd <- which.min(absDiff)
    # retrieve the nearest number from the list
    nearLabel <- labels[nearestInd]
    roundedPreds <- c(roundedPreds, nearLabel)
  }
  roundedPreds <- unlist(roundedPreds)
  return(roundedPreds)
} # end roundResults

# Main
setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Deliverables/New&oldDATA/")
# setwd("C:/D;/R/Chroms")
# extract data from csv file to data frame
chromData <- read.csv("datasetNew-Dec1.csv",header = FALSE)
size <- nrow(chromData)

# select pct indices for records of the training set
pct <- 0.75
trainDataInds <- sample(1:size, floor(pct * nrow(chromData)) , replace = FALSE)

# pulls the corresponding full data points 
trainData <- chromData[trainDataInds, ]
nrow(trainData)

# selects the test dataset as the complementary points of the training set
testData <- chromData[-trainDataInds, ]
nrow(testData)

# train neuralnetwork with 0 hidden layers for better results
nn <- neuralnet(V3 ~ V4 + V5 +V6 + V7 + V8 + V9 +  V10 + V11 +V12+ V13+ V14, trainData,hidden = 5,linear.output = FALSE)

# save nn into a file
# plot(nn)
saveRDS( nn, file = "trained_nn.Rda")
# plot(nn2)

# labels for predictions for the testing set 
nnoutputs <- compute(nn, testData)$net.result
nnoutputs

# collapse analog output to a category 
roundedPreds <- roundResults(nnoutputs)
print(roundedPreds)

# Now assess the model by comparing predictions with the true value (accuracy)
accuracy <- 0
correctPredictions <- sum(roundedPreds == testData[, 3])
accuracy <- floor(correctPredictions / nrow(testData) * 100)
print(paste("The accuracy on the validation set is:", accuracy, "%", sep = " "))

