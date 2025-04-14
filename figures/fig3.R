library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11()


size_ratio = read.csv("data/processed/size_ratio_hazardspots_subcatchments.csv")
size_ratio$RP = factor(size_ratio$rp, levels=c("100a", "50a", "30a", "10a"))

# density
ggplot(size_ratio) +
    geom_histogram(aes(ratio, y=stat(density), fill=RP), col="black", size=0.5, binwidth = 0.025) + facet_wrap(~threshold)+
    scale_fill_scico_d(palette = "managua") +
    ylab("Density \n") +
    xlab("Size ratio of hazardous areas and their respective catchments") +
    theme_bw(base_size = 14) -> p3
