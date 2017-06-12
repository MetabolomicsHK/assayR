#system(paste('msconvert --mzML --simAsSpectra --filter "peakPicking true 1-" --filter "polarity -"',rawfile))

path <- "C:/Users/Jimi/Desktop/data/finch-lab/Jimi_2016-06-22_MetabolicFlux_P6VPL1C"
file <- "01_n1-5minutepulse1.mzML"
mzxml <- paste(path, file, sep="/")


aa <- openMSfile(mzxml, backend = "pwiz")
runInfo(aa)
instrumentInfo(aa)
header(aa,1)
pl <- peaks(aa,10)
peaksCount(aa,10)
head(pl)
plot(pl[,1], pl[,2], type="h", lwd=1)
