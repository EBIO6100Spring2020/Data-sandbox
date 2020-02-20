# Meeting with Courtney
##### February 18, 2020
##### Present: Scott, Tom, Courtney

Courtney (post-doc in Katie Suding's lab) worked with the Niwot Ridge saddle plant composition dataset. The main output she came up with is a joint species distribution model (JSDM) with the ~16 most common plant species in the saddle. She used the saddle dataset we have been looking at and combined it with annual snowmelt measurements (?) and some other odds-and-ends environmental data from the Niwot EDI portal (online). The JSDMs were fit using the HMSC package in R.

This procedure first partitioned variance in the abundance of each species into contributions from each of several environmental factors (note: she did not trim the environmental variables to account for any possible correlations). The remaining variance was attributable to "plot" (fit as a random effect in the model). Under the assumption that all possible environmental varaibles were included in the model, the "plot"-level residuals are variance due to biotic competition. Courtney took these residuals and ran correlations among species; the sign of the correlation can be interpreted as facilitation (positive) or competition (negative, but see Zurell et al., 2018, Ecography) and the magnitude can be interpreted as the strength of the interaction.

We met with Courtney to discuss her work and talk about future directions with this dataset. Here are some notes from the meeting.

### Other possible data sources

Courtney looked thoroughly for data relevant to the saddle, and there wasn't very much that we hadn't already looked at.

One data source which we have not looked into yet is Skip Walker's soil measurements from 1993. Scott also deposited some soil data from 1990 and 1993 (although this is apparently different) in the repository but so far nobody has explored it.

### Which climate variables are important?

##### Refitting the JSDM and other approaches

It may be worth trimming down the JSDM to include only our three focal species. This may change the model output slightly; run and check to make sure it isn't wildly different from Courtney's output. The estimates here of effects of abiotic effects should be valid and perhaps more precise. But, be wary of overinterpreting biotic interaction strenghts from these, as this is often unsatisfying.

But, these models are quite unweildy to run and have a lot going on. It may be simpler, easier to interpret, and just as valid to fit a ton of single-species linear models with different combinations of environmental variables and compare with AIC (or some other test). Caitlin recommended the package AICtab.

##### A good strategy for fitting these models

We will likely be using the CLM for projections, using its model outputs as environmental covariates. So, we might want to fit estimate abiotic effects *specifically for environmental variables which we know the CLM can produce.* We should absolutely talk with Will Wieder (sp?) about what the CLM can provide for our models. We may also be able to back-predict these climate variables to get covariates for fitting JSDMs/LMMs for estimating environmental influences on plant abundances. But we should be careful about doing this, because we don't know how accurate (or precise) these estimates may be.

### Handling distinct community types

Spasojevic et al., 2013 (the Ecosphere paper) found distinct community types. With few environmental predictors, variance attributed to biotic interactions may just be the result of these distinct community types. Note that Courtney's model had plot as a random effect; this could pick up some of this community-type variation.


### Some papers on joint species distribution models

Pollock et al., 2014. "Understanding co-occurrence by modeling species simultaneously..." MEE
https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.12180

Ovaskainen et al., 2017. "How to make more out of community data..." Ecology Letters.
https://onlinelibrary.wiley.com/doi/full/10.1111/ele.12757

Warton et al., 2015. "So many variables: Joint modeling in community ecology." TREE
https://www.sciencedirect.com/science/article/pii/S0169534715002402?via%3Dihub

Harris, 2018. "Generating realistic assemblages with a joint species distribution model". MEE
https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.12332

Zurell et al., 2018. "Do joint species distribution models reliably detect..." Ecography.
https://onlinelibrary.wiley.com/doi/full/10.1111/ecog.03315

Tikhonov et al., 2019. R Package HMSC.
https://cran.r-project.org/web/packages/Hmsc/index.html

### Quick follow up on GEUM-DECE competition
Talking to katie post meeting about whether competition is important between the two dominants. She noted that in an experiment where either DECE or GEUM was removed the other one increased in abundance. She also suggested we look at this Farrer et al paper. 

Farrer, Emily C., et al. "Separating direct and indirect effects of global change: a population dynamic modeling approach using readily available field data." Global change biology 20.4 (2014): 1238-1250.
https://onlinelibrary.wiley.com/doi/full/10.1111/gcb.12401
