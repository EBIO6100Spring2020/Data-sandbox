Spring 2020 CU Boulder EBIO Ecological Forecasting Seminar
Project: NEON-Niwot forest species SDMs

This is a centralized location to organize our thoughts and resources for this project. Thoughts and data are focused on Niwot Ridge site, unless specified otherwise.

##### Scientific questions we could ask
1. How will carabid species distributions shift with global warming in a subalpine forest?  
1. Is there a shift in community composition through time at all in the NEON data available? For multiple sites, account for habitat and environmental differences. see Brooks et al. 2012 hyp1
1. Across NEON sites, do temporal community trends differ in magnitude and direction between habitats and regions? see Brooks et al. 2012 hyp2
1. Are community trends unique to combinations of habitats and regions? That is, might we expect species's responses to environmental change to be dictated mostly by habitat? see Brooks et al. 2012 hyp3
2. What are shifts in phenology of species through time? see Hoekman et al. 2017  
3. What is carabid community response to habitat and land-use change over time?  
4. What are shifts in phenology of species through time and across habitat? see Hoekman et al. 2017
5. Is fine-scale change in microhabitat heterogeneity more important to carabid abundance and richness than larger-scale changes in landscape diversity? Could more stable habitats (e.g. forest) buffer wider-scale perturbations? see Brooks et al. 2012



add more papers to the lit list
see 3 hypotheses from taht one paper
find carbid data on bold

##### Why carabids?
* identifying habitat associations in a dominant insect group would be an important step toward understanding the consequences of global climate change in high mountain areas  (Hiramatsu and Usio 2018)
* Because of their known sensitivity to changes in habitat structure and requisitly altered microhabitat, carabid beetles have been suggested to serve as useful bioindicators of environmental and land use change (Hiramatsu and Usio 2018)
* To date, numerous studies have shown that carabid beetle richness and/or assemblage composition change along altitudinal gradients [5–7] and/or with vegetation type [8–11] (Hiramatsu and Usio 2018)
* Remote sensing can measure carabid habitat at the local and landscape scales. Identifying the predictive relationships between beetle assemblages to remote sensing variables allows conservation managers to measure carabids at a scale appropriate for their biology and scale up to that which management decisions function (Muller et al. 2009).

##### Data products to use
* Response variable: carabid community abundance and composition  
    * Source: NEON carabid data at NIWO 2015-19  

| Predictor variable  | source | dpID | spatial distribution | temporal distribution | literature |
| ------------- | ----- | -------- | --------------------- | ---------- | ------------ |
| carabid richness & abundance | NEON | DP1.10022.001 | 4 traps per plot (10) at each terrestrial site, arrayed 20m from the center of the plot in each cardinal direction | 2015-2019, biweekly sampling during growing season | [NEON carabid data user guide](https://github.com/EBIO6100Spring2020/Data-sandbox/blob/master/docs/NEON_beetle_userGuide_vA.pdf) [Hoekman et al. 2017](https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecs2.1744) |
| carabid DNA barcode | NEON | DP1.10020.001 |  |  |  |
| slope/aspect | NEON | DP3.30025.001 |  |  |  |
| elevation | NEON | DP3.30024.001 |  |  |  | 
| precipitation | NEON | DP1.00006.001 |  |  |  | 
| relative humidity | NEON | DP1.00098.001 |  |  |  | 
| IR biological temp | NEON | DP1.00005.001 |  |  |  | 
| Shortwave radiation (direct and diffuse pyranometer) | NEON | DP1.00014.001 |  |  |  | 
| Shortwave and longwave radiation (net radiometer) | NEON | DP1.00023.001 |  |  |  | 
| LAI - spectrometer - flightline | NEON | DP2.30012.001 |  |  |  | 
| soil temp | NEON | DP1.00041.001 |  |  |  |
| Soil water content and water salinity | NEON | DP1.00094.001 |  |  |  | 
| Woody plant vegetation structure | NEON | DP1.10098.001 |  |  | [TOS Science Design for Plant Biomass and Productivity](https://data.neonscience.org/documents/10179/1723439/NEON.DOC.000914vA/b21f8a50-2f1e-4261-8890-3f922fd78141)| 
| Litterfall and fine woody debris sampling | NEON | DP1.10033.001 |  |  |  | 
| [Permanent forest plot data](https://portal.lternet.edu/nis/mapbrowse?packageid=knb-lter-nwt.207.3) | NiwotLTER | NA |  | 1982-2016 | [Chai et al. 2019](https://www.nrcresearchpress.com/doi/pdfplus/10.1139/cjfr-2019-0023) | 
| canopy gaps |  |  |  |  |  | 
| hydrology |  |  |  |  |  | 
| % canopy cover |  |  |  |  |  | 
| litterfall/woody debris |  |  |  |  |  | 
| surface temp |  |  |  |  |  | 
| microtopography |  |  |  |  |  | 
|  |  |  |  |  |  | 

| Miscellaneous data  | source | spatial distribution | temporal distribution |
| ------- | ----------------- | --------- | ---------- | 
| carabids | [carabids.org](https://www.carabids.org/portal/en-us/explore) | Europe, Africa, Asia |  |  
|  |  |  |  |  

##### Literature
* Plant diversity sampling design at NEON, [Barnett et al. 2019](https://esajournals.onlinelibrary.wiley.com/doi/epdf/10.1002/ecs2.2603)
* NEON design for ground beetle sampling [Hoekman et al. 2017](https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecs2.1744)
* Carabids in a Japanese Alpine-Subalpine Zone, [Hiramatsu and Usio 2018](https://www.hindawi.com/journals/psyche/2018/9754376/)
* Forest beetle assemblages and LiDAR, [Muller & Brandl 2009](https://besjournals.onlinelibrary.wiley.com/doi/epdf/10.1111/j.1365-2664.2009.01677.x)
    * LiDAR-derived variables: canopy height SD and max tree height at traps from DSM, mean altitude at trap from DTM, microclimaatic conditions proexy from laser penetration rate - see Table 2
    * decrease in body size with laser penetration ratio and larger species in closed forests
    * increase in activity of xylophagous species with an increase of the laser penetration ratio.
    * decrease in the activity of mycetophagous and phytophagous species with altitude because of a reduced availability of hosts. 
* The UK's ECN, kinda like the US's NEON [Brooks et al. 2012]()
    * largest population declines in montane habitat
* Forty years of carabid beetle research in Europe, [Kotze et al. 2011](https://zookeys.pensoft.net/article/2426/)
