rprofile
========

Yet another R package to manage R packages. The rprofile strategy is a blend of the [packrat](https://rstudio.github.io/packrat) and [checkpoint](https://github.com/RevolutionAnalytics/checkpoint) strategies for package management. It uses the checkpoint repository infrastruction to tie R versions to versioned package repositories, and (optionally) makes it easy to install these packages within a given project.

Motivation
----------

Defend your R projects from [bit rot](https://en.wikipedia.org/wiki/Software_rot) caused by the endless march of time and the demands of continued progress! rprofile offers a simple way to manage R packages that allows you to easily reproduce your environment on other computers, while also allowing you to play with all those fun packages released every day.

Example features:

1.  Quickly setup a project specific package library.
2.  Tie a sepcific version of R to a fixed set of packages that have been tested to work with that version.
3.  Easily reproduce package libraries on your friend's computers.
4.  Easily switch between latest package releases and fixed versions.
5.  Easily upgrade R.
6.  Minimal setup and maintenance.

Judicious package management is essential to ensure your projects remain reproducible for yourself and others. For this, rprofile is here to help!

Install
-------

Install the package using [remotes](https://github.com/r-lib/remotes). Both the remotes, and rprofile packages require R &gt;= 3.0.0 and have no additional package requirements.

``` r
install.packages("remotes")
remotes::install_github("EricEdwardBryant/rprofile")
```

Usage
-----

To begin using rprofile with your project, create a file called `.Rprofile` in either your project's working directory, or your home directory. This file is an R script that is sourced when an R session begins (See [`?Startup`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Startup.html) for more details about R's startup configuration). For convenience, use one of the following commands to create an `.Rprofile` configured for use with this package (see template below).

``` r
rprofile::use_rprofile()    # project specific profile in working directory
rprofile::use_rprofile("~") # default user profile in home directory
```

In the `.Rprofile`, the command `rprofile::set_environment()` configures:

1.  **repositories**, where R packages are downloaded from, which defaults to a snapshot of CRAN and a compatible Bioconductor version. Use, `rprofile::map_r_to_snapshot()` and `rprofile::map_r_to_bioc()` to see the default version mappings. Use the `cran_map` and `bioc_map` arguments to specify custom mappings.
2.  **libraries**, where R packages are installed, which defaults to a library created alongside the system default library that is named with R, Bioconductor and CRAN snapshot version information. Use the `home` argument to move this library to a different location.

The current environment configuration will be displayed when starting a new R session and can be printed anytime with the following command:

``` r
rprofile::rprofile()
```

For example, my current session is configured with the following environment:

    R        -- R version 3.5.1 (2018-07-02) "Feather Spray"
    System   -- macOS High Sierra 10.13.6
    Platform -- x86_64-apple-darwin15.6.0 (64-bit)

    Repositories:
      https://cran.microsoft.com/snapshot/2018-12-01
      https://bioconductor.org/packages/3.8/bioc
      https://bioconductor.org/packages/3.8/data/annotation
      https://bioconductor.org/packages/3.8/data/experiment
      https://bioconductor.org/packages/3.8/workflows

    Libraries:
      /Library/Frameworks/R.framework/Versions/3.5/Resources/library_R-3.5_Bioc-3.8_CRAN-2018-12-01
      /Library/Frameworks/R.framework/Versions/3.5/Resources/library

Options
-------

Configure your environment with the following arguments to `rprofile::set_environment()`:

-   **home** -- Where to create the version package library.
-   **latest** -- Whether to use the latest un-versioned CRAN repository.
-   **r\_name** -- The name of the R version used to determine CRAN and Bioconductor versions.
-   **cran\_map** -- A named vector mapping R version (names) to CRAN snapshot date (value). Overrides default mappings returned by `rprofile::map_r_to_snapshot()`.
-   **bioc\_map** -- A named vector mapping R version (names) to Bioconductor version (value). Overrides default mappings returned by `rprofile::map_r_to_bioc()`.
-   **cran\_mirror** -- A URL to a CRAN mirror with snapshots.
-   **bioc\_mirror** -- A URL to a Bioconductor mirror.
-   **verbose** -- Wether to display message describing environment.

All of these arguments can also be set during startup as options of the same name prepended with `"rprofile."`. Doing so will preserve your configuration while allowing you to, for example, switch to the latest version of packages from CRAN during an R session with:

``` r
rprofile::set_environment(latest = TRUE)
```

Default `.Rprofile` template
----------------------------

The current default `.Rprofile` generated be `rprofile::use_rprofile()` is provided below.

    # R executes this function before starting the R session. See ?Startup.
    .First <- function() {

      options(
        rprofile.home        = R.home(),
        rprofile.latest      = FALSE,
        rprofile.r_name      = getRversion()[, 1:2], # Major.minor version
        rprofile.cran_map    = NULL,
        rprofile.bioc_map    = NULL,
        rprofile.cran_mirror = "https://cran.microsoft.com",
        rprofile.bioc_mirror = "https://bioconductor.org",
        rprofile.verbose     = interactive()
      )

      if (.rprofile_installed()) rprofile::set_environment()
    }

    # Check for rprofile package
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
