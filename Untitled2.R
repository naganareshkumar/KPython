library(nnet)
library(neuralnet)
library(caret)

# Function to round neural network predictions to categories
roundResults <- function(predictions, nlabels) {
  roundedPreds <- (floor(nlabels * predictions) + 0.5) / nlabels
  return(roundedPreds)
}

setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Deliverables/")
chromData <- read.csv("Dataset-NK1.csv", header = FALSE)

# Set the target variable name (V3 in this case)
target_var <- "V3"

# Define the features and target variable for training the neural network
features <- setdiff(colnames(chromData), target_var)

# Use trainControl to define cross-validation settings (k-fold cross-validation with 5 folds)
ctrl <- trainControl(method = "cv", number = 5)

# Train the neural network using k-fold cross-validation
nn <- train(as.formula(paste(target_var, "~", paste(features, collapse = " + "))),
            data = chromData, method = "nnet",
            trControl = ctrl, linout = FALSE, hidden = 2)

# Save the best model from cross-validation
best_nn <- nn$finalModel

# Save the trained neural network into a file
saveRDS(best_nn, file = "trained_nn1.Rda")

# Print cross-validation results
print(nn)

# Use the best model to make predictions on the test set
testDataInds <- sample(1:30, floor(0.25 * nrow(chromData)), replace = TRUE)
testData <- chromData[testDataInds, ]
nninputs <- as.matrix(testData[, features])  # Convert test data to matrix for prediction
nnoutputs <- predict(best_nn, nninputs)

# Collapse analog output to categories
nlabels <- 144
roundedPreds <- roundResults(nnoutputs, nlabels)
print(roundedPreds)

# Create a dataframe adding true labels of each data point
predictedVsTrue <- data.frame(roundedPreds, testData[, target_var])

# Now assess the model by comparing predictions with the true value (accuracy)
accuracy <- sum(abs(predictedVsTrue[, 1] - testData[, target_var]) < 1 / (2 * nlabels)) / nrow(predictedVsTrue) * 100
print(paste("The accuracy of the model is:", accuracy, "%", sep = " "))
