library(scico)
library(ggplot2)
library(dplyr)
library(terra)
library(sf)
x11()


df = read.csv("data/processed/wd_merged.csv")
df$RP = case_when(
    df$rp == 10 ~ "10a",
    df$rp == 30 ~ "30a",
    df$rp == 50 ~ "50a",
    df$rp == 100 ~ "100a"
)
df$RP = factor(df$RP, levels=c("100a", "50a", "30a", "10a"))

head(df)
unique(df$RP)

df = na.omit(df)

df$wdcat = case_when(
    df$wdmax < 0.1 ~ "< 10",
    df$wdmax < 0.2 ~ "10-20",
    df$wdmax < 0.3 ~ "20-30",
    df$wdmax < 0.4 ~ "30-40",
    df$wdmax < 0.5 ~ "40-50",
    df$wdmax < 0.6 ~ "50-60",
    df$wdmax < 0.7 ~ "60-70",
    df$wdmax < 0.8 ~ "70-80",
    df$wdmax < 0.9 ~ "80-90",
    df$wdmax >= 0.9 ~ "> 90"
)

df$wdcat = factor(df$wdcat, levels = c(
    "< 10",
    "10-20",
    "20-30",
    "30-40",
    "40-50",
    "50-60",
    "60-70",
    "70-80",
    "80-90",
    "> 90"
))

sumdf = df %>% 
    group_by(RP, wdcat) %>%
    summarize(ncells = length(wdcat))

ggplot(sumdf %>% filter(wdcat != "< 10")) +
    geom_col(aes(x=wdcat, y=ncells/10000, fill=RP), size=1.2, position="dodge") +
    theme_bw(base_size=14) +
    ylab("Area [km²] \n") +
    xlab("Water depth [cm]") +
    scale_fill_scico_d(palette="managua") -> p1
