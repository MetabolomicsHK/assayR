#system(paste('msconvert --mzML --simAsSpectra --filter "peakPicking true 1-" --filter "polarity -"',rawfile))

library(mzR)






path <- "C:/Users/Jimi/Desktop/data/farhat-lab/Asta_2017-05-11_MetabolicFlux_Q33PL1J/mzMLneg"
file <- "02_not-treated-1.mzML"
mzxml <- paste(path, file, sep="/")

tic.file(file, 146,147, path)


logmass <- function(mz, int, ppm.resolution){
    base = 1 + ppm.resolution/1e6
    logmzbin <- round(log(mz,base),digits = 0)
    aggregate(int, by=list(Category=logmzbin), FUN=sum)

}

convert.ms.files.to.lcms.files <- function(
        path.to.ms.files = '.',
        pattern = '.mzML',
        ppm.resolution = 1,
    ){
    files <- list.files(path = path.to.ms.files, pattern = pattern,
                        full.names = TRUE, recursive = TRUE, ignore.case = TRUE)
    dim(files) <- length(files)
    cat("Collecting runInfo...")
    runInfos <- as.data.frame(t(apply(files, 1, function(f){
        aa <- openMSfile(f)
        ri <- unlist(runInfo(aa))
        close(aa)
        return (ri)
    })))
    runInfos$meanScanLength <- runInfos$dEndTime/runInfos$scanCount
    runInfos$filepath <- files
    cat("Filtering out any files with msLevels > 1...\n")
    runInfos <- runInfos[runInfos$msLevels==1,]
    print(runInfos)
    meanScanLength <- mean(runInfos$meanScanLength)
    relRngScanLength <- (max(runInfos$meanScanLength) - min(runInfos$meanScanLength))/mean(runInfos$meanScanLength)
    relRngscanCount <- (max(runInfos$scanCount) - min(runInfos$scanCount))/mean(runInfos$scanCount)
    relRngEndTime <- (max(runInfos$dEndTime) - min(runInfos$dEndTime))/mean(runInfos$dEndTime)
    relRngLowMz <- (max(runInfos$lowMz) - min(runInfos$lowMz))/mean(runInfos$lowMz)
    relRngHighMz <- (max(runInfos$highMz) - min(runInfos$highMz))/mean(runInfos$highMz)
    maxLowMZ <- max(runInfos$lowMz)
    minHighMZ <- min(runInfos$highMz)

    # print some info
    cat(paste("meanScanLength",meanScanLength,"\nrelRngScanLength",relRngScanLength,
              "\nrelRngscanCount",relRngscanCount,"\nrelRngEndTime",relRngEndTime,
              "\nrelRngLowMz",relRngLowMz,"\nrelRngHighMz",relRngHighMz,
              "\n"))

    # print some warnings if files look significantly different
    if(relRngScanLength > 0.1){
        cat("WARNING: Scan Length Relative Range > 10% - are you sure these files are comparable?\n")
    }
    if(relRngscanCount > 0.1){
        cat("WARNING: Scan Count Relative Range > 10% - are you sure these files are comparable?\n")
    }
    if(relRngEndTime > 0.1){
        cat("WARNING: End Time Relative Range > 10% - are you sure these files are comparable?\n")
    }
    if(relRngLowMz > 0.1){
        cat("WARNING: Scan Low M/Z Relative Range > 10% - are you sure these files are comparable?\n")
    }
    if(relRngHighMz > 0.1){
        cat("WARNING: Scan High M/Z Relative Range > 10% - are you sure these files are comparable?\n")
    }

    binCount <- log(minHighMZ, 1+ppm.resolution/1e6) - log(maxLowMZ, 1+ppm.resolution/1e6) + 1
    cat("Bin Count: ", binCount, "\n")

    # now we can open each file and do stuff with it...
    # we want to make a frame of logarithmic mz binned xics with regular rt intervals


    #interp = approx(tic$rt, tic$sumIntensity, RTs)
    #chromatogram[name] = interp$y
}

convert.ms.files.to.lcms.files(path)



tic.file <- function(mzML.file, mzlo, mzhi, input.dir='.', output.dir='.'){
    tic.file.path <- paste(output.dir,
                           '/',
                           mzML.file,
                           '.tic.',
                           format(mzlo,nsmall=2,digits=2), '-',
                           format(mzhi,nsmall=2,digits=2),
                           '.tsv',
                           sep='')
    aa <- openMSfile(paste(input.dir,mzML.file,sep='/'))
    tic <- tic(aa, mzlo, mzhi)
    cat(c(paste("#",mzML.file),"\n"), file=tic.file.path)
    write.table(tic, row.names = FALSE, col.names = TRUE, append = TRUE, file=tic.file.path)
}


tic <- function(aa,mzlo,mzhi){

    v <- 1:runInfo(aa)$scanCount
    dim(v) <- length(v)


    h <- t(apply(v, 1, function(i){
        h <- header(aa,i)
        return(c(h$lowMZ,h$highMZ))
    }))

    s <- which(h[,1] <= mzlo & mzhi <= h[,2])
    if(length(s) == 0){
        print(paste("Error: ( mzlo mzhi ) = (",mzlo, mzhi,") did no match any scan ranges"))
    }
    dim(s) <- length(s)

    x <- t(apply(s, 1, function(i){

        p<-as.data.frame(peaks(aa,i))
        t<-sum(p[mzlo <= p[,1] & p[,1] <= mzhi,2])
        h <- header(aa, i)
        rt <- h$retentionTime
        return(c(rt,t))
    }))
    colnames(x) <- c("rt","sumIntensity")
    return (x)
}
