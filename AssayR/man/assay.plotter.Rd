\name{assay.plotter}
\alias{assay.plotter}
\title{assay.plotter}
\usage{
assay.plotter(p, condition.pattern = "(^.*)-[[:digit:]]+$",
                 repeat.inj.pattern = "n[[:digit:]]+[\\-_](.*)")
}
\description{
assay.plotter takes the result of run.config.peaks, for
isotopically labelled experiments only, and plots normalized
and absolute stacked barplots, as well as outputting the table
in a re-arranged format that may be more useful for downstream
applications.

The default parameters give patterns suitable for working with the output
 of run.config.peaks.
}
\examples{
p <- run.config.peaks("tca-cycle.tsv", "20170526-161533/")
q <- assay.plotter(p)

}
