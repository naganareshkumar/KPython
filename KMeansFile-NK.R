#
setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Deliverables/New&oldDATA/ind/")

# Load required libraries
# Advanced image processing package Magick
library(magick)
library("scatterplot3d")
library(nnet)
# this library is used to train a perceptron
library(neuralnet)
library(jpeg)
library(ggplot2)
library(extrafont)

  # read the image 
  img <- readJPEG("S.nsp-chr2-shortarm-RB.jpeg")
  # structure of the image
  str(img)
  # get the dimensions of an image
  imgDm <- dim(img)
  
  # Assign RGB channels to data frame
  imgRGB <- data.frame(
    x = rep(1:imgDm[2], each = imgDm[1]),
    y = rep(imgDm[1]:1, imgDm[2]),
    R = as.vector(img[,,1]),
    G = as.vector(img[,,2]),
    B = as.vector(img[,,3])
  )
  
  # ggplot theme to plot image 
  plotTheme <- function() {
    theme(
      panel.background = element_rect(
        size = 3,
        colour = "pink",
        fill = "white"),
      axis.ticks = element_line(
        size = 2),
      panel.grid.major = element_line(
        colour = "blue",
        linetype = "dotted"),
      panel.grid.minor = element_line(
        colour = "red",
        linetype = "dashed"),
      axis.title.x = element_text(
        size = rel(1.2),
        face = "bold"),
      axis.title.y = element_text(
        size = rel(1.2),
        face = "bold"),
      plot.title = element_text(
        size = 20,
        face = "bold",
        vjust = 1.5)
    )
  }
  
  # plot image 
  ggplot(data = imgRGB, aes(x = x, y = y)) + 
    geom_point(colour = rgb(imgRGB[c("R", "G", "B")])) +
    labs(title = "C band  image") +
    xlab("x") +
    ylab("y") + 
    plotTheme()
  
  # number of clusters
  kClusters <- 4
  
  # KMeans algorithm and assign colors to each cluster and plot the clusters
  kMeans <- kmeans(imgRGB[, c("R", "G", "B")], centers = kClusters)
  kColours <- rgb(kMeans$centers[kMeans$cluster,])
  
  gg <- ggplot(data = imgRGB, aes(x = x, y = y)) + 
    geom_point(colour = kColours) +
    labs(title = paste("k-Means Clustering of", kClusters, "Colours")) +
    xlab("x") +
    ylab("y") + 
    plotTheme()
  
  gg
  
  # Save Last plot 
  # ggsave(file="s-arm-cluster.jpeg")
  
  # get bands from clusters
  imgRGB$Cluster <- as.factor(kMeans$cluster)
  imgRGB$ClusterColor <- kColours[kMeans$cluster]
  
  # Get unique cluster labels
  uniqueLabels <- unique(imgRGB$Cluster)
  # Sort labels in ascending order
  sortedLabels <- sort(uniqueLabels)
  
  # Create a list to store individual bands
  bandList <- list()
  h <- imgDm[1]
  w <- imgDm[2]
  
  # Loop through each cluster label
  for (label in sortedLabels) {
    # Create a blank image with the same dimensions as the clustered image
    bandImg <- array(img[0,0,], dim = c(h, w, 3))
    
    for (i in 1:w) {
      for (j in 1:h) {
        # Extract RGB values of the pixel
        pixel <- img[j, i, ]
        
        # Set pixels corresponding to the current label to the pixel values, others remain white
        if (imgRGB$Cluster[(i-1) * h + j] == label) {
          bandImg[j, i,] <- pixel
        }
      }
    }
    
    # Save the image as a JPEG file
    filename <- paste("band_", label, ".jpeg", sep = "")
    writeJPEG(bandImg, target = filename)
    
    # Add the JPEG file to the band list
    bandList[[label]] <- filename
  }
  
  