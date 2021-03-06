% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rprofile.R
\name{check_system_packages}
\alias{check_system_packages}
\title{Check system library packages}
\usage{
check_system_packages(allowed = getOption("rprofile.system_pkgs",
  c("remotes", "rprofile")))
}
\arguments{
\item{allowed}{Character vector of allowed packages.
Defaults to "rprofile.system_pkgs" user option if set, else
\code{c("remotes", "rprofile")}.}
}
\value{
Returns an invisible character vector of unallowed packages currently
installed in the system library.
}
\description{
Checks the system library for unallowed packages and warns the user
to migrate to newly configured libraries.
}
