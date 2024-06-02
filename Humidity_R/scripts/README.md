# Humidity dataset scripts

These scripts process the Relative Humidity dataset into shapefiles with the average weekly relative humidity for each sensor by week.

## Files

- `1_csv_to_parquet.R`: convert initial csv file to parquet
- `2_join_node_id.R`: join node ID information to parquet file
- `3_convert_sf.R`: convert observations to simple features and write as parquet file
- `4_parition_weeks.R`: partition each observation into a parquet file, grouped by week
- `5_convert_shp_by_week.R`: convert parquet files by week to shape files


