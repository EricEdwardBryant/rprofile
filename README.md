# rprofile

An R package to manage package repositories and libraries.

## Install

Install the package using [remotes](https://github.com/r-lib/remotes).
Both the remotes, and rprofile packages require R >= 3.0.0 and have no 
additional package requirements.

```r
install.packages("remotes")
remotes::install_github("EricEdwardBryant/rprofile")
```

## Usage

The following is a minimal rprofile detailing the usage of the rprofile package
with an
[.Rprofile](https://csgillespie.github.io/efficientR/3-3-r-startup.html#r-startup).
When R starts, it searches for a file named `.Rprofile`, which is an R script
that will be sourced before the session begins.
User level configuration can be set by placing a `.Rprofile` in your home
directory.
Project level configuration can be set by placing a `.Rprofile` in your
project's directory.
In the `.Rprofile` you can use the rprofile package to configure R package
*repositories* (where packages are downloaded from) and *libraries* (where
packages are downloaded to).
By default, rprofile ties the current R version to a snapshot of CRAN
hosted by Microsoft, and a supported version of Bioconductor.
Alos, a separate library is configured 

```r
# R executes this function before starting the R session. See ?Startup.
.First <- function() {
  if (!all(c("rprofile", "remotes") %in% rownames(utils::installed.packages()))) {
    message(
      '"rprofile", and "remotes" need to be installed\n',
      '  install.packages("remotes")\n',
      '  remotes::install_github("EricEdwardBryant/rprofile")\n'
    )
  } else {
    rprofile::set_repositories()
    rprofile::set_library()
    rprofile::startup_message()
  }
}
```
