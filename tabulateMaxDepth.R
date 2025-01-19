library(raster)
library(sf)
library(dplyr)

berlin = read_sf("data/raw/Berlin_Landesgrenze.shp")
openwater = read_sf("data/raw/osm_water_berlin.gpkg")
df = data.frame()

for(rp in c(10, 30, 50, 100)){
    wdfile = paste0("data/raw/hms_simulation_KOSTRA/", rp, "a_10m_maxDepth.tif")
    wd = raster(wdfile) %>% mask(berlin) %>% mask(openwater, inverse=T)
    df = rbind.data.frame(df, data.frame(rp=rp, wdmax=values(wd)))
}

head(df)
df %>% group_by(rp) %>% summarize(mean(wdmax, na.rm=T))
write.csv(df, "data/processed/wd_merged_masked.csv", row.names=F)
