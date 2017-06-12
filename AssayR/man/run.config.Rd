\name{run.config}
\alias{run.config}
\title{run.config}
\usage{
run.config(path.to.config.tsv='config.tsv', path.to.mzMLs='mzMLneg/')
}
\arguments{
    \item{path.to.config.tsv}{path to a tab-delimited table of config data, see below}
    \item{path.to.mzMLs}{a directory containing the mzML files to be analysed}
}
\description{
a shortcut for calling run.config.tics and run.config.peaks
}
\examples{
p <- run.config("tca-cycle.tsv", "mzMLneg/")
write.csv(p, "results.csv")
}
