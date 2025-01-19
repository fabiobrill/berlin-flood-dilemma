library(dplyr)


setwd("D:/gitscripts/berlin-flood-dilemma/data/processed")

# ----------------------------------------------------------------------------------------------- #
# function to compute the cummulative sum of hazardspots with decreasing size

getSumAboveSize = function(df){
    sum_above_threshold = vector("numeric")
    sorted_hazardspots = sort(df$freq_hs, decreasing = T)
    for(threshold in 1:max(df$freq_hs)){
        #print(threshold)
        sum_above_threshold[threshold] = sum(sorted_hazardspots > threshold)
    }
    sumdf = data.frame(
        threshold=1:length(sum_above_threshold),
        hazardspots=sum_above_threshold,
        rp=factor(df$rp[1], levels=c("10a", "30a", "50a", "100a")),
        depth=df$threshold[1])
    return(sumdf)
}

# ----------------------------------------------------------------------------------------------- #
# merge size ratio for 30cm vs 60cm hazardspots

df10_30 = read.csv("10a_hazardspot_size_ratio_30cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df10_60 = read.csv("10a_hazardspot_size_ratio_60cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df30_30 = read.csv("30a_hazardspot_size_ratio_30cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df30_60 = read.csv("30a_hazardspot_size_ratio_60cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df50_30 = read.csv("50a_hazardspot_size_ratio_30cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df50_60 = read.csv("50a_hazardspot_size_ratio_60cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df100_30 = read.csv("100a_hazardspot_size_ratio_30cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)
df100_60 = read.csv("100a_hazardspot_size_ratio_60cm_masked.csv") %>% filter(!id %in% c(NA, 0,3)) #%>% filter(hazardspots > 2)

df10_30$rp = "10a"; df10_30$threshold = "30cm"
df10_60$rp = "10a"; df10_60$threshold = "60cm"
df30_30$rp = "30a"; df30_30$threshold = "30cm"
df30_60$rp = "30a"; df30_60$threshold = "60cm"
df50_30$rp = "50a"; df50_30$threshold = "30cm"
df50_60$rp = "50a"; df50_60$threshold = "60cm"
df100_30$rp = "100a"; df100_30$threshold = "30cm"
df100_60$rp = "100a"; df100_60$threshold = "60cm"

merged = rbind.data.frame(
    df10_30, df10_60,
    df30_30, df30_60,
    df50_30, df50_60,
    df100_30, df100_60
)

write.csv(merged, "size_ratio_hazardspots_subcatchments.csv", row.names=F)

# ----------------------------------------------------------------------------------------------- #
# merge cummulative sum above thresholds

sums_10_30 = getSumAboveSize(df10_30)
sums_10_60 = getSumAboveSize(df10_60)
sums_30_30 = getSumAboveSize(df30_30)
sums_30_60 = getSumAboveSize(df30_60)
sums_50_30 = getSumAboveSize(df50_30)
sums_50_60 = getSumAboveSize(df50_60)
sums_100_30 = getSumAboveSize(df100_30)
sums_100_60 = getSumAboveSize(df100_60)

sums_merged = rbind.data.frame(
    sums_10_30, sums_10_60,
    sums_30_30, sums_30_60,
    sums_50_30, sums_50_60,
    sums_100_30, sums_100_60
)

write.csv(sums_merged, "cummulative_sum_of_hazardspots.csv", row.names=F)
