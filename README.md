# pods

1. Download Sentinel-2 data from Digital Earth Africa (DEA) using the DEA Sandbox and "S2_download_git.ipynb". Data exported to .tif files/
2. Download VIIRS Land Cover Dynamics (LCD) data from Google Earth Engine (GEE) using "extract_gee_coll_LCD_download.ipynb". Data exported to .csv files for each year.
3. Export VIIRS surface reflectance data from GEE using "extract_gee_coll_VIIRS.ipynb". Data is exported to.csv files.
4. Download Sentinel-1 data from GEE using "extract_gee_coll_s1_download.ipynb". Perform LASSO filter using "sentinel_lasso.ipynb".
5. ***Join data for different sources using "process_gee_rf.ipynb". Data is saved to "all_filt.csv", "all_filt_valid_pod.csv", "all_joined.csv".

## R

1. Use 'pre_analysis_remove_secondary_S1.R' to filter the ascending orbit images to the most common view angle.
2. 

