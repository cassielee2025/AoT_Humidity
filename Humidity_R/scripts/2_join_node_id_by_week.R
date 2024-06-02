# join node ID to original parquet file and average by week
# 05/25/2024

# load libraries
library(tidyverse)
library(here)
library(arrow)
library(duckdb)

# load data ----
# parquet format node data
AoT_pq <- open_dataset(here("data/original_parquet")) %>% 
  # get the date (drop the time of day)
  mutate(
    # convert timestamp to just the day
    timestamp = str_sub(timestamp, 1, 10),
    timestamp = str_replace_all(timestamp, "/", "-"),
    # copy the timestamp string to day
    day = timestamp,
    # get the week of each day
    week = isoweek(ymd(day)),
    week = cast(week, int64()),
    # convert timestamp to arrow timestamp
    timestamp = paste(timestamp, "00:00:00", sep = " "),
    timestamp = cast(timestamp, timestamp())
  )

# load sensor location data
node_locations <- read_csv(here("data/original_csv/nodes.csv"))

# subset date range ----
# limit data to days from 2019
start_date <- as.POSIXct("2019-01-01 00:00")
end_date <- as.POSIXct("2019-12-31 00:00")

# subset node data
AoT_pq <- AoT_pq %>% 
  filter(
    timestamp >= start_date,
    timestamp <= end_date
  ) %>% 
  to_duckdb() %>% 
  mutate(week = if_else(week < 10,
                        paste0("0", as.character(week)),
                        as.character(week))) %>% 
  to_arrow() %>% 
  as_arrow_table()

# load data that is just timestamp
AoT_timestamps <- open_dataset(here("data/original_parquet")) %>%
  # get the date (drop the time of day)
  mutate(
    # convert timestamp to just the day
    timestamp = str_sub(timestamp, 1, 10),
    timestamp = str_replace_all(timestamp, "/", "-"),
    # copy the timestamp string to day
    day = timestamp,
    # get the week of each day
    week = isoweek(ymd(day)),
    week = cast(week, int64()),
    # convert timestamp to arrow timestamp
    timestamp = paste(timestamp, "00:00:00", sep = " "),
    timestamp = cast(timestamp, timestamp())
    
  ) %>% 
  filter(
    timestamp >= start_date,
    timestamp <= end_date
  ) %>% 
  to_duckdb() %>% 
  select(timestamp, week) %>% 
  mutate(week = if_else(week < 10,
                        paste0("0", as.character(week)),
                        as.character(week))) %>% 
  distinct(week, .keep_all = TRUE) %>% 
  to_arrow() %>% 
  as_arrow_table()

# glimpse data ----
# AoT_pq %>% glimpse()
# AoT_timestamps %>% as_arrow_table() %>% glimpse()
# node_locations %>% glimpse()

# prepare new dataset ----
# summarize humidity by timestamp and node_id
AoT_summary <- AoT_pq %>% 
  group_by(week, node_id) %>% 
  summarize(
    avg_humidity = mean(value_hrf, na.rm = TRUE),
    med_humidity = median(value_hrf, na.rm = TRUE),
    min_humidity = min(value_hrf, na.rm = TRUE),
    max_humidity = max(value_hrf, na.rm = TRUE)
  ) %>% 
  arrange(node_id, week) %>% 
  ungroup()

# AoT_summary %>% collect() %>% view()

# bind node location to AoT summary
AoT_clean <- AoT_summary %>% 
  left_join(node_locations) %>% 
  select(-c(project_id, vsn, description, start_timestamp, end_timestamp))

# bind timestamp information back to summary
AoT_clean <- AoT_clean %>% 
  left_join(AoT_timestamps)

# AoT_clean %>% collect() %>% slice(1:10) %>% view()

# save clean parquet file for further manipulation 
AoT_clean %>% 
  write_dataset(
    path = here("data/subsetted_summarized_parquet"),
    format = "parquet"
  )
