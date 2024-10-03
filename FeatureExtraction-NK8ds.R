# Load required libraries
# Advanced image processing package Magick
library(magick)
library("scatterplot3d")
# libraries to train neural network
library(nnet)
library(neuralnet)
# other libraries 
library(jpeg)
library(ggplot2)
library(extrafont)
library(imager)
library(tools)

# returns the shape of img in a dataframe consisting of pairs of coordinates of  
# selected pixels on the border of the image at quartile distances from its  centroid
getFeats <- function(img0, bandName,colorOFBand,label){
  
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
    
    # # calculate qurtiles 
    # qs <- ceiling(quantile(unlist(dists),type = 1))
    # calculate the deciles    
    qs <- ceiling(quantile(unlist(dists), probs = c(0, 0.1, 0.2, 0.3, 0.4, 0.5,0.6, 0.7, 0.8, 0.9, 1), type = 1))
    
    plot(as.raster(imgGray))
    points(centroidX, centroidY, col="blue", pch=20, cex=2)
    # plot nonwhite pixel at max (last quartile) distance  
    print(qs)
    
    # create data frame for each band
    df <- data.frame(bandName,colorOFBand,label,qs[1],qs[2],qs[3],qs[4],qs[5],qs[6],qs[7],qs[8],qs[9],qs[10],qs[11])
    # print(df)
    write.table(df , file="datasetNew-Dec-2.csv", append = T,sep = ",", row.names = FALSE, col.names = FALSE)
  }, error = function(err) {
    print("An error occurred while extracting features:")
    print(err)
    return(NULL)
  })
} # end getFeats

# saves some of rotations of an img  
getRotations <- function(img,name){
  
  tryCatch({
    img30 <- image_rotate(img, 30)
    name30 <- paste(name,"-30",".jpeg",sep = "")
    image_write(img30,name30,"jpeg")
    
    img45 <- image_rotate(img, 45)
    name45 <- paste(name,"-45",".jpeg",sep="")
    image_write(img45,name45,"jpeg")
    
    img60 <- image_rotate(img, 60)
    name60 <- paste(name,"-60",".jpeg",sep = "")
    image_write(img60,name60,"jpeg")
    
    names <- c(name30,name45,name60)
    names
    # return( c(name30,name45,name60))
  }, error = function(err) {
    print("An error occurred while generating rotations:")
    print(err)
    return(NULL)
  })
}

# saves some dilations and contractions of an img  
getDilations <- function(img,name){
  
  tryCatch({
    img200 <- image_morphology(img, method='Dilate') %>% image_scale('200%')
    name200 <- paste(name,"-200",".jpeg",sep = "")
    image_write(img200,name200,"jpeg")
    
    img50 <- image_morphology(img, method='Dilate') %>% image_scale('50%')
    name50 <- paste(name,"-50",".jpeg",sep = "")
    image_write(img50,name50,"jpeg")
    
    # return(c(name200,name50))
    names <- c(name200,name50)
    names
  }, error = function(err) {
    print("An error occurred while generating dilations:")
    print(err)
    return(NULL)
  })
}

# main function to start the program 
# read list of files from directory
setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Deliverables/IndiBand/")
indBands <- list.files(path="./", pattern=".jpeg", all.files=TRUE, full.names=FALSE)

# calculate label of band 
nrLabs <- length(indBands)
labWidth <- 1/nrLabs
feats <-list()
# read individual bands 
for(i in 1:length(indBands))
{
  tryCatch({
    fileName <- paste(indBands[i], sep = "")
    # identify the band 
    nameofBand <- file_path_sans_ext(fileName)
    colorOFBand <- substr(nameofBand, nchar(nameofBand), nchar(nameofBand))
    # read the image of  band
    img0 <- image_read(fileName)
    # resize image and extract the border
    img0 <- image_scale(img0, geometry = 300)
    # charcoal of an image
    img0 <- image_charcoal(img0)
    # get the features for the shape and save feature vector
    label <- labWidth*(i - 0.5)
    feats <- c(feats, getFeats(img0,nameofBand,colorOFBand,label))
    
    # get the rotations for the image and save feature vectors
  rots <- getRotations(img0,nameofBand)
     fileName <- paste(rots[j], sep = "")
      nameofBand1 <- file_path_sans_ext(fileName)
      img1 <- image_read(fileName)
      feats <- c(feats, getFeats(img1,nameofBand1,colorOFBand,label))
    }
    
    # get the dilations and contractioons for the image and save feature vectors
    dils <- getDilations(img0,nameofBand)
    for(k in 1:length(dils)){
      fileName <- paste(dils[k], sep = "")
      nameofBand2 <- file_path_sans_ext(fileName)
      img2 <- image_read(fileName)
      feats <- c(feats, getFeats(img2,nameofBand2,colorOFBand,label))
    }
  }, error = function(err) {
    print("An error occurred while generating dilations:")
    print(err)
    return(NULL)
  })
}
