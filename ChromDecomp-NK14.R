# this script extracts the features for the bands in chromosomes in a sub directory,
# saves them to a data table in a file, identifies each band by a label,
# and output says decomposition of a chrosmosome as a sequence of biomarker labels.

# Load required libraries
# Advanced image processing package Magick
library(magick)
library("scatterplot3d")
# this library is used to train a perceptron
library(nnet)
library(neuralnet)
library(jpeg)
library(ggplot2)
library(extrafont)
library("tools")
library(imager)
library("jpeg")
library("tiff")
library(Dict)
library(hash)

# returns a list of individual bands in jpeg format from the labels in clusteredImg (by kMeans)
getBands <- function(file,nameofBand, thresh, size, count) {
  tryCatch({
    im <- load.image(file) %>% grayscale()  
    # Create a list to store individual bands
    bandList <- list()
    # Thresholding yields different discrete regions of high intensity
    # print(max(im))
    # print(min(im))
    myPixs <- im > 0.67
    imOrig <- im
    im[myPixs] <- 1
    regions <- im < min(im) + thresh
    regions <-1- regions
    
    print(regions)
    # label each region with unique value
    labels <- label(regions,high_connectivity = 4)
    print(labels)
    par(mfrow = c(2, 2))
    # plot the region and lable against image dimensions
    plot(imOrig, main = "Original")
    # plot(im)
    plot(regions, main = "Regions")
    plot(labels, main = "Labels")
    # Extract labeled regions as separate pictures
    for (i in 1:max(labels)) {
      region <- (labels == i)
      extracted_region <- as.cimg(as.array(im) * as.array(region))
      # filter by size and number of non black pixels
      if(sum(extracted_region) > size)
      {
        filename <- paste(nameofBand, count, ".jpeg",sep ="" )
        # save region into a file 
        save.image(extracted_region,file = filename)
        # Add the JPEG file to the band list
        bandList[[count]] <- filename
        count <- count+1
      }
      im[region] <- 1
    } # end of for loop
    plot(im, main = paste("bands < ", thresh, " removed"))
    
    # save the image for next round
    file2 <- file_path_sans_ext(file)
    file2 <- paste(file2,"-", floor(10*thresh), ".jpeg",sep ="")
    save.image(im,file = file2)
    
    # Return the list of individual bands
    return(bandList)
  }, error = function(err) {
    print("An error occurred while getting the bands:")
    print(err)
    return(NULL)
  })
} # end getBands

# returns the shape of img in a dataframe consisting of pairs of coordinates of  
# selected pixels on the border of the image at quartile distances from its  centroid
getFeats <- function(img0){
  
  tryCatch({
    # convert image to rgb and copy image
    imgGray <- image_convert(img0, format = "rgb")
    # copy of image gray to recolor it after clustering
    imgC<-imgGray
    # # copy of image gray to recolor it after clustering
    imgI <-  image_data(imgGray)
    # get image dimensions 
    imginfo<-image_info(imgGray)
    w <- image_info(imgGray)$width
    h <- image_info(imgGray)$height
    
    # calculate and draw the centroid of nonwhite pixels. Create xCoordinate and yCoordinate variables as a list
    xCoords <- list()
    yCoords <- list()
    # extract nonwhite pixels from an image
    for(i in 1:w){
      for(j in 1:h){
        if(imgI[1,i,j] != "ff")
        {
          xCoords <- c(xCoords, i)
          yCoords <- c(yCoords, h-j)
        }
      }
    }
    par(mfrow = c(2, 2))
    plot(cbind(xCoords,yCoords))
    # Find convex shape and coordinates
    getconvex <- function (xCoord,yCoord){
      pts <- chull(xCoord,yCoord); # df
      mpts <- cbind(xCoord[pts], yCoord[pts])
      # str(dfhull)
      plot(mpts)
      # c.hull
      chull0 <- chull(mpts)
      chull <- mpts[c(chull0, chull0[1]),]
      plot(mpts, pch=19)
      chull
    }
    # Draw convex haul 
    conv <- getconvex(xCoords,yCoords)
    # Separate coordinates from convex haul
    conXCoord <- as.numeric(conv[,1])
    conYCoord <- as.numeric(conv[,2])
    # Lenght of convex haul coordinates
    lenX <- length(conXCoord)
    
    # get the centroid  
    plot( as.raster(imgGray))
    centroidX <- ceiling(mean(as.numeric(conXCoord)))        
    centroidY <- ceiling(mean(as.numeric(conYCoord)))
    centroid <- c(centroidX, centroidY)
    plot(as.raster(imgGray))
    points(centroidX, centroidY, col="blue", pch=20, cex=2)
    
    # calculate Euclidean distance from the centroid 
    distFromC <-array(0,dim = c(w,h))
    for( i in 1:lenX){
      x <- as.numeric(conXCoord[i])
      y <- as.numeric(conYCoord[i])
      distFromC[x,y] <- ceiling(sqrt((conXCoord[i]-centroidX)^2 + (conYCoord[i]-centroidY)^2))
    }
    # Store non zero distances in dist variable 
    dists <- c()
    for(i in 1:w)
    {
      for( j in 1:h){
        if( distFromC[i,j] != 0 )
        {
          dists <- c(dists, distFromC[i,j])
        }
      }
    }
    
    # calculate qurtiles 
    # qs <- ceiling(quantile(unlist(dists),type = 1))
    qs <- ceiling(quantile(unlist(dists), probs = c(0, 0.1, 0.2, 0.3, 0.4, 0.5,0.6, 0.7, 0.8, 0.9, 1), type = 1))
    plot(as.raster(imgGray))
    points(centroidX, centroidY, col="blue", pch=20, cex=2)
    # plot nonwhite pixel at max (last quartile) distance  
    print(qs)
    # create data frame for each band
    # df <- data.frame(bandName,colorOFBand,label,qs[1],qs[2],qs[3],qs[4],qs[5])
    qs <- ceiling(quantile(unlist(dists), probs = c(0, 0.1, 0.2, 0.3, 0.4, 0.5,0.6, 0.7, 0.8, 0.9, 1), type = 1))
    print(df)
    return(df)
    
  }, error = function(err) {
    print("An error occurred while extracting the features:")
    print(err)
    return(NULL)
  })
} # end getFeats

# returns a label for an input list of feature vectors of identifying a band using a neural network 
getBandLabel <- function(pred){
  # set up a dictionary return column K for value defined in colum J
  chromData <- read.csv("BandLabel-NK.csv",header = TRUE)
  labels <- chromData$NN.Label
  bandNames <- chromData$out.Label
  # return a key, value pair
  d <- hash(labels,bandNames)
  nlabels <- length(chromData$NN.Label)
  originallabel <- c()          
  # create a list of bandNames 
  # Calculate the absolute differences between each number and the target
  absolute_diff <- abs(labels - pred)
  # Find the index of the nearest number using which.min
  nearest_index <- which.min(absolute_diff)
  # Retrieve the nearest number from the list
  nearest_number <- labels[nearest_index]
  print(nearest_number)
  bName <- d[[as.character(nearest_number)]]
  
  return(bName)
} # end getBandLabel

# count number of similar bands
countSimilarSubstrings <- function(main_string, substring) {
  # Use gregexpr to find all occurrences of the substring in the main string
  matches <- gregexpr(substring, main_string, ignore.case = TRUE)
  # Extract the matched substrings from the main string
  matched_substrings <- regmatches(main_string, matches)
  # Count the total number of matches found
  num_matches <- sum(sapply(matched_substrings, length))
  return(num_matches)
}

# returns the number of occurrences of target in a list of numbers
countOccurrences <- function(numbers, target) {
  # Use table to create a frequency table of the elements
  occurrences <- table(numbers)
  # Extract the count of the target number
  count_target <- occurrences[as.character(target)]
  return(count_target)
}

# returns a string of biomarker labels from a list of bandLabels  
getBiomLabels <- function(bandLabs,fileName){
  # get the full list of all labels and hash them with their names
  file <- "BandLabel-NK.csv"
  chromData <- read.csv(file,header = TRUE)
  bandlabels <- chromData$NN.Label
  bandNames <- chromData$out.Label
  nBands <- length(bandLabs)
  # dicts <- hash(bandlabels,bandNames)
  
  # group the band labels into biomarker labels
  biomLabels <- c()
  count <- c()
  i <- 1
  while( i <= nBands){
    
    bname <-  bandLabs[i]
    loc <- match(bname,bandNames)
    if(bname == "generic"){
      biomLabels <- c(biomLabels,"X")
      i <- i+1
    }else{
      # bname <- "nsp-s-END-1"
      b <- substr(bname, nchar(bname)-1, nchar(bname)-1)
      if(b != "-"){
        biomarker <- substr(bname, 0, nchar(bname)-2)
        biomLabels <- c(biomLabels, biomarker)
        i <- i+1
      }
      else {
        # name of biomarker 
        biomarker <- substr(bname, 0, nchar(bname)-2)
        # bLabel <- substr(bname, nchar(bname), nchar(bname)-2)
        count <-  countSimilarSubstrings(bandNames ,biomarker)
        blistcount <- countSimilarSubstrings(bandLabs ,biomarker)
        
        # compare predicted labels with original labels
        if ( blistcount >= count)
        {
          biomLabels <- c(biomLabels,biomarker )
        }
        # iteration
        i <- i + blistcount
      }
    }
  } # end of while
  
  return(biomLabels)
} # end getBiomLabel

library("stringr")
# returns accuracy of decomposition
getAcc <- function(bandLabels,fileName) {
  
  # read band stats data from file and create dictionary 
  chromBands <- read.csv("bandStats-NK2.csv")
  nameBands <- hash(chromBands$Name,chromBands$total)
  nPredBands <- length(bandLabels)
  
  # number of total bands in a chromosome
  totalBands <- nameBands[[fileName]]
  acc <- 0.0
  if( ! is.null(totalBands)){
    acc <- (1- (abs(totalBands-nPredBands) / totalBands) )*100
  }
  return( acc)
}


# main function to start the program 
# set required directory to run the program and save images generated automatically.
setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Deliverables/")

# read a *.tif image and convert it  to jpeg   
files <- list.files(path="./", pattern=".tif", all.files=TRUE, full.names=FALSE)
filetiff <- paste(files, sep = "")
# identify the name
nametiffBand <- file_path_sans_ext(filetiff)
# read the image of  band convert into jpeg and save it 
img0<-  readTIFF(filetiff, native=TRUE)
img <- paste(nametiffBand,".jpeg",sep = "")
writeJPEG(img0, target = img, quality = 1)
imgOrig <- img

# get a list of bands in the raw image (name of images)
allBands <- list()

# intialize variables 
thresh <- 0.26
eps <- 0.3
size <- 700
count <- 1

while (thresh < 1){
  out <- getBands(img,nametiffBand, thresh, size, count) 
  allBands <- c(allBands, out)
  count <- count + length(allBands)
  
  file <- file_path_sans_ext(img)
  img <- paste(file, "-",floor(10*thresh), ".jpeg",sep = "")
  print(img)
  thresh <- thresh + eps
} # end while

indBands <- allBands
# read the neural net band classifier 
nn <- readRDS(file="trained_nn.Rda")

# identify each band in the list by a band label
bandLabels <-list()
# read individual bands 
for(i in 1:length(indBands))
{
  tryCatch({
    # read the image of the band i and get its feature vector
    fileName <- paste(indBands[i], sep = "")
    img0 <- image_read(fileName)
    
    # resize image and extract the border
    img0 <- image_scale(img0,geometry = 300)
    # charcoal of an image
    img0 <- image_charcoal(img0)
    # feats <- getFeats(img0,nameofBand,colorOFBand,label)
    feats <- getFeats(img0)
    str(feats)
    print(pred)
    
    # convert the pred to a bandLabel and add it to bandLabels
    bLabel <- getBandLabel(pred)
    # print(bLabel)
    bandLabels <- c(bandLabels,bLabel)
    # print(bandLabels)
    
  }, error = function(err) {
    print("An error occurred while generating dilations:")
    print(err)
    return(NULL)
  })
}  # end of inner for loop

# print bandlabels
print(paste(bandLabels,sep = " "))
# identify each band in the list by a band label and group them and identify bimarkers
BiomDecomp <- getBiomLabels(bandLabels,nametiffBand)

# print(paste(file, ": ", "The chromosome decomposition is "))
print(paste(BiomDecomp,sep = " "))

# write the biomarker labels into a text and save as output
fileConn<-file("output.txt")
writeLines(c((BiomDecomp)), fileConn)
close(fileConn)

# accuracy of number of bands in a chromosome
acc <- getAcc(bandLabels,nametiffBand)
print(paste(floor(acc),"% Band+Biomarker accuracy",sep = ""))


