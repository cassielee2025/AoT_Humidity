# Humidity data

This folder contains folders with original data and processed data.

## Folders

- `humidity_shapefiles_by_week/`: average relative humidity values by sensor as shapefiles by week (`Humidity_R/scripts/5_convert_shp_by_week.R`)
- `original_csv/`: original data from Array of Things (data attribution in this folder)
- `original_parquet/`: parquet file of original `.csv` file (`Humidity_R/scripts/1_csv_to_parquet.R`)
- `partition_weeks`: simple feature parquet files partitioned into weeks of 2019 (`Humidity_R/scripts/4_parition_weeks.R`)
- `sf_parquet/`: parquet file with observations as simple features (`Humidity_R/scripts/3_convert_sf.R`)
- `subsetted_summairzed_parquet/`: subsetted and averaged weekly relative humidity values (`Humidity_R/scripts/join_node_id_by_week.R`)
