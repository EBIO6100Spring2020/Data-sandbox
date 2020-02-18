# Script to explore NWT Nitrogen experiment data
# SN 2020 Feb 17

library(ggplot2)
library(dplyr)
library(tidyr)

soilr = read.csv('data_raw/plant_competition/n_p_expmt/fertcovr.tt.data.csv')
soils = read.csv('data_raw/plant_competition/n_p_expmt/fertcovs.tt.data.csv')

head(soilr)
# fields: date, plot_code, spp_code + USDA name, num_hits (in plot), cover (pct?)

nrow(soilr)
# 7198 rows

soilr$date %>% as.character() %>% 
  (function(x) x %>% strsplit('\\D') %>% sapply(function(x) x[1])) %>% 
  table()
# 1990 1991 1992 1993 1994 1995 1996 1998 2000 
# 572  766  884  874  814  890  822  567 1009
# No records in 1997, 1999

table(soilr$spp_code)
# KOBMYO 250, ACOROS (=GEROT) 235, DESCAE 142

table(soilr$plot_code)
# DCC1 DCC2 DCC3 DCC4 DCC5 DNN1 DNN2 DNN3 DNN4 DNN5 DNP1 DNP2 DNP3 DNP4 DNP5 
# 221  242  256  246  247  254  261  235  278  250  255  251  270  271  296  
# DPP1 DPP2 DPP3 DPP4 DPP5 WCC1 WCC2 WCC3 WCC4 WCC5 WNN1 WNN2 WNN3 WNN4 
# 234  266  247  308  260   86  100  123  111   93   88   93   99  107 
# WNN5 WNP1 WNP2 WNP3 WNP4 WNP5 WPP1 WPP2 WPP3 WPP4 WPP5 
# 106   65   95  112  109   96   99  118  116  106  128 

# Not sure what these are? NN, NP, PP, CC are probably N only,
# P only, N and P, and control, D and N are blocks?

# soil s dataset
head(soils)
# This appears to be coverage data.

# Hmm. Hoo boy.
# Protocol says something about plots being established in two different commmunities.
# Assuming that "d" and "w" are "dry" and "wet"...
# Both are on the south side.
# Assume that numbers are replicates.

# Here, come up with a normalized number of hits.
# (Proportion of hits in a plot which belong to each species)
# (Normalized by number of living hits)
soil.all = soilr %>% 
  filter(!spp_code %in% c('ARTSPP', 'BAREEE', grep('^DEAD', spp_code, value = TRUE), 'LITTER', 'ROCKKK', 'SCATT')) %>%
  group_by(date, plot_code) %>%
  mutate(plot_hits = sum(num_hits),
         prop_hits = num_hits / plot_hits,
         year = date %>% as.character() %>% 
           (function(x) strsplit(x, '\\D') %>% 
              sapply(function(x) x[1])) %>%
           as.integer(),
         treatment = gsub('^[DW]|\\d', '', plot_code),
         comtytype = strsplit(as.character(plot_code), '') %>% sapply(function(x) x[1]))

# Plot relative abundances of each species over time,
# by treatment type
soil.all %>%
  filter(spp_code %in% c('KOBMYO', 'ACOROS', 'DESCAE')) %>%
  ggplot(aes(x = factor(year), y = prop_hits)) +
  geom_line(aes(group = interaction(plot_code, spp_code), 
                linetype = comtytype,
                colour = spp_code)) +
  facet_wrap(~ treatment)
# Are some plot-species discontinued...?

with(soil.all, table(year, plot_code))
# The wet plots weren't surveyed in 1998, 2000

soil.all %>%
  filter(spp_code %in% c('KOBMYO', 'ACOROS', 'DESCAE')) %>%
  filter(year < 1998) %>%
  ggplot(aes(x = factor(year), y = prop_hits)) +
  geom_line(aes(group = interaction(plot_code, spp_code), 
                linetype = comtytype,
                colour = spp_code)) +
  facet_wrap(~ treatment)

# Looks to me like Nitrogen addition makes KOMY nosedive
# DECE increases with Phosphorous addition but not N+P
# DECE appears predominantly where it's wet,
# KOMY and GEROT appear where it's dry

# Read:
# Theodose and Bowman, 1997, Ecology

# , mycorrhizal forbs increased with N+P fertilization, nonmycorrhizal forbs
# increased with P and N+P, and N2‐fixing forbs increased with P alone. Grasses
# increased with N and N+P, whereas sedges, the dominant functional group, were
# unaffected by fertilization. In the wet meadow, the dominant sedges exhibited
# abundance increases in response to N, whereas grasses increased with P and
# N+P. Wet‐meadow forb abundance was not significantly influenced by
# fertilization.
