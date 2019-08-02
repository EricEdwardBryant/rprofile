# ---- Version mappings ----
#' @rdname version_cran
#' @export

map_r_to_snapshot <- function(...) {
  c(...,
    # R   = snapshot
    '3.5' = '2018-12-01',
    '3.4' = '2018-04-22',
    '3.3' = '2017-07-01'
  )
}

#' @rdname version_bioc
#' @export

map_r_to_bioc <- function(...) {
  c(...,
    # R    = Bioc
    "3.6"  = "3.9",
    "3.5"  = "3.8",
    "3.5"  = "3.7",
    "3.4"  = "3.6",
    "3.4"  = "3.5",
    "3.3"  = "3.4",
    "3.3"  = "3.3",
    "3.2"  = "3.2",
    "3.2"  = "3.1",
    "3.1"  = "3.0",
    "3.1"  = "2.14",
    "3.0"  = "2.13",
    "3.0"  = "2.12",
    "2.15" = "2.11",
    "2.15" = "2.10",
    "2.14" = "2.9",
    "2.13" = "2.8",
    "2.12" = "2.7",
    "2.11" = "2.6",
    "2.10" = "2.5",
    "2.9"  = "2.4",
    "2.8"  = "2.3",
    "2.7"  = "2.2",
    "2.6"  = "2.1",
    "2.5"  = "2.0",
    "2.4"  = "1.9",
    "2.3"  = "1.8",
    "2.2"  = "1.7",
    "2.1"  = "1.6"
  )
}

# ---- MAIN: Set environment ----
#' Set rprofile environment
#'
#' This function configures versioned package repositories and libraries based
#' on the current version of R. It allows the user to designate fixed
#' package repositories that are tied to a particular version of R.
#'
#' @param home Where to create the version package library.
#' Defaults to "rprofile.home" option if set, else [base::R.home()].
#' @param latest Logical. Use the CRAN mirror without a snapshot date.
#' Defaults to "rprofile.latest" option if set, else `FALSE`.
#' @param r_name An R version (e.g. "3.5") used to select the snapshot.
#' Defaults to "rprofile.r_name" option if set, else
#' [rprofile::version_r_major_minor()].
#' @param cran_map Named character vector.
#' Name-value pairs (R version = CRAN snapshot).
#' If provided, overrides default values returned by [rprofile::map_r_to_snapshot()].
#' @param bioc_map Named character vector.
#' Name-value pairs (R version = Bioc version).
#' If provided, overrides default values returned by [rprofile::map_r_to_bioc()].
#' @param cran_mirror URL for CRAN snapshot mirror.
#' Defaults to "rprofile.cran_mirror" option if set, else [https://cran.microsoft.com].
#' @param bioc_mirror URL for Bioconductor mirror.
#' Defaults to "rprofile.bioc_mirror" option if set, else [https://bioconductor.org].
#' @param verbose Whether to message user with environment information.
#' Defaults to "rprofile.verbose" option if set, else [base::interactive()].
#' @param system_pkgs Character vector of packages that are allowed in the
#' system library.
#' Defaults to "rprofile.system_pkgs" option if set, else
#' `c("remotes", "rprofile")`.
#'
#' @md
#' @export

set_environment <- function(home         = getOption("rprofile.home", R.home()),
                            latest       = getOption("rprofile.latest", FALSE),
                            r_name       = getOption("rprofile.r_name", version_r_major_minor()),
                            cran_map     = getOption("rprofile.cran_map"),
                            bioc_map     = getOption("rprofile.bioc_map"),
                            cran_mirror  = getOption("rprofile.cran_mirror", "https://cran.microsoft.com"),
                            bioc_mirror  = getOption("rprofile.bioc_mirror", "https://bioconductor.org"),
                            verbose      = getOption("rprofile.verbose", interactive()),
                            system_pkgs  = getOption("rprofile.system_pkgs", c("remotes", "rprofile"))) {

  v_cran   <- version_cran(cran_map, r = as.character(r_name), latest = latest)
  v_bioc   <- version_bioc(bioc_map, r = as.character(r_name))
  lib_path <- library_path(home, r_name, v_cran, v_bioc)

  repositories <-
    repos(
      cran        = v_cran,
      bioc        = v_bioc,
      cran_mirror = cran_mirror,
      bioc_mirror = bioc_mirror
    )

  set_repositories(repositories)
  set_library(lib_path)
  rprofile(verbose)
  check_system_packages(system_pkgs) # Warns if issue, otherwise silent

  invisible(list(
    'r_name'       = r_name,
    'home'         = home,
    'cran_version' = v_cran,
    'bioc_version' = v_bioc,
    'cran_mirror'  = cran_mirror,
    'bioc_mirror'  = bioc_mirror,
    'library_path' = lib_path,
    'repos'        = repositories
  ))
}

# ---- Versions ----
#' Get CRAN version
#'
#' This function assigns a date to each version of R, which can be used to set
#' a versioned CRAN package repository.
#'
#' @param ... Custom mappings in name (R version) value (snapshot) pairs.
#' Overrides default values returned by [rprofile::map_r_to_snapshot()].
#' @param r_name An R version (e.g. "3.5") used to select the snapshot.
#' Defaults to "rprofile.r_name" option if set, else
#' [rprofile::version_r_major_minor()].
#' @param latest Logical. Use the CRAN mirror without a snapshot date.
#' Defaults to "rprofile.latest" option if set, else `FALSE`.
#'
#'
#' @return
#' Returns a date in "YYYY-MM-DD" format, or "latest".
#' For unkown R versions, the release date for the current R session version
#' will be used as a fall back unless `latest = TRUE`.
#'
#' @examples
#' # Get default snapshot date for current R version
#' rprofile::version_cran()
#'
#' # Change the snapshot date for version 3.3
#' rprofile::version_cran("3.3" = "2100-05-01")
#'
#' @md
#' @export

version_cran <- function(...,
                         r_name = getOption("rprofile.r_name", version_r_major_minor()),
                         latest = getOption("rprofile.latest", FALSE)) {

  map  <- map_r_to_snapshot(...)
  cran <- unname(map[as.character(r_name)])

  if (latest) {
    return("latest")
  } else if (is.na(cran)) {
    return(with(R.version, paste(year, month, day, sep = '-')))
  } else {
    return(cran)
  }
}


#' Get Bioconductor version
#'
#' Given an R version, return a Bioconductor version.
#'
#' @param ... Custom mappings in name (R version) value (Bioc version) pairs.
#' Overrides default values returned by [rprofile::map_r_to_bioc()].
#' @param r_name An R version (e.g. "3.5") used to select the Bioconductor
#' version.
#' Defaults to "rprofile.r_name" option if set, else
#' [rprofile::version_r_major_minor()].
#'
#' @return
#' Returns a Bioconductor version string, or `NULL` if no version yet specified
#' by [rprofile::map_r_to_bioc()].
#'
#' @md
#' @export

version_bioc <- function(...,
                         r_name = getOption("rprofile.r_name", version_r_major_minor())) {
  map  <- map_r_to_bioc(...)
  bioc <- unname(map[as.character(r_name)])
  if (is.na(bioc)) return(NULL) else return(bioc)
}


#' Get R major and minor version
#'
#' Gets the R major and minor version without the patch version (e.g. returns
#' the numeric version "3.5" if the current R version is "3.5.1").
#'
#' @param r Numeric R version.
#' Defaults to [base::getRversion()].
#'
#' @md
#' @export

version_r_major_minor <- function(r = getRversion()) r[, 1:2]


# ---- Repositories ----
# @param cran The CRAN snapshot date ("YYYY-MM-DD").
# @param bioc The Bioconductor version.
# @param cran_mirror URL for CRAN snapshot mirror.
# @param bioc_mirror URL for Bioconductor mirror.

repos <- function(cran, bioc, cran_mirror, bioc_mirror) {
  c(repo_cran(cran, cran_mirror), repo_bioc(bioc, bioc_mirror))
}


repo_cran <- function(version, mirror) {
  if (version == "latest") {
    url <- mirror
  } else {
    url <- paste(mirror, "snapshot", version, sep = "/")
  }
  c(CRAN = url)
}

repo_bioc <- function(version, mirror) {
  if (is.null(version)) return(NULL)

  paths <-
    c(BioCsoft = "bioc",
      BioCann  = "data/annotation",
      BioCexp  = "data/experiment")

  if (version >= numeric_version("3.7")) paths["BioCworkflows"] <- "workflows"
  if (version <= numeric_version("3.2")) paths["BioCextra"] <- "extra"

  bioc_repos <- paste(mirror, "packages", version, paths, sep = "/")

  names(bioc_repos) <- names(paths)
  bioc_repos
}


# @param urls A named character vector of repositories.

set_repositories <- function(urls) options('repos' = urls)


# ---- Libraries ----
# Construct the library path
#
# Constructs a path to the versioned library in the intended installation home.
#
# @param home Path to home of versioned library.
# @param r_name The R name used to generate the CRAN and Bioconductor versions.
# @param cran The CRAN version.
# @param bioc The Bioconductor version.

library_path <- function(home, r_name, cran, bioc) {
  prefix    <- 'library'
  r_stub    <- paste0('_R-', r_name)
  cran_stub <- paste0('_CRAN-', cran)
  bioc_stub <- paste0('_Bioc-', bioc)

  if (is.null(bioc)) bioc_sub <- NULL
  file.path(home, paste0(prefix, r_stub, bioc_stub, cran_stub))
}


# @param lib Path to versioned library.

set_library <- function(lib) {
  lapply(lib[!file.exists(lib)], dir.create, recursive = TRUE)
  .libPaths(lib)
  Sys.setenv(R_LIBS_USER = .libPaths()[1])
  return(invisible())
}


# ---- rprofile message ----
#' Environment setup message
#'
#' Message the user to indicate current system, repository and library
#' configuration.
#'
#' @param verbose Logical. Should the message be issued. Defaults to `TRUE` in
#' an interactive session, `FALSE` otherwise.
#'
#' @importFrom utils sessionInfo
#' @md
#' @export

rprofile <- function(verbose = interactive()) {
  if (!verbose) return(invisible())

  session  <- utils::sessionInfo()
  r        <- paste0(R.version.string, ' "', R.version$nickname, '"')
  system   <- session$running
  platform <- session$platform
  repos    <- getOption('repos')
  libs     <- .libPaths()

  msg <-
    paste0(
      format(c('R', 'System', 'Platform')),
      ' -- ',
      c(r, system, platform)
    )

  message(paste(msg, collapse = '\n'), '\n')
  message('Repositories:\n', paste0('  ', repos, collapse = '\n'), '\n')
  message('Libraries:\n', paste0('  ', libs, collapse = '\n'), '\n')
}

# ---- Check system packages ----
#' Check system library packages
#'
#' Checks the system library for unallowed packages and warns the user
#' to migrate to newly configured libraries.
#'
#' @param allowed Character vector of allowed packages.
#' Defaults to "rprofile.system_pkgs" user option if set, else
#' `c("remotes", "rprofile")`.
#'
#' @return
#' Returns an invisible character vector of unallowed packages currently
#' installed in the system library.
#'
#' @importFrom utils installed.packages
#' @md
#' @export

check_system_packages <- function(allowed = getOption("rprofile.system_pkgs", c("remotes", "rprofile"))) {
  pkgs     <- as.data.frame(utils::installed.packages(lib.loc = .Library))
  non_base <- as.character(pkgs[is.na(pkgs$Priority), ]$Package)
  bad      <- setdiff(non_base, allowed)
  if (length(bad)) {
    warning(
      "\nPlease migrate unallowed system library packages into your rprofile library:\n  ",
      'unallowed <- c("', paste0(bad, collapse = '", "'), '")\n  ',
      'install.packages(unallowed)          # install into rprofile library\n  ',
      'remove.packages(unallowed, .Library) # remove from system library\n\n',
      'Or, add to allowed system packages:\n  ',
      'options(rprofile.system_pkgs = c("remotes", "rprofile", "<PKG_NAME>"))\n'
    )
  }
  return(invisible(bad))
}
