library(adehabitatHR)
library(sp)
library(rgdal)
library(tidyverse)
library(dplyr)
library(sf)
library(terra)


## Set up data
tag44067 <- read.csv("Tag44067.csv")
tag44067 <- tag44067 %>% select("longitude", "latitude") %>% filter(longitude != "NA" &
                                                                    latitude != "NA")
ID <- rep(44067, length(tag44067$longitude))
tag44067 <- tag44067 %>% cbind(ID)

################################################################################
## Subset tag location data for getting UTM coords
for.UTM.tag44067 <- tag44067 %>% select(longitude, latitude)
colnames(for.UTM.tag44067) <- c("X", "Y")

## Change from lat/long to UTM
coordinates(for.UTM.tag44067) <- c("X", "Y")
proj4string(for.UTM.tag44067) <- CRS("+proj=longlat +datum=WGS84")

res <- spTransform(for.UTM.tag44067, CRS("+proj=utm +zone=10 ellps=WGS84"))
UTM.tag44067 <- as.data.frame(res) #change from spatial to dataframe

tag44067 <- cbind(tag44067, UTM.tag44067) #merge dataframes

###############################################################################
# Create spatial points for all relocations and assign IDs to each location
data.xy <- tag44067[c("X", "Y")] # long=easting=X, lat=northing=Y

#creates class spatial points for all locations
xysp <- SpatialPoints(data.xy)
proj4string(xysp) <- CRS("+proj=utm +zone=10 +ellps=WGS84")

# Creates a Spatial Data Frame from
sppt <- data.frame(xysp)
# Creates a spatial data frame of ID
idsp <- data.frame(tag44067[3])
# Merges ID and Date into same spatial data frame
merge <- data.frame(idsp)
# Adds ID and Date data frame with locations data frame
coordinates(merge) <- sppt
plot(merge)

# Estimate MCP
cp <- mcp(merge[,1], percent = 95) ###DO NOT USE MCP TO ESTIMATE HOME RANGE
as.data.frame(cp)
plot(cp) #plot mcp
plot(merge, col = as.data.frame(merge)[,1], add = TRUE) #and plot relocations




