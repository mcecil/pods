library(terra)
library(raster)
library(dplyr)

## This script analyzes the orbit and view angle of Sentinel-1 images for each site. 
## For ASCENDING images, it finds the most common view angle
## images that do NOT have the most common angle, are moved to a separate folder, 
## 'second_s1_path ', within the 's1_gf' folder for each site.

## ASCENDING ORBIT


A_folders <- list.files('/Users/mcecil/Documents/pods/scripts/GEE/S1/s1_batch_A/s1_batch_A/')
s1_a <- '/Users/mcecil/Documents/pods/scripts/GEE/S1/s1_batch_A/s1_batch_A/'

df <- data.frame(name = A_folders)

df$A_count <- sapply(A_folders, function(x){
  length(list.files(paste0(s1_a, x)))
})
# df$D_count <- sapply(A_folders, function(x){
#   length(list.files(paste0(s1_d, x)))
# })

#r <- terra::ras("C:/Users/micha/Documents/Github/pods/data/s1_batch_A/s1_batch_A/choma_A000247/S1B_IW_GRDH_1SDV_20170904T164018_20170904T164043_007244_00CC59_53B8.tif")

dfs_A <- lapply(A_folders, function(x){
  print(x)
  tifs <- list.files(paste0(s1_a, x), 
                     pattern = '.tif',
                     full.names = T)
  tif_df <- data.frame(name = tifs)
  tif_df$mode <- 'A'
  tif_df$Location <- x
  tif_df$min <- sapply(tifs, function(fname){
    r <- terra::rast(fname)
    setMinMax(r)
    a <- minmax(r)
    min_angle <- a[1,3]
  })
  tif_df$max <- sapply(tifs, function(fname){
    r <- terra::rast(fname)
    setMinMax(r)
    a <- minmax(r)
    max_angle <- a[1,3]
  })
  tif_df
})


all_sites_min_max <- data.frame(site = A_folders)
all_sites_min_max$min_angle <- sapply(1:nrow(all_sites_min_max), function(x){
  min_angle <- min(dfs_A[[x]][['min']])
})

all_sites_min_max$max_angle <- sapply(1:nrow(all_sites_min_max), function(x){
  max_angle <- max(dfs_A[[x]][['max']])
})


all_sites_min_max$diff <- all_sites_min_max$max_angle - all_sites_min_max$min_angle

all_sites_min_max$total_images <- sapply(1:nrow(all_sites_min_max), function(x){
  image_df <- dfs_A[[x]]
  a <- nrow(image_df)
})
  
all_sites_min_max$images_to_keep <- sapply(1:nrow(all_sites_min_max), function(x){
  image_df <- dfs_A[[x]]
  min_angle_table <- round(image_df[['min']]) %>% table()
  most_common_i <- which.max(min_angle_table)
  most_common_min_angle <- names(min_angle_table)[most_common_i] %>% as.numeric()
  images_to_keep <- image_df[abs(image_df$min - most_common_min_angle) < 2,]
  a <- nrow(images_to_keep)
})


## move A files
for(x in 1:nrow(all_sites_min_max)){
  site <- all_sites_min_max$site[x]
  print(site)
  image_df <- dfs_A[[x]]
  min_angle_table <- round(image_df[['min']]) %>% table()
  most_common_i <- which.max(min_angle_table)
  most_common_min_angle <- names(min_angle_table)[most_common_i] %>% as.numeric()
  images_to_keep <- image_df[abs(image_df$min - most_common_min_angle) < 2,]
  images_to_move <- image_df[abs(image_df$min - most_common_min_angle) >= 2,]
  image_paths_to_move <- images_to_move$name
  print(length(image_paths_to_move))
  
  image_names_to_move <- sapply(image_paths_to_move, function(y){
    names <- strsplit(y, split = '/')[[1]]
    name <- names[length(names)]
  }) 
  
  my.file.rename <- function(from, to) {
    todir <- dirname(to)
    if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
    file.rename(from = from,  to = to)
  }
  
  for(name in image_names_to_move){
    vv_name <- str_replace(name, '.tif', '_VV_lasso.tif')
    my.file.rename(from = paste0(s1_a, site, '/', 's1_gf/', vv_name),
                   to = paste0(s1_a, site, '/', 's1_gf/', 'second_s1_path/', vv_name))
    vh_name <- str_replace(name, '.tif', '_VH_lasso.tif')
    my.file.rename(from = paste0(s1_a, site, '/', 's1_gf/', vh_name),
                   to = paste0(s1_a, site, '/', 's1_gf/', 'second_s1_path/', vh_name))
  }
}


## DESCENDING ORBIT

#s1_d <- 'C:/Users/micha/Documents/Github/pods/data/s1_batch_D/s1_batch_D/'

# dfs_D <- lapply(A_folders, function(x){
#   print(x)
#   tifs <- list.files(paste0(s1_d, x), 
#                      pattern = '.tif',
#                      full.names = T)
#   if(length(tifs) == 0){
#     return(NA)
#   }
#   tif_df <- data.frame(name = tifs)
#   tif_df$mode <- 'D'
#   tif_df$Location <- x
#   tif_df$min <- sapply(tifs, function(fname){
#     r <- terra::rast(fname)
#     setMinMax(r)
#     a <- minmax(r)
#     min_angle <- a[1,3]
#   })
#   tif_df$max <- sapply(tifs, function(fname){
#     r <- terra::rast(fname)
#     setMinMax(r)
#     a <- minmax(r)
#     max_angle <- a[1,3]
#   })
#   tif_df
# })


# 
# all_sites_min_max$min_angle_D <- sapply(1:nrow(all_sites_min_max), function(x){
#   print(x)
#   if(!is.data.frame(dfs_D[[x]])){
#     return(NA)
#   }
#   min_angle <- min(dfs_D[[x]][['min']])
# })
# 
# all_sites_min_max$max_angle_D <- sapply(1:nrow(all_sites_min_max), function(x){
#   if(!is.data.frame(dfs_D[[x]])){
#     return(NA)
#   }
#   max_angle <- max(dfs_D[[x]][['max']])
# })
# 
# 
# 
# all_sites_min_max$diff_D <- all_sites_min_max$max_angle_D - all_sites_min_max$min_angle_D
# 
# all_sites_min_max$total_images_D <- sapply(1:nrow(all_sites_min_max), function(x){
#   if(!is.data.frame(dfs_D[[x]])){
#     return(0)
#   }
#   image_df <- dfs_D[[x]]
#   a <- nrow(image_df)
# })
# 
# all_sites_min_max$images_to_keep_D <- sapply(1:nrow(all_sites_min_max), function(x){
#   if(!is.data.frame(dfs_D[[x]])){
#     return(0)
#   }
#   image_df <- dfs_D[[x]]
#   min_angle_table <- round(image_df[['min']]) %>% table()
#   most_common_i <- which.max(min_angle_table)
#   most_common_min_angle <- names(min_angle_table)[most_common_i] %>% as.numeric()
#   images_to_keep <- image_df[abs(image_df$min - most_common_min_angle) < 2,]
#   a <- nrow(images_to_keep)
# })



## move D files
# for(x in 1:nrow(all_sites_min_max)){
#   site <- all_sites_min_max$site[x]
#   print(site)
#   image_df <- dfs_D[[x]]
#   if(!(is.data.frame(image_df))){
#     next
#   }
#     
#   min_angle_table <- round(image_df[['min']]) %>% table()
#   most_common_i <- which.max(min_angle_table)
#   most_common_min_angle <- names(min_angle_table)[most_common_i] %>% as.numeric()
#   images_to_keep <- image_df[abs(image_df$min - most_common_min_angle) < 2,]
#   images_to_move <- image_df[abs(image_df$min - most_common_min_angle) >= 2,]
#   image_paths_to_move <- images_to_move$name
#   print(length(image_paths_to_move))
#   
#   image_names_to_move <- sapply(image_paths_to_move, function(y){
#     names <- strsplit(y, split = '/')[[1]]
#     name <- names[length(names)]
#   })
# 
#   my.file.rename <- function(from, to) {
#     todir <- dirname(to)
#     if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
#     file.rename(from = from,  to = to)
#   }
# 
#   for(name in image_names_to_move){
#     vv_name <- str_replace(name, '.tif', '_VV_lasso.tif')
#     my.file.rename(from = paste0(s1_d, site, '/', 's1_gf/', vv_name),
#                    to = paste0(s1_d, site, '/', 's1_gf/', 'second_s1_path/', vv_name))
#     vh_name <- str_replace(name, '.tif', '_VH_lasso.tif')
#     my.file.rename(from = paste0(s1_d, site, '/', 's1_gf/', vh_name),
#                    to = paste0(s1_d, site, '/', 's1_gf/', 'second_s1_path/', vh_name))
#   }
# }


