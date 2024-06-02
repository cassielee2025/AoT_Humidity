# write as shapefile bc ArcGIS does not integrate well with parquet files yet
# 05/25/2024

# load libraries
library(tidyverse)
library(here)
library(arrow)
library(sfarrow)
library(sf)

# get list of all folders in partition_weeks folder
weeks <- list.dirs(
  here("data/partition_weeks/"), 
  # only the name of the folder within partition_days
  full.names = FALSE, 
  # only list folders in partition_days
  recursive = FALSE
)

for (week in weeks) {
  
  # get path to individual partition day folder
  read_path <- paste0(
    "data/partition_weeks/", 
    week,
    "/part-0.parquet"
  )
  
  # get path to write sf file
  write_path <- paste0(
    "data/humidity_shapefiles_by_week/",
    week, 
    "/"
  )
  
  # read in partitioned parquet file
  week <- st_read_parquet(here(read_path))
  
  # convert parquet to sf, NAD83
  week_sf <- st_as_sf(week, CRS = st_crs(4269))
  
  # write shapefile to folder
  st_write(week_sf, here(write_path), driver = "ESRI Shapefile")
  
}
