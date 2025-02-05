library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11()


cummulative = read.csv("data/processed/cummulative_sum_of_hazardspots.csv")

cummulative$rp = factor(cummulative$rp, levels=c("100a", "50a", "30a", "10a"))
cummulative %>% group_by(rp) %>% summarize(max(threshold))

# plot the cummulative sum of hotspots ranked by size
ggplot(cummulative) +
    #geom_point(aes(threshold, hotspots, col=rp, pch=depth)) +
    geom_line(aes(threshold*100, hotspots, col=rp, linetype=depth), size=1.2) +
    #scale_x_reverse() +
    #scale_x_log10() +
    scale_y_log10() +
    #facet_wrap(~rp) +
    theme_bw(base_size = 14) +
    scale_color_scico_d(palette = "managua", direction= 1) +
    #xlab("Size of hazardous area [number of connected cells | 100 m²]") +
    xlab("Size of hazardous area [m²]") +
    ylab("Cummulative count of \n hazardous areas [log scale]") +
    #xlim(500,4)
    xlim(2, 110000) -> p2
