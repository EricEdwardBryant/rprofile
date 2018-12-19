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

## Basic usage

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
hosted by Microsoft, and a supported version of Bioconductor.
Then, a library is created alongside the system default library that is named
with R, Bioconductor and CRAN snapshot version information.

```r
# R executes this function before starting the R session. See ?Startup.
.First <- function() {
  # Escape hatch: Request installation of required packages
  if (!all(c("rprofile", "remotes") %in% rownames(utils::installed.packages()))) {
    message(
      '"rprofile", and "remotes" need to be installed\n',
      '  install.packages("remotes")\n',
      '  remotes::install_github("EricEdwardBryant/rprofile")\n'
    )
    return(invisible())
  }
  
  rprofile::set_repositories()
  rprofile::set_library()
  rprofile::startup_message()
}
```

## Advanced usage

My system R profile looks something like the following, which includes all of
the available rprofile package options that can be set before configuration.

```r
.First <- function() {
  options(
    browserNLdisabled     = TRUE,
    deparse.max.lines     = 2,
    keep.source           = TRUE,
    keep.source.pkgs      = TRUE,
    EBImage.display       = 'raster',
    devtools.desc.author  = "'Eric Bryant <eeb2139@columbia.edu> [aut, cre]'",
    devtools.name         = 'Eric Bryant',
    devtools.desc.license = 'GPL-3',
    prompt                = 'Я▸ ',
    continue              = '     '
  )

  # Escape hatch: Request installation of required packages
  if (!all(c("rprofile", "remotes") %in% rownames(utils::installed.packages()))) {
    message(
      '"rprofile", and "remotes" need to be installed\n',
      '  install.packages("remotes")\n',
      '  remotes::install_github("EricEdwardBryant/rprofile")\n'
    )
    return(invisible())
  }

  # These are all of the available options and their default settings
  options(
    rprofile.cran        = rprofile::version_cran(),
    rprofile.bioc        = rprofile::version_bioc(),
    rprofile.cran.mirror = "https://cran.microsoft.com",
    rprofile.bioc.mirror = "https://bioconductor.org",
    rprofile.lib.home    = R.home(),
    rprofile.lib.name    = rprofile::library_name()
  )

  # rprofile configuration
  rprofile::set_repositories()
  rprofile::set_library()
  rprofile::startup_message()
}
```

To setup a portable package library for a specific project you can simply change
the `"rprofile.lib.home"` option to a directory within your project.
For example, adding the following line to a project's `.Rprofile` will create
a package library in the `"software"` directory of your project:

```r
options(rprofile.lib.home = "software")
```
