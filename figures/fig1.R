library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11()


df = read.csv("data/processed/wd_merged.csv")
df$rp = factor(df$rp, levels=c(100, 50, 30, 10))

head(df)
unique(df$rp)

df = na.omit(df)

df$wdcat = case_when(
    df$wdmax < 0.1 ~ "< 10 cm",
    df$wdmax < 0.2 ~ "10-20 cm",
    df$wdmax < 0.3 ~ "20-30 cm",
    df$wdmax < 0.4 ~ "30-40 cm",
    df$wdmax < 0.5 ~ "40-50 cm",
    df$wdmax < 0.6 ~ "50-60 cm",
    df$wdmax < 0.7 ~ "60-70 cm",
    df$wdmax < 0.8 ~ "70-80 cm",
    df$wdmax < 0.9 ~ "80-90 cm",
    df$wdmax >= 0.9 ~ "> 90 cm"
)

df$wdcat = factor(df$wdcat, levels = c(
    "< 10 cm",
    "10-20 cm",
    "20-30 cm",
    "30-40 cm",
    "40-50 cm",
    "50-60 cm",
    "60-70 cm",
    "70-80 cm",
    "80-90 cm",
    "> 90 cm"
))

sumdf = df %>% 
    group_by(rp, wdcat) %>%
    summarize(ncells = length(wdcat))

ggplot(sumdf %>% filter(wdcat != "< 10 cm")) +
    geom_col(aes(x=wdcat, y=ncells/10000, fill=rp), size=1.2, position="dodge") +
    theme_bw(base_size=14) +
    #xlim(20,200) +
    ylab("Area [km²] \n") +
    xlab("Water depth") +
    scale_fill_scico_d(palette="managua") -> p1
