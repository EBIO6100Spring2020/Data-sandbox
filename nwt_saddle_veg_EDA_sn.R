# Script to explore vgetation data
# SN 2020 Feb 4

library(ggplot2)
library(dplyr)
library(tidyr)

# Read in vegetation dataset
veg = read.csv('data_raw/plant_competition/vegetation_sampling/saddptqd.hh.data.csv')

head(veg)
nrow(veg) # 220K records

# How often is each year represented?
table(veg$year)
# 1989  1990  1995  1996  1997  2006  2008  2010  2011  2012  2013  2014  2015  2016  2017  2018 
# 9600 11771 12249   195 11535 13274 15521 15513 15801 15320 15641 15919 16948 17117 17299 17473

# 1996 is way undersampled - remove
veg.proc = veg %>% filter(!year %in% 1996)

# Which species are represented?
table(veg.proc$USDA_name) %>% sort(decreasing = TRUE)
# 42825 records of litter
# 24814 records of Geum rossii
# 15772 records of Kobresia myosuroides
# 13510 records of Deschampsia cespitosa
# 8696 records of lichen
# 8653 records of Trifolium parryi

table(veg.proc$USDA_name) %>% sort(decreasing = TRUE) %>% plot()
# Actually a good number of well-represented species

# Let's get time-serieses of the the most-common species
veg.proc %>%
  filter(USDA_code %in% c('GEROT', 'KOMY', 'DECE')) %>%
  group_by(USDA_code, year) %>%
  summarise(n.records = n()) %>%
  ggplot() +
  geom_line(aes(x = year, y = n.records, colour = USDA_code, group = USDA_code)) +
  geom_point(aes(x = year, y = n.records, colour = USDA_code))

# Gaps in early 2000s - after this period, increase in all three species
# Well-sampled in 2010s, increasing density of all three species

# Look at correlation across years
veg.proc %>%
  filter(USDA_code %in% c('GEROT', 'KOMY', 'DECE')) %>%
  group_by(USDA_code, year) %>%
  summarise(n.records = n()) %>%
  spread(key = USDA_code, n.records) %>%
  select(-year) %>%
  cor() %>%
  round(3)

# Yep - highly correlated (guess we could have just figured this out from the plot lulz)

# Let's look at spatial arrangement. First, look just at the layout of plots.
veg.proc %>%
  distinct(x, y) %>%
  ggplot() +
  geom_point(aes(x = x, y = y))
# Okay. It is a grid.

veg.proc %>%
  group_by(year, plot, x) %>%
  summarise(n.records = n())
# Okay, there is one x,y coord system per plot
# How many plots?

veg.proc$plot %>% table()
with(veg.proc, table(year, plot))
# Okay damn there are a lot of plots. Well-sampled.

# How to assess spatial cooccurrence? Among plots, just pull up presence/absence
# (or density) for each plot.

plot.density.by.year = veg.proc %>%
  filter(USDA_code %in% c('GEROT', 'KOMY', 'DECE')) %>%
  group_by(year, plot, USDA_code) %>%
  summarise(n.records = n()) %>%
  spread(key = USDA_code, value = n.records) %>%
  mutate_at(c('DECE', 'GEROT', 'KOMY'), function(x) ifelse(is.na(x), 0, x)) %>%
  ungroup()

plot.density.by.year %>% select(DECE, GEROT, KOMY) %>% cor()
# Negative correlation between KOMY and DECE,
# slight correlation between KOMY and GEROT, 
# slight positive correlation between DECE and GEROT

# How to plot?
# Maybe just look at time series of occurrences within plots
plot.density.by.year %>%
  gather(key = species, value = nobs, -c(year, plot)) %>%
  ggplot() +
  geom_line(aes(x = year, y = nobs, group = interaction(plot, species),
                colour = species), alpha = 0.4) +
  theme(legend.position = 'bottom')
# This plot isn't that helpful
# Subsample? Is there a spatial structure to plots?
# (Note readme says there's some variation in sampling design across time)

# Could also be worth looking at the trends over time in all other species?