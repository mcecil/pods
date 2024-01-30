# pods

## Python

1. Download Sentinel-2 data from Digital Earth Africa (DEA) using the DEA Sandbox and "S2_download_git.ipynb". Data exported to .tif files/
2. Download VIIRS Land Cover Dynamics (LCD) data from Google Earth Engine (GEE) using "extract_gee_coll_LCD_download.ipynb". Data exported to .csv files for each year.
3. Export VIIRS surface reflectance data from GEE using "extract_gee_coll_VIIRS.ipynb". Data is exported to.csv files.
4. Download Sentinel-1 data from GEE using "extract_gee_coll_s1_download.ipynb". Perform LASSO filter using "sentinel_lasso.ipynb".
5. **(needs review) Join data for different sources using "join_pods_VIIRS.ipynb". Data is saved to "all_filt.csv".

## R

1. Use 'pre_analysis_remove_secondary_S1.R' to filter the ascending orbit images to the most common view angle.
2. 'Analysis_PRE_PROCESSING.Rmd' performs several pre-processing steps, including joining Sentinel-1 and 2 data, splitting Kenya data into separate seasons, and calculating VI dormancy values.
3. 'Analysis_PHENO_FITTING.Rmd' performs padding for Mark time-series, masking for Sentinel-2 and VIIRS surface reflectance, and curve-fitting and Land Surface Phenology (LSP) extraction for Mark, Sentinel 1 and 2, VIIRS surface reflectance, and VIIRS Land Cover Dynamics (LCD). It also joins management data (planting and harvest) to site table.
4. 'Analysis_MULTISENSOR.Rmd' calculates mean and median LSP values, and uses a random forest model to calculate LSP dates, excluding each site's current group from training the model.
5. 'Analysis_QUALITYCHECK.Rmd' outputs a pdf for visual interpretation to assess Mark LSP dates. After interpreting, Mark LSP dates that are not considered valid are excluded form downstream tasks.
6. 'Analysis_PAPER_TABLES_PLOTS.Rmd' performs agreement analysis (bias, MAD, R-squared) used in paper figures and tables. Outputs are labeled with Table/Figure number in final paper.
7. ''Analysis_FIGURES.Rmd' creates two visual diagrams (workflow and full-season length comparison) used in paper. The output figures are labeled with their Figure number in final paper. 

