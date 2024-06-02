# write separate sf parquet files for each week, change file name
# 05/25/2024

# load libraries
library(tidyverse)
library(here)
library(arrow)
library(sfarrow)

# load original sf parquet file
sf_parquet <- st_read_parquet(here("data/sf_parquet/sf_parquet.parquet"))

# partition by day and write sf parquet files
sf_parquet %>% 
  group_by(week) %>% 
  write_sf_dataset(
    path = here("data/partition_weeks/"),
    format = "parquet"
  )
