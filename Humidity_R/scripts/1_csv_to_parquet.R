# convert humidity csv data to parquet file
# 05/25/2024

# load libraries
library(tidyverse)
library(here)
library(arrow)

# use arrow package to load data
AoT_nodes <- open_dataset(
  sources = here("data/original_csv/data_no_nulls.csv"),
  format = "csv",
  col_types = schema(value_raw = double())
)

# write data as parquet file
AoT_nodes %>% 
  write_dataset(
    path = here("data/original_parquet"),
    format = "parquet"
  )
