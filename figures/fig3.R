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
    geom_density(aes(ratio, col=RP), size=1.05, adjust=5) + facet_wrap(~threshold) +
    scale_fill_scico_d(palette = "managua") +
    scale_color_scico_d(palette = "managua") +
    ylab("Kernel density estimate \n") +
    xlab("Size ratio: hazardous areas divided by their respective subcatchment areas") +
    theme_bw(base_size = 14) -> p3
