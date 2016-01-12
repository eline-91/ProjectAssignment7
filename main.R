# Geetika Rathee & Eline van Elburg
# January 12, 2016
# Assignment Lesson 7

# Import necessary libraries
library(raster)
library(rgdal)

# Define input and output folder!
inputFolder <- '/home/user/Projects/AssignmentLesson7/data'
outputFolder <- '/home/user/Projects/AssignmentLesson7/output'

# Find the full path of the Modis .grd file and turn it into a brick
modisPath <- list.files(inputFolder, pattern = glob2rx('MOD*.grd'), full.names = TRUE)
modis_files <- brick(modisPath)

# Download municipality boundaries data
nlMunicipality <- raster::getData('GADM',country='NLD', level=2, path = inputFolder)

# Reproject the nlMunicipality boundaries to the same projection as Modis
nlMunicipalityProject <- spTransform(nlMunicipality, CRS(proj4string(modis_files)))


