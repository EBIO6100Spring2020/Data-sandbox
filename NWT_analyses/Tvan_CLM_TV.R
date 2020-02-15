# Quick plots of vegetation and soil temp
# Simulations published w/ NWT data, 
# doi:10.6073/pasta/af61bdace4752ebf0c467deaafc81026
# Paper Wieder et al. 2017 JGR-Biogeosciences

rm(list=ls())
library(ncdf4)
library(boot)
library(REddyProc)
library(lattice)

# List of experiments to look at:
# These will change based on your working environment & 
# also be modifed by the the structure of data downloaded from LTER data portal

dir            <- ('/Users/wwieder/Desktop/Working_files/Niwot/NR_fluxes/TVan/Tvan_PTCLM45/')
path     <- paste(dir,'CLM_nc_files/PTrespmods/lowWATSAT/',sep='')
pre      <- ('Tvan_PTrespmods_allPHYS_noLW_lowVCmax_')
suf      <- ('_lowRESIST_run.clm2.h1.2008-01-01-00000.nc')
case     <- c('010dry_ff_noRHpsn_lowWATSAT','010dry_dm_noRHpsn_lowWATSAT',
              '100_mm_noRHpsn','075_wm_noRHpsn',
              '200_sb_noRHpsn_lowWATSAT')
nrows  <- length(case)
nyears <- 6
ndays  <- 365 * nyears + 2
nlevsoi <- 25
dims    <- c(nrows,ndays)
dims2   <- c(nrows,nlevsoi,ndays)

years    <- seq(2008,2013,1)
nyears   <- length(years)

#create arrays to store annual data  
rows     <- c('FF', 'DM', 'MM', 'WM', 'SB')
nrows    <- length(rows)
cols     <- c(as.character(years))
dims     <- c(nrows,nyears)
TV_a     <- array(NA,dim=dims,dimnames=list(rows,cols)) 
TSOI_a   <- array(NA,dim=dims,dimnames=list(rows,cols)) 
PPT_a    <- array(NA,dim=dims,dimnames=list(rows,cols)) 
SNOW_a   <- array(NA,dim=dims,dimnames=list(rows,cols)) 
H2OSOI_a <- array(NA,dim=dims,dimnames=list(rows,cols)) 
QRUNOFF_a<- array(NA,dim=dims,dimnames=list(rows,cols)) 
SNOW_DEPTH_a <- array(NA,dim=dims,dimnames=list(rows,cols)) 
#-----------------------------------------------------------------------
#---------------read in CLM variables----------------------------------
#-----------------------------------------------------------------------
dir <-  '/Users/wwieder/Desktop/Working_files/Niwot/NR_fluxes/TVan/Tvan_PTCLM45/CLM_nc_files/bgc/froot4x/'
e <- 1
for (e in 1:nrows) {
  infile   <- paste(path,pre,case[e],suf,sep='')
  Data.clm <- nc_open(infile)   
  print(paste('read',infile))  

#  print(paste("The file has",Data.clm$nvars,"variables"))
#  summary(Data.clm)
  print(Data.clm)
 
  MCDATE         = ncvar_get(Data.clm, "mcdate") # getting/naming the variable
  MCSEC          = ncvar_get(Data.clm, "mcsec") 
  TV          = ncvar_get(Data.clm, "TV") 
  TSOI           = ncvar_get(Data.clm, "TSOI") 
  H2OSOI         = ncvar_get(Data.clm, "H2OSOI")	     	#Volumetric soil moisture
  QRUNOFF        = ncvar_get(Data.clm, "QRUNOFF")    	#liquid runoff (does not include QSNWCPICE)
  SNOW   		     = ncvar_get(Data.clm, "SNOW")       
  RAIN     	     = ncvar_get(Data.clm, "RAIN")       
#  SNOWDP 		     = ncvar_get(Data.clm, "SNOWDP")       #gridcell mean snow
  SNOW_DEPTH     = ncvar_get(Data.clm, "SNOW_DEPTH")	#snow height of snow covered area
  TSOIunits<- ncatt_get(Data.clm, "TSOI", "units")
  TSOIunits
  TVunits<- ncatt_get(Data.clm, "TV", "units")
  TVunits
  QRUNOFFunits<- ncatt_get(Data.clm, "QRUNOFF", "units")
  QRUNOFFunits
  H2OSOIunits <- ncatt_get(Data.clm, "H2OSOI", "units")
  H2OSOIunits
  PRECIP       <- RAIN + SNOW
  paste('mean Runoff', mean(QRUNOFF)* 3600 * 24 * 365, 'mm/y')
  paste('mean Precip', mean(PRECIP) * 3600 * 24 * 365, 'mm/y')
  paste('max Snow_Depth' , max(SNOW_DEPTH), 'm')

  
  day2 <- as.Date.character(MCDATE, format='%Y%m%d')
  year <- format(day2,format='%Y')
  mo   <- as.numeric(format(day2,format='%m'))
  doy  <- as.numeric(strftime(day2,format='%j'))

  PPT_a[e,]    <- (tapply(PRECIP*30*60,year, sum) )[1:nyears]       #'mm/y'
  SNOW_a[e,]   <- (tapply(SNOW*30*60,  year, sum) )[1:nyears]       #'mm/y'
  SNOW_DEPTH_a[e,] <- (tapply(SNOW_DEPTH, year, max))[1:nyears]         #'m'
  QRUNOFF_a[e,]<- (tapply(QRUNOFF*30*60, year, sum) )[1:nyears] #'mm/y'

  #  daily sums for plots
  snow_depth <- (tapply(SNOW_DEPTH,day2,mean))   #'m'
  tsoi_2 <- (tapply(TSOI[2,],day2,max))   #'K', here for 2nd soil layer
  tsoi_3 <- (tapply(TSOI[3,],day2,max))   #'K', here for 3rd soil layer
  tv     <- (tapply(TV,day2,max))     #'K'
  Dtemp2 <- tv - tsoi_2
  Dtemp3 <- tv - tsoi_3
  
  dy     <- (tapply(as.numeric(year),day2, mean)) 

  fout <- paste(dir,'figs/TV-TSOI_',rows[e],'.pdf',sep='')
  pdf(fout)
  par(mfrow=c(2,1), mar=c(4,5,2,1))
  for(y in 1:1) {
    if (y==1) { 
      plot(tsoi_3[dy==years[y]],type="l", col='brown', lty=2,
           ylim=c(270,320),main=rows[e], ylab="Temperature (K)",
           xlim=c(150,250),xlab=NA) 
      legend('bottomright', col=c('brown',"brown","darkgreen"), 
             legend=c("soil_2","soil_3","Veg"), lty=c(1,2,1), lwd=3,bty='n')
    } 
    lines(tsoi_2[dy==years[y]], type="l", col='brown', lwd=3)
    lines(tsoi_3[dy==years[y]], type="l", col='brown', lwd=3,lty=2)
    lines(tv[dy==years[y]], type="l", col='darkgreen', lwd=3)
  }
  for(y in 1:1) {
    if (y==1) { 
      plot(Dtemp3[dy==years[y]],type="l", lty=0,
           ylim=c(-10,25),main=paste('maxVeg-maxSoil',rows[e]), 
           ylab='Veg - soil',xlim=c(150,250), xlab=NA) 
      legend('topright', col=1, legend=c("soil_2","soil_3"), lty=c(1,2), lwd=3,bty='n')
      abline(h=0, lty=2)
    } 
    lines(Dtemp2[dy==years[y]], type="l", lwd=3)
    lines(Dtemp3[dy==years[y]], type="l", lwd=3,lty=2)
  }
    
  dev.off()
}