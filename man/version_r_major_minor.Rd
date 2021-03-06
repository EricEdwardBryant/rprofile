% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rprofile.R
\name{version_r_major_minor}
\alias{version_r_major_minor}
\title{Get R major and minor version}
\usage{
version_r_major_minor(r = getRversion())
}
\arguments{
\item{r}{Numeric R version.
Defaults to \code{\link[base:getRversion]{base::getRversion()}}.}
}
\description{
Gets the R major and minor version without the patch version (e.g. returns
the numeric version "3.5" if the current R version is "3.5.1").
}
