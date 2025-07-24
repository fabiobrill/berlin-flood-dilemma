library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11()


cummulative = read.csv("data/processed/cummulative_sum_of_hazardspots.csv")

cummulative$RP = factor(cummulative$rp, levels=c("100a", "50a", "30a", "10a"))
cummulative$Depth = cummulative$depth
cummulative %>% group_by(RP) %>% summarize(max(threshold))

# plot the cummulative sum of hotspots ranked by size
ggplot(cummulative) +
    geom_line(aes(threshold*100, hotspots, col=RP, linetype=Depth), size=1.2) +
    scale_y_log10() +
    theme_bw(base_size = 14) +
    scale_color_scico_d(palette = "managua", direction= 1) +
    xlab("Size of hazardous area [m²]") +
    ylab("Cummulative count of \n hazardous areas [log scale]") +
    xlim(2, 110000) -> p2
