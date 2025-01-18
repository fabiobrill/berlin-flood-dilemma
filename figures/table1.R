library(dplyr)
library(terra)
library(sf)
library(ggplot2)
library(scico)
x11()

setwd("data/raw/hms_simulation_KOSTRA")
berlin = read_sf("../Berlin_Landesgrenze.shp")
st_area(berlin)
56040344 + 890666878 # does the total area make sense?

rp10  = data.frame(wdmax = values(rast("10a_10m_maxDepth.tif"))[,1], rp=factor(10, levels=c(10,30,50,100)))
rp30  = data.frame(wdmax = values(rast("30a_10m_maxDepth.tif"))[,1], rp=factor(30, levels=c(10,30,50,100)))
rp50  = data.frame(wdmax = values(rast("50a_10m_maxDepth.tif"))[,1], rp=factor(50, levels=c(10,30,50,100)))
rp100 = data.frame(wdmax = values(rast("100a_10m_maxDepth.tif"))[,1], rp=factor(100, levels=c(10,30,50,100)))

merged = rbind.data.frame(rp10, rp30, rp50, rp100)
fractions = merged %>% 
    group_by(rp) %>%
    summarize(area_low = length(which(wdmax < 0.3)),
              area_30 = length(which(wdmax >= 0.3 & wdmax < 0.6)),
              area_60 = length(which(wdmax >= 0.6)),
              area_total = sum(area_low, area_30, area_60),
              percent_low = 100*area_low/area_total,
              percent_30 = 100*area_30/area_total, 
              percent_60 = 100*area_60/area_total)

# table of area
fractions

#write.csv(merged, "../../../processed/merged_wdmax.csv", row.names=F)
#write.csv2(fractions, "../../../fractions.csv")


# plot distribution of water depth as density
ggplot() +geom_density(aes(wdmax*100, col=rp), size=1.2, data=rp10) +
          geom_density(aes(wdmax*100, col=rp), size=1.2, data=rp30) +
          geom_density(aes(wdmax*100, col=rp), size=1.2, data=rp50) +
          geom_density(aes(wdmax*100, col=rp), size=1.2, data=rp100) +
          theme_bw(base_size=15) +
          xlim(20,200) +
          scale_color_scico_d(palette="managua")
