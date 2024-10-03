# setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Data/fullChroms/S.goeldii/")

#load libraries
library(magick)
library(extrafont)
library(tools)

setwd("/Users/naganaresh/Desktop/Personal/MastersProject/Deliverables/New&oldDATA/ind/")

#Read image from directory 
# filName <- "S.nsp-chr3-shortarm-labelsFULLCOLOR-Ca.png"
indBands <- list.files(path="./", pattern=".png", all.files=TRUE, full.names=FALSE)
for(i in 1: length(indBands)){
  fileName1 <- paste(indBands[i], sep = "")
  # fileName1 <- "test.png"
  img1 <- image_read(fileName1)
  #Rsize image to 400 
  img2 <- image_resize(img1, 300)
  # image colorize to change dimensions to 1:3  
  img3 <- image_colorize(img2, opacity = 1 , color="red")
  # Convert image to jpg 
  img4 <- image_convert(img3,format="jpeg", colorspace="rgb", depth=8,antialias = TRUE,matte = FALSE )
  nameofBand <- file_path_sans_ext(fileName1)
  newfile <- paste(nameofBand,".jpeg",sep = "")
  image_write(img4,path=newfile, format = "jpeg")
}
