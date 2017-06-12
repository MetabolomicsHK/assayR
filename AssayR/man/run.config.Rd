\name{run.config}
\alias{run.config}
\title{run.config}
\usage{
run.config(path.to.config.tsv, path.to.mzML)
}
\description{
a shortcut for calling run.config.tics and run.config.peaks
}
\examples{
p <- run.config("tca-cycle.tsv", "mzMLneg/")
write.csv(p, "results.csv")
}
