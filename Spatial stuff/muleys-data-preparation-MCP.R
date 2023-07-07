library(adehabitatHR)
library(sp)

muleys <- read.csv("muleysexample.csv", header = T)
str(muleys)

newmuleys <- subset(muleys, muleys$Long > -110.90 & muleys$Lat > 37.8)
muleys <- newmuleys
newmuleys <- subset(muleys, muleys$Long < -107)
muleys <- newmuleys

# Create spatial points for all relocations and assign IDs to each location
data.xy <- muleys[c("X", "Y")] ###what are these x/y columns in the dataset? 
#creates class spatial points for all locations
xysp <- SpatialPoints(data.xy)
proj4string(xysp) <- CRS("+proj=utm +zone=17 +ellps=WGS84")

# Creates a Spatial Data Frame from
sppt <- data.frame(xysp)
# Creates a spatial data frame of ID
idsp <- data.frame(muleys[2])
# Merges ID and Date into same spatial data frame
merge <- data.frame(idsp)
# Adds ID and Date data frame with locations data frame
coordinates(merge) <- sppt
plot(merge)
str(merge)

# Estimate MCP
cp <- mcp(merge[,1], percent = 95) ###DO NOT USE MCP TO ESTIMATE HOME RANGE
as.data.frame(cp)
plot(cp) #plot mcp
plot(cp[2,]) #only plot deer D8
plot(merge, col = as.data.frame(merge)[,1], add = TRUE) #and plot relocations

# MCPs can be exported as shapefiles if needed for GIS
#library(maptools)
#writePolyShape(cp, "MCPhomerange")

