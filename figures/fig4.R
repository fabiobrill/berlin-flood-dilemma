# Visualization of the size of hotspots and catchments vs city blocks
# - using a single scenario or all RPs?

library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11() # open new plotting window

size_ratio = read.csv("data/processed/size_ratio_hazardspots_catchments.csv")
size_ratio$rp = factor(size_ratio$rp, levels=c("100a", "50a", "30a", "10a"))
size_ratio$water_depth = factor(size_ratio$threshold, levels=c("30cm", "60cm"))
size_ratio$area_hs = size_ratio$freq_hs * 100
size_ratio$area_sc = size_ratio$freq_sc * 100
#size_ratio %>% group_by(water_depth) %>% summarize(mean(area_hs), mean(area_sc))
blocks_file = "./matteo/data/old/green_roofs.shp"
berlin_file = "data/raw/exposure/Berlin_Landesgrenze.shp"

# study area, for context of geometry plots
berlin = read_sf(berlin_file) %>% st_geometry()
crs_berlin = st_crs(berlin)
blocks = read_sf(blocks_file) %>% st_transform(crs_berlin)
blocks$area = st_area(blocks) %>% as.numeric()
summary(blocks$area)

# density curve version, with linetype separation
ggplot() +
    geom_density(aes(area_sc, y=..scaled.., color="subcatchments", linetype=water_depth), fill="lightblue", alpha=0.5, data=size_ratio, adjust=2, size=1.3) +
    geom_density(aes(area, y=..scaled.., color="city blocks"), fill="lightgrey", alpha=0.7, data=blocks, adjust=2, size=1.3) +
    geom_density(aes(area_hs, y=..scaled.., color="hazard spots", linetype=water_depth), fill="pink", alpha=0.5, data=size_ratio, adjust=2, size=1.3) +
    #facet_wrap(~rp) +
    xlim(1,100000) +
    scale_color_manual(values = c(
        "subcatchments" = "royalblue3",#"dodgerblue2",
        "city blocks" = "grey30",
        "hazard spots" = "firebrick2")) +
    theme_bw() +
    theme(legend.title=element_blank(), legend.position="bottom") +
    xlab("Area [m²]") +
    ylab("Density (scaled)")

# rectangle version
#ggplot() +
#    geom_rect(aes(xmin=500, xmax=1700, ymin=0, ymax=1), fill="lightgreen", alpha=0.8) +
#    geom_rect(aes(xmin=7925, xmax=72125, ymin=0, ymax=1), fill="slateblue", alpha=0.8) +
#    geom_rect(aes(xmin=9892, xmax=27612, ymin=0, ymax=1), fill="gold", alpha=0.8) +
#    xlim(1,100000) +
#    theme_bw()


ggplot() +
    geom_histogram(aes(area_sc, color="subcatchments", linetype=water_depth), fill="pink", alpha=0.5, data=size_ratio, size=1.3) +
    geom_histogram(aes(area, color="city blocks"), fill="lightgrey", alpha=0.7, data=blocks, size=1.3) +
    geom_histogram(aes(area_hs, color="hazard spots", linetype=water_depth), fill="lightblue", alpha=0.5, data=size_ratio, size=1.3) +
    #facet_wrap(~rp) +
    xlim(1,100000) +
    ylim(0,10000) +
    scale_color_manual(values = c(
        "subcatchments" = "firebrick2",#"dodgerblue2",
        "city blocks" = "grey30",
        "hazard spots" = "royalblue3")) +
    theme_bw() +
    theme(legend.title=element_blank(), legend.position="bottom") +
    xlab("Area [m²]")
    #ylab("")
