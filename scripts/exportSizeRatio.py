# only to export selected data to csv file for visualization in R

from osgeo import gdal
import numpy as np
import pandas as pd

# loop this for the prefixes "10a", "30a", "50a", "100a" and postfixes "30cm_masked", "60cm_masked"
for prefix in ("10a", "30a", "50a", "100a"):
    for postfix in ("30cm_masked", "60cm_masked"):
        hazardspot_ids_np = gdal.Open("../data/processed/" + prefix + "_hazardspot_ids_" + postfix + ".tif")
        subcatchments_np = gdal.Open("../data/processed/" + prefix + "_subcatchments_" + postfix + ".tif")

        ids_hs, freq_hs = np.unique(hazardspot_ids_np.GetRasterBand(1).ReadAsArray(), return_counts=True)
        ids_sc, freq_sc = np.unique(subcatchments_np.GetRasterBand(1).ReadAsArray(), return_counts=True)

        df_hs = pd.DataFrame({"id": ids_hs, "freq_hs": freq_hs})
        df_sc = pd.DataFrame({"id": ids_sc, "freq_sc": freq_sc})

        # join the dataframes on the id column, keeping only the ids that are in both dataframes
        df = pd.merge(df_hs, df_sc, on="id", how="inner")
        df["ratio"] = df["freq_hs"]/df["freq_sc"]
        df.to_csv("../data/processed/" + prefix + "_hazardspot_size_ratio_" + postfix + ".csv")
        print("Exported", prefix, postfix)
print("Done")