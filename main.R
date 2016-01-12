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

# Extract the average NDVI per municipality
avg_NDVI <- extract(modis_files, nlMunicipalityProject, fun = mean, df = TRUE, full.names = TRUE, sp = TRUE)

# Greenest city in Januari: Littenseradiel
greenest_city_January <- avg_NDVI$NAME_2[which.max(avg_NDVI$January)]

# Greenest city in August: Vorden
greenest_city_August <- avg_NDVI$NAME_2[which.max(avg_NDVI$August)]

# Greenest city in the whole year: Graafstroom
months <- as.data.frame(avg_NDVI[,16:27])
avg_NDVI <- transform(avg_NDVI, Average_Year = rowMeans(months, na.rm = TRUE))
greenest_city_Year <- avg_NDVI$NAME_2[which.max(avg_NDVI$Average_Year)]

# Plot 
nlMunicipalityProject@data <- nlMunicipalityProject@data[!is.na(nlMunicipalityProject$NAME_2),] ## remove rows with NA
munContour <- nlMunicipalityProject[nlMunicipalityProject$NAME_2 == greenest_city_January,]
munModis <- mask(modis_files$January, munContour)
plot(munContour, main = greenest_city_January)
plot(munModis, add = T)
plot(munContour, add = T) 

