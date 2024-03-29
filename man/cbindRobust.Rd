% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cbindRobust.R
\name{cbindRobust}
\alias{cbindRobust}
\title{Function to combine time series that fixes the NA problem}
\usage{
cbindRobust(xts1, xts2)
}
\arguments{
\item{xts1}{First time series to combine}

\item{xts2}{Second time series to combine}
}
\description{
When combining two xts time series in which one series is an empty NA series and the other is a character series, then
 the normal cbind function will return a time series with the correct number of rows and columns but with every cell occupied with NA.
 This function overcomes this problem by allowing us to combine an empty series and a character series.
}
