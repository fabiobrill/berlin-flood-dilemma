# Delineating subcatchemnts around inundation hotspots
# using the PCRaster Python module
# This modul comes with some peculiarities:
# besides rather odd function names, it requires data in a specific format (.map)
# and the first necessary step is to set a "clone" (i.e. reference data extent)


import numpy as np
from osgeo import gdal
from pcraster import *

min_size = 5 # cells, 10x10 m each

def writeRaster(data, outname, srs, proj, dtype=gdal.GDT_UInt16):
    """
    Exports a 2D dataset as GTiff raster. default dtype is set to GDT_Byte -
    this can be any gdal dtype e.g. UInt16. srs and proj should be obtained
    from the input file via the .GeoGeoTransform() and .GetProjection()
    """

    if data.ndim != 2:
        print('Provided data is not 2D')

    xs, ys = data.shape
    driver = gdal.GetDriverByName("GTiff")
    outfile = driver.Create(outname, ys, xs, 1, dtype)
    outfile.SetGeoTransform(srs)
    outfile.SetProjection(proj)
    outfile.GetRasterBand(1).WriteArray(data)
    outfile = None


# set the DEM as "clone" and read the file in PCRaster format
pcraster.setclone("data/processed/dem_10m.map")
dem = pcraster.readmap("data/processed/dem_10m.map")
permanent_water_file = gdal.Open("data/raw/osm_water_rasterized_binary.tif")
permanent_water = permanent_water_file.GetRasterBand(1).ReadAsArray()

# compute the flow direction - so far only using D8
#flowdir = lddcreate(dem, 1e31, 1e31, 1e31, 1e31)
#pcraster.report(flowdir, "data/processed/flowdir.map")
flowdir = readmap("data/processed/flowdir.map")

# read the water depth from .tif as numpy array and
# derive inundation hotspots from (multiple) threshold(s)
#wd_file = gdal.Open("tifs/max_depth_on_dem.tif")
for prefix in ("10a", "30a", "50a", "100a"):
    wd_file = gdal.Open("data/raw/hms_simulation_KOSTRA/" + prefix + "_10m_maxDepth.tif")
    wd = wd_file.GetRasterBand(1).ReadAsArray()
    for i in range(1, 16):
        th = i/10
        print("processing threshold", th)
        hotspots = wd > th
        hotspots = hotspots + permanent_water # add permanent water to hotspots
        hotspots[hotspots > 1] = 1 # in case of overlap, make sure that result is binary
        hotspots_pcr = numpy2pcr(Boolean, hotspots, 0)
        hotspot_ids = clump(hotspots_pcr)
        hotspot_ids_np = pcr2numpy(hotspot_ids, 0)
 
        if min_size > 0:
            ids, freq = np.unique(hotspot_ids_np, return_counts=True)
            filter_ids = ids[freq < min_size]
            hotspot_ids_np[np.isin(hotspot_ids_np, filter_ids)] = 0
            hotspot_ids = numpy2pcr(Nominal, hotspot_ids_np, 0)
        
        subdelineation = pcraster.subcatchment(flowdir, hotspot_ids)
        subdelineation_np = pcr2numpy(subdelineation, 0)

        postfix = str(int(th*100)) + "cm.tif"
        writeRaster(hotspot_ids_np, "data/processed/" + prefix + "_hotspot_ids_"  + postfix, wd_file.GetGeoTransform(), wd_file.GetProjection())
        writeRaster(subdelineation_np, "data/processed/" + prefix + "_subcatchments_" + postfix, wd_file.GetGeoTransform(), wd_file.GetProjection())
