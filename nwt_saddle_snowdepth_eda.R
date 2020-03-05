# First-pass check of Niwot Saddle snow statistics
# SN 3 March 2020

library(ggplot2)
library(dplyr)
library(tidyr)

snowdep = read.csv('~/repos/poorcasting-real/00_raw_data/snowdepth_all/saddsnow.dw.data.csv')

head(snowdep)

nrow(snowdep)
# 35.5K rows

table(snowdep$local_site)
# All observations are at the saddle.

table(snowdep$point_ID)
# Yeah, good. Okay.
# NOTE: acc'd to metadata, 101, 201, etc. are same as 10A, 20A, etc.

# What is the quality of the depth column?
hist(snowdep$mean_depth)
# Good.
sum(is.na(snowdep$mean_depth))
# Okay. There are 332 bad records... what are they?

snowdep %>%
  filter(is.na(snowdep$mean_depth))
# Hmm..

# READ THE README

# Add a year column.
snowdep = snowdep %>%
  mutate(year = date %>% as.character() %>% strsplit(split = '\\-') %>%
           sapply(function(x) x %>% unlist() %>% (function(y) as.numeric(y[1]))),
         month = date %>% as.character() %>% strsplit(split = '\\-') %>%
           sapply(function(x) x %>% unlist() %>% (function(y) as.numeric(y[2]))),
         dayofyear = date %>% as.character() %>% strsplit(split = '\\-') %>%
           sapply(function(x) x %>% unlist() %>% (function(y) as.numeric(y[3]))))

# Did it work?
table(snowdep$year)
# yes.

snowdep %>%
  group_by(point_ID, year) %>%
  summarise(nobs = n(),
            totmeas = sum(num_meas))

# Sampling effort appears to be inconsistent...

# Look at the sampling dates
snowdep %>%
  distinct(date)

# This poses a problem. How to handle differences in sampling when the timing of snow is also inconsistent??

snowdep %>%
  distinct(month, year)
# Actually this looks okay. Looks like there is sampling in every month with snow.

# How many times per month does sampling happen?

snowdep %>%
  group_by(point_ID, year, month) %>%
  summarise(nobs = n(),
            totmeas = sum(num_meas))
# Looks like mostly ones and twos
# Confirm this.
snowdep %>%
  group_by(point_ID, year, month) %>%
  summarise(nobs = n()) %>%
  group_by(nobs) %>%
  summarise(n = n())
# Wtf! 440 times there are five samples in a month?
# Maybe take the minimum/max? See below.

# Maybe pick one year and see what it looks like.

snowdep %>%
  filter(year %in% 1993) %>%
  distinct(point_ID, month, .keep_all = TRUE) %>%
  ggplot() + 
  geom_line(aes())


# Okay. We have inconsistencies across year,
# 
snowdep.one.month = snowdep %>%
  select(point_ID, year, month, dayofyear, mean_depth) %>%
#  distinct(year, month, dayofyear, .keep_all = TRUE) %>%
  arrange(year, month, dayofyear) %>%
  distinct(point_ID, year, month, .keep_all = TRUE) %>%
  mutate(mean_depth = ifelse(is.na(mean_depth) | is.nan(mean_depth), 0, mean_depth))

table(snowdep.one.month$point_ID)
# 404 measurements here for each point. This is good!

# Aggregate by growing season... but need to define growing season
snowdep.one.month %>%
  group_by(point, year) %>%

