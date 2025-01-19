library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11()


size_ratio = read.csv("data/processed/size_ratio_hazardspots_subcatchments.csv")
size_ratio$rp = factor(size_ratio$rp, levels=c("100a", "50a", "30a", "10a"))

# density
ggplot(size_ratio) +
    #geom_histogram(aes(ratio, fill=rp), col="black", size=0.5) + facet_wrap(~threshold)+
    geom_histogram(aes(ratio, y=stat(density), fill=rp), col="black", size=0.5, binwidth = 0.025) + facet_wrap(~threshold)+
    #geom_density(aes(ratio, col=rp), size=1, adjust=2) + facet_wrap(~threshold)+
#    xlim(0,0.5) +
    scale_fill_scico_d(palette = "managua") +
    xlab("Size ratio of hazardous areas and their respective catchments") +
    theme_bw()

# count
ggplot(size_ratio) +
    #geom_histogram(aes(ratio, fill=rp), col="black", size=0.5) + facet_wrap(~threshold)+
    geom_histogram(aes(ratio, fill=rp), col="black", size=0.5, binwidth = 0.01) + facet_wrap(~threshold)+
    #geom_density(aes(ratio, col=rp), size=1, adjust=2) + facet_wrap(~threshold)+
#    xlim(0,0.5) +
    scale_fill_scico_d(palette = "managua") +
    theme_bw()

# plot the distribution of connected inundation size
ggplot(size_ratio) +
    #geom_histogram(aes(ratio, fill=rp), col="black", size=0.5) + facet_wrap(~threshold)+
    geom_density(aes(hazardspots, col=rp), size=1, adjust=2, size=1.2) + facet_wrap(~threshold)+
    xlim(10,200) +
    #scale_fill_manual(values=wes_palette("Chevalier1")) +
    scale_color_scico_d(palette = "managua") +
    theme_bw()

# plot the distribution of subcatchment size
ggplot(size_ratio) +
    #geom_histogram(aes(ratio, fill=rp), col="black", size=0.5) + facet_wrap(~threshold)+
    geom_rect(xmin=1000, xmax=2000, ymin=0, ymax=0.002, fill="green", alpha=0.3) +
    geom_density(aes(subcatchments, col=rp), size=1, adjust=2, size=1.2) +
    facet_wrap(~threshold) +
    xlim(10,5000) +
    geom_vline(xintercept=173.8, col="darkred") +
    #scale_fill_manual(values=wes_palette("Chevalier1")) +
    scale_color_scico_d(palette = "managua") +
    theme_bw()

# plot the distribution of subcatchment size and hazardspots and blocks
ggplot(size_ratio) +
    #geom_histogram(aes(ratio, fill=rp), col="black", size=0.5) + facet_wrap(~threshold)+
    geom_histogram(aes(subcatchments, fill=rp), size=1, adjust=2, size=1.2) +
    geom_histogram(aes(hazardspots, col=rp), size=1, adjust=2, size=1.2) +
    facet_wrap(~threshold) +
    xlim(10,5000) +
    geom_vline(xintercept=173.8, col="darkred") +
    #scale_fill_manual(values=wes_palette("Chevalier1")) +
    scale_fill_scico_d(palette = "managua") +
    theme_bw()

