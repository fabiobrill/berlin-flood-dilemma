from osgeo import gdal, gdalconst

def translateToPCRaster(src_filename, dst_filename, ot=gdalconst.GDT_Float32, VS="VS_Scalar"):
    """
    wrapper around gdal.Translate to convert .tif to .map
    which is needed to load raster data into the PCRaster software
    """

    src_data = gdal.Open(src_filename)
    dst_data = gdal.Translate(dst_filename, src_data, format="PCRaster", outputType=ot, metadataOptions=VS)

    src_data = None
    dst_data = None


translateToPCRaster("data/raw/bottomElevation_10m.tif", "data/processed/dem_10m.map")
translateToPCRaster("data/raw/osm_water_rasterized.tif", "data/processed/osm_water.map")
translateToPCRaster("data/raw/osm_water_rasterized_binary.tif", "data/processed/osm_water_binary.map")
translateToPCRaster("data/raw/hms_simulation_KOSTRA/10a_10m_maxDepth.tif", "data/processed/wdmax_10a.map")
translateToPCRaster("data/raw/hms_simulation_KOSTRA/30a_10m_maxDepth.tif", "data/processed/wdmax_30a.map")
translateToPCRaster("data/raw/hms_simulation_KOSTRA/50a_10m_maxDepth.tif", "data/processed/wdmax_50a.map")
translateToPCRaster("data/raw/hms_simulation_KOSTRA/100a_10m_maxDepth.tif", "data/processed/wdmax_100a.map")