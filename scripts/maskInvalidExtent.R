library(sf)
library(terra)
library(dplyr)

setwd("data/processed")

berlin = read_sf("../raw/Berlin_Landesgrenze.shp")
openwater = read_sf("../raw/osm_water_berlin.gpkg")
filelist = list.files(pattern=".tif")
filelist = filelist[!endsWith(filelist, ".aux.xml")]

for(filename in filelist){
    outname = gsub(".tif", "_masked.tif", filename)
    r = rast(filename)
    masked = r %>% mask(berlin) %>% mask(openwater, inverse=T)
    writeRaster(masked, outname)
    cat("file written: ", outname, "\n")
}
