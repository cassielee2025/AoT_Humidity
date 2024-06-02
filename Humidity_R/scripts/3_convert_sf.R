# write parquet as sf parquet
# 05/25/2024

# load libraries
library(tidyverse)
library(here)
library(arrow)
library(sfarrow)
library(sf)

# create sf class object
AoT_sf <- read_parquet(
  here("data/subsetted_summarized_parquet/part-0.parquet")) %>% 
  st_as_sf(coords = c("lon", "lat")) 

AoT_sf %>% glimpse()

# write sf parquet file
st_write_parquet(
  AoT_sf, 
  here("data/sf_parquet/sf_parquet.parquet")
)

# read parquet file back in
# st_read_parquet(here("data/sf_parquet/sf_parquet.parquet"))
