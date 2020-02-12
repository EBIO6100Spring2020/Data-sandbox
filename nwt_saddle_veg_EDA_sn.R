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
  geom_point(aes(x = year, y = nobs,
                colour = species), size = 0.4)
  theme(legend.position = 'bottom')
# This plot isn't that helpful
# Subsample? Is there a spatial structure to plots?
# (Note readme says there's some variation in sampling design across time)

# Could also be worth looking at the trends over time in all other species?

#

veg.proc = veg.proc %>% filter(!grepl('^2', USDA_code))

veg.proc %>% filter(year %in% 1989) %>% distinct(USDA_name)

# What are the species that show up only after 2010?

head(veg.proc)
veg.proc %>%
  group_by(year) %>%
  summarise(n.spec = length(unique(USDA_code))) %>%
  ggplot() +
  geom_point(aes(x = year, y = n.spec))

# What are the factors which best explain the variation in Deschampsia (and/or Geum)
# Climate axis of most change in last ~25 yrs at NWT: things associated with extended summer
# e.g., greenup days, warmth of summer, season length, growing days 

# Look at relative strength and/or residual (after trend )

veg.proc %>%
  filter(USDA_code %in% c('DECE', 'GEROT', 'KOMY')) %>%
  group_by(year, USDA_code) %>%
  summarise(n = n()) %>%
  spread(key = USDA_code, value = n) %>%
  ggplot() +
  geom_line(aes(x = DECE, y = GEROT), colour = 'red') +
  geom_line(aes(x = DECE, y = KOMY), colour = 'blue') +
  ylab('Geum (red) Kobresia (blue)')

# Sampling intensity over time?
veg %>%
  distinct(year, plot, point, x, y) %>%
  group_by(year, plot) %>%
  summarise(n.samps = n()) %>%
  group_by(n.samps) %>%
  summarise(n = n())
# Every plot which is sampled is sampled completely

veg %>%
  distinct(year, plot) %>%
  group_by(plot) %>%
  summarise(times.sampled = n()) %>%
  group_by(times.sampled) %>%
  summarise(n = n())

veg.proc %>%
  group_by(year, hit_type) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = year, y = n, group = hit_type, colour = hit_type)) +
  geom_point(aes(x = year, y = n, colour = hit_type)) +
  geom_rug(aes(x = year, y = n), sides = 'b') +
  theme(legend.position = 'bottom') +
  guides(colour = guide_legend(nrow = 2)) +
  labs(x = 'Year', y = 'Number of records', size = 'Hit type') +
  ggsave('~/Documents/Research/boulder/poorcast_sandbox/poorcast_hit_type.png')

veg %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  filter(!year %in% 1996) %>%
  group_by(year, hit_type, USDA_code) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = year, y = n, group = hit_type, colour = hit_type)) +
  geom_point(aes(x = year, y = n, colour = hit_type)) +
  theme(legend.position = 'bottom') +
  facet_wrap(~ USDA_code)

# ? What predicts which cells an expanding species will expand into?

# For any bottom without a top, replace it with 'bottom' with 'top
# plot rel. abundance over time but also quantify/viz. standard error
# For these three species, only looking at 'top' hits
# ? Use a ML classification technique for communities?
# Snow depth as a proxy for community "type"
# Hope started in 2010

veg %>%
  filter(!hit_type %in% c('middle1', 'middle2')) %>%
  group_by(year, point) %>%
  mutate(n.top = sum(hit_type %in% 'top'),
         n.bottom = sum(hit_type %in% 'bottom')) %>%
  ungroup() %>%
  mutate(hit.new = ifelse(!n.top & 9, 'top', hit_type)) %>%
  View()
  # group_by(n.top, n.bottom) %>%
  # summarise(n = n())
  
# If you get rid of bare ground and middle, all should be top/bottom

veg.top = veg %>%
  filter(!hit_type %in% c('middle1', 'middle2')) %>%
  group_by(year, point) %>%
  mutate(n_hits = n()) %>%
  ungroup() %>%
  mutate(hit_new = ifelse(n_hits %in% 1, 'top', hit_type)) %>%
  filter(hit_new %in% 'top')

veg.top %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  group_by(year, USDA_code) %>%
  summarise(n.obs = n()) %>%
  ggplot(aes(x = year, y = n.obs)) + 
  geom_line(aes(group = USDA_code, colour = USDA_code)) +
  geom_point(aes(colour = USDA_code))
# That is wrong and bad

veg %>%
  filter(hit_type %in% 'top' & !(year %in% 1996)) %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  group_by(year, USDA_code) %>%
  summarise(n.obs = n()) %>%
  ggplot(aes(x = year, y = n.obs)) + 
  geom_line(aes(group = USDA_code, colour = USDA_code)) +
  geom_point(aes(colour = USDA_code))
# That is wrong and bad

####

# February 11, 2020
# Problem: protocol appears to have changed. 
# To get consistency across years, we want to regularize the type of data we use as much as possible.
# The census procedure changed in a way which may explain all of our counts are increasing.

# Here is a plot of raw data for all three species (subtracting 1996)
# Where the type of hit is classified by hit type

veg %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  filter(!year %in% 1996) %>%
  group_by(year, hit_type, USDA_code) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = year, y = n, group = hit_type, colour = hit_type)) +
  geom_point(aes(x = year, y = n, colour = hit_type)) +
  theme(legend.position = 'bottom') +
  facet_wrap(~ USDA_code)

# So: looks like the number of top hits has increased over time.
# Generally, we see more bottom- than top hits pre 2006 (?)
# while there are more top than bottom hits post-2006
# Also, aside from 1990 (where there are hardly any records),
# both middle-hit categories are new in the year 2006.

# Ideas:
# First, junk all of the middle hits.
# Second, look at the combined top- and bottom- hits and see
# if they are constant over time (maybe??)


veg %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  filter(!year %in% 1996) %>%
  filter(hit_type %in% c('bottom', 'top')) %>%
  group_by(year, hit_type, USDA_code) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = year, y = n, group = hit_type, colour = hit_type)) +
  geom_line(data = . %>%
              group_by(year, USDA_code) %>%
              summarise(all.hits = sum(n)),
            aes(x = year, y = all.hits, group = USDA_code), 
            colour = 'black') +
  geom_point(aes(x = year, y = n, colour = hit_type)) +
  geom_point(data = . %>%
              group_by(year, USDA_code) %>%
              summarise(all.hits = sum(n)),
            aes(x = year, y = all.hits), 
            colour = 'black') +
  theme(legend.position = 'bottom') +
  facet_wrap(~ USDA_code)

# Within a year (or even within a year-grid point??, and/or within a  year-plot) how often are things listed... more than once?
# (probably not likely to see it within a grid point due to sampling)

# (I checked - no plant shows up more than once for a given point)

veg.space.hits = veg.proc %>%
  filter(USDA_code %in% c('GEROT', 'DECE', 'KOMY')) %>%
  group_by(USDA_code, year, plot, hit_type) %>%
  summarise(n.hits = n())

View(veg.space.hits)

# Look only at bottom + top
veg.space.hits %>%
  filter(hit_type %in% c('bottom', 'top')) %>%
  ggplot(aes(x = year, y = n.hits)) +
  geom_line(aes(group = interaction(USDA_code, hit_type),
                colour = USDA_code), size = 0.1) +
  geom_point(aes(colour = USDA_code, shape = hit_type), size = 0.1) +
#  scale_linetype_manual(values = 2:3) +
  theme(strip.text.x = element_blank()) +
  guides(colour = 'none', shape = 'none') +
  facet_wrap(~ plot) +
  ggsave('~/Documents/Research/boulder/poorcast_sandbox/allplots_tbhits.png',
         width = 6, height = 6, units = 'in')

# Interesting... looks like there are plenty of places where there are top and bottom?

# Here, look at how many year-plot combos in which a hit-type appears for each species
# (e.g., a 3 means in the same plot in the same year, species were observed at
# three different hit types)
veg.space.hits %>%
  group_by(USDA_code, year, plot) %>%
  summarise(n.hit.type = n()) %>%
  group_by(USDA_code, n.hit.type) %>%
  summarise(n = n()) %>%
  spread(key = USDA_code, value = n) 
#   n.hit.type  DECE GEROT  KOMY
#         <int> <int> <int> <int>
# 1          1   164   159    71
# 2          2   263   419   107
# 3          3   177   502   136
# 4          4    10    40    16

# Do the above but normalize by columns
veg.space.hits %>%
  group_by(USDA_code, year, plot) %>%
  summarise(n.hit.type = n()) %>%
  group_by(USDA_code, n.hit.type) %>%
  summarise(n = n()) %>%
  spread(key = USDA_code, value = n) %>%
  mutate_at(vars(DECE, GEROT, KOMY), function(x) x / sum(x))
#   n.hit.type   DECE  GEROT   KOMY
#         <int>  <dbl>  <dbl>  <dbl>
# 1          1 0.267  0.142  0.215 
# 2          2 0.428  0.374  0.324 
# 3          3 0.288  0.448  0.412 
# 4          4 0.0163 0.0357 0.0485

# Okay... 75-90% of the time, a plant shows up as multiple hit types

# Do the above, but with only top and bottom hits
veg.space.hits %>%
  filter(hit_type %in% c('top', 'bottom')) %>%
  group_by(USDA_code, year, plot) %>%
  summarise(n.hit.type = n()) %>%
  group_by(USDA_code, n.hit.type) %>%
  summarise(n = n()) %>%
  spread(key = USDA_code, value = n)
#   n.hit.type  DECE GEROT  KOMY
#         <int> <int> <int> <int>
# 1          1   243   215    96
# 2          2   363   897   229

# Argh... so a lot of the time, (>50%), a plant shows up 
# in the same plot as both hit types during the same survey!

# I think we should just take top and bottom hits only
# Read the protocols! Ugh.
# Protocol says that 1990 - 1997 had no middle-point sampling,
# But 2006 and onward did.
# Protocol (.docx file in folder) also says data from pre-2011 should be
# considered preliminary.

# Idea:
# Just look at 2006-data and onward
# This _should_ have all hit-types in each year
# But is it enough data to actually forecast?
# Probably not.

veg %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  filter(year > 2005) %>%
  group_by(year, hit_type, USDA_code) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = year, y = n, group = hit_type, colour = hit_type)) +
  geom_line(data = . %>%
              group_by(year, USDA_code) %>%
              summarise(all.hits = sum(n)),
            aes(x = year, y = all.hits, group = USDA_code), 
            colour = 'black') +
  geom_point(aes(x = year, y = n, colour = hit_type)) +
  geom_point(data = . %>%
               group_by(year, USDA_code) %>%
               summarise(all.hits = sum(n)),
             aes(x = year, y = all.hits), 
             colour = 'black') +
  theme(legend.position = 'bottom') +
  facet_wrap(~ USDA_code)

# Some notes:
# - 2006 is the only hear with more bottom- than top hits
# and in general the number of bottom hits increases over time
# - Middle2 hits don't start until 2010
# - Geum is going gangbusters, with an increasing number of middle hits
# (although the number of bottom hits is falling...)
# - Number of top hits seems to correlate very well with overall # hits.

# Another idea:
# Looking at Spasojevic et al., 2013 (Ecosphere), they look at -only- the top-
# level hits (they say they do this to regularize the data across sampling periods)
# Notably, a plot above (featured in the slide deck) demonstrated that the number of 
# top hits was fairly constant over time. Should we just do that instead?

veg.proc %>%
  filter(USDA_code %in% c('KOMY', 'GEROT', 'DECE')) %>%
  filter(hit_type %in% 'top') %>%
  filter(!year %in% 1996) %>%
  group_by(year, USDA_code) %>%
  summarise(n.hits = n()) %>%
  ggplot(aes(x = year, y = n.hits)) +
  geom_line(aes(colour = USDA_code, group = USDA_code)) +
  geom_point(aes(colour = USDA_code)) +
  theme(legend.position = 'bottom')

# Hmm... all of these are pretty steadily increasing. Is that "real"?
# (i.e. is it biological?)
# Can figure this out (perhaps) by comparing with other species.

veg.proc %>%
  # Make column for "non-lichen plant"
  mutate(nl.plant = !USDA_code %in% c('2RF', '2LICHN', '2X', '2LTR',
                                      '2BARE', '2UNKSC', '2HOLE',
                                      '2RF', '2BARE')) %>%
  # Now make a column for "plant of interest"
  mutate(plant.sp = ifelse(USDA_code %in% c('KOMY', 'GEROT', 'DECE'),
                           as.character(USDA_code), 
                           ifelse(nl.plant, 'other', 'non-plant'))) %>%
  filter(hit_type %in% 'top') %>%
  filter(!year %in% 1996) %>%
  group_by(year, plant.sp) %>%
  summarise(n.hits = n()) %>%
  ggplot(aes(x = year, y = n.hits)) +
  geom_line(aes(colour = plant.sp, group = plant.sp)) +
  geom_point(aes(colour = plant.sp)) +
  theme(legend.position = 'bottom')

veg.proc %>%
  # Make column for "non-lichen plant"
  filter(!USDA_code %in% c('2RF', '2LICHN', '2X', '2LTR',
                           '2BARE', '2UNKSC', '2HOLE',
                           '2RF', '2BARE')) %>%
  # Now make a column for "plant of interest"
  mutate(plant.sp = ifelse(USDA_code %in% c('KOMY', 'GEROT', 'DECE'),
                           as.character(USDA_code), 
                           'other')) %>%
  filter(hit_type %in% 'top') %>%
  filter(!year %in% 1996) %>%
  group_by(year, plant.sp) %>%
  summarise(n.hits = n()) %>%
  group_by(year) %>%
  mutate(all.hits = sum(n.hits),
         prop.hits = n.hits / all.hits) %>%
  ggplot(aes(x = year, y = prop.hits)) +
  geom_line(aes(colour = plant.sp, group = plant.sp)) +
  geom_point(aes(colour = plant.sp)) +
  theme(legend.position = 'bottom') +
  ggsave('~/Documents/Research/boulder/poorcast_sandbox/all_sp_compositional.png')

# That looks okay!
