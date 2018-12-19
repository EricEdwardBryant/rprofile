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

The following is an example
[.Rprofile](https://csgillespie.github.io/efficientR/3-3-r-startup.html#r-startup).

```r
# R executes this function before starting the R session. See ?Startup.
.First <- function() {
  # Install remotes and rprofile if necessary
  needed <- function(pkg) !requireNamespace(pkg, quietly = TRUE)
  if (needed("remotes")) install.packages("remotes")
  if (needed("rprofile")) remotes::install_github("EricEdwardBryant/rprofile")
  
  # The following options can be configured. The defaults are shown here.
  # If not specified, these defaults will be used.
  options(
    rprofile.cran        = rprofile::version_cran(),
    rprofile.bioc        = rprofile::version_bioc(),
    rprofile.cran.mirror = "https://cran.microsoft.com/snapshot",
    rprofile.bioc.mirror = "https://bioconductor.org",
    rprofile.lib.home    = R.home()  # Where libraries will be created
    rprofile.lib.name    = rprofile::library_name()
  )

  # Other user specific options
  options(
    browserNLdisabled     = TRUE,
    deparse.max.lines     = 2,
    keep.source           = TRUE,
    keep.source.pkgs      = TRUE,
    EBImage.display       = "raster",
    devtools.desc.author  = "'Eric Bryant <eeb2139@columbia.edu> [aut, cre]'",
    devtools.name         = "Eric Bryant",
    devtools.desc.license = "GPL-3",
    prompt                = "Я▸ ',
    continue              = '     '
  )
  
  rprofile::set_repositories()
  rprofile::set_library()
  rprofile::startup_message()
}
```
