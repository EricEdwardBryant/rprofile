# rprofile

A simple R package to manage repositories and libraries.

## Install

Install the package using [remotes](https://github.com/r-lib/remotes).
Both the remotes, and rprofile packages require R >= 3.0.0 and have no 
additional package requirements.

```r
install.packages("remotes")
remotes::install_github("EricEdwardBryant/rprofile")
```

## Usage

The following is a minimal example detailing the usage of the rprofile package
in an
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
hosted by Microsoft, and a compatible version of Bioconductor.
Then, a library is created alongside the system default library that is named
with R, Bioconductor and CRAN snapshot version information.

```r
# R executes this function before starting the R session. See ?Startup.
.First <- function() {
  if (.rprofile_installed()) rprofile::set_environment()
}

# Use as escape hatch if the rprofile package is not available
.rprofile_installed <- function() {
  installed <- rownames(utils::installed.packages(.Library))
  remotes  <- !"remotes" %in% installed
  rprofile <- !"rprofile" %in% installed

  if (remotes)
    message(
      'Please install the "remotes" package into your system library:\n  ',
      'install.packages("remotes", lib = .Library)\n')
  
  if (rprofile)
    message(
      'Please install the "rprofile" package into your system library:\n  ',
      'remotes::install_github("EricEdwardBryant/rprofile", lib = .Library)\n')
  
  !(remotes || rprofile)
}
```

The current environment configuration can be printed anytime with the following
command:

```r
rprofile::rprofile()
```

## Options

These are the available options that can be used to configure the environment.

- **rprofile.home** -- Where to create the version package library.
- **rprofile.latest** -- Whether to use the latest un-versioned CRAN repository.
- **rprofile.r_name** -- The name of the R version used to determine CRAN and
  Bioconductor versions.
- **rprofile.cran_map** -- A named vector mapping R version (names) to CRAN
  snapshot date (value).
  Overrides default mappings returned by `rprofile::map_r_to_snapshot()`.
- **rprofile.bioc_map** -- A named vector mapping R version (names) to
  Bioconductor version (value).
  Overrides default mappings returned by `rprofile::map_r_to_bioc()`.
- **rprofile.cran_mirror** -- A URL to a CRAN mirror with snapshots.
- **rprofile.bioc_mirror** -- A URL to a Bioconductor mirror.
- **rprofile.verbose** -- Wether to display message describing environment.

My system R profile looks something like the following, which includes all of
the available rprofile package options that can be configured before setting the
environment.

```r
# R executes this function before starting the R session. See ?Startup.
.First <- function() {
  if (.rprofile_installed()) {
    rprofile::set_environment(
      home        = R.home(),
      latest      = FALSE,
      r_name      = rprofile::version_r_major_minor(),
      cran_map    = NULL,
      bioc_map    = NULL,
      cran_mirror = "https://cran.microsoft.com",
      bioc_mirror = "https://bioconductor.org",
      verbose     = interactive()
    )
  }
}

# Use as escape hatch if the rprofile package is not available
.rprofile_installed <- function() {
  installed <- rownames(utils::installed.packages(.Library))
  remotes  <- !"remotes" %in% installed
  rprofile <- !"rprofile" %in% installed

  if (remotes)
    message(
      'Please install the "remotes" package into your system library:\n  ',
      'install.packages("remotes", lib = .Library)\n')
  
  if (rprofile)
    message(
      'Please install the "rprofile" package into your system library:\n  ',
      'remotes::install_github("EricEdwardBryant/rprofile", lib = .Library)\n')
  
  !(remotes || rprofile)
}
```
