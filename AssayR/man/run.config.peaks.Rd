\name{run.config.peaks}
\alias{run.config.peaks}
\title{run.config.peaks}
\usage{
run.config.peaks(path.to.config.tsv='config.tsv', path.to.tics, Interactive=TRUE)
}
\arguments{
    \item{path.to.config.tsv}{path to a tab-delimited table of config data, see below}
    \item{path.to.tics}{path to the tics files generated during run.config.tics}
    \item{Interactive}{optionally run interactively}
}
\description{
run.config.peaks take the config definitions and the path to
extracted ion chromatograms, does interactive peak detection
and quantifies isotopes in each sample.
The results are returned in a data.frame.
}
\examples{
p <- run.config("tca-cycle.tsv", "20170526-161533/")
write.csv(p, "results.csv")
}
