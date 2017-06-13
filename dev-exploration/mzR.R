#system(paste('msconvert --mzML --simAsSpectra --filter "peakPicking true 1-" --filter "polarity -"',rawfile))

library(mzR)






path <- "C:/Users/Jimi/Desktop/data/farhat-lab/Asta_2017-05-11_MetabolicFlux_Q33PL1J/mzMLneg"
file <- "02_not-treated-1.mzML"
mzxml <- paste(path, file, sep="/")

tic.file(file, 146,147, path)

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
