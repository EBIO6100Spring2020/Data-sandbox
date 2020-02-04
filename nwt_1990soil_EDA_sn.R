# A script exploring 1990 soil data at Niwot Saddle
# (note: we have vegetation data for 1990 at saddle!)

library(ggplot2)
library(dplyr)
library(tidyr)

soils = read.csv('data_raw/plant_competition/soil_data_1990/saddsoil.dw.data.csv')
# sadd soil :(

head(soils, 10)
# hgnbh the grid points here are a bummer man
# not tagged to plot, x, y coordinates from the veg data

# Okay - only 80 grid points sampled...
unique(soils$grid_pt)

nrow(soils)
# 81 samples... hmmm... is this for only one plot? Not very many replicates.

veg90 = read.csv('data_raw/plant_competition/vegetation_sampling/saddptqd.hh.data.csv') %>%
  filter(year %in% 1990) %>%
  filter(point < 100)

head(veg90)
nrow(veg90)

unique(veg90$USDA_name)
# Other than lichens, there's nothing here...

# Okay. I have concluded that there is likely nothing we can use this data for.
