# ---- Library name ----
#' Library name
#'
#' Construct a library name from R, Bioconductor, and CRAN version information.
#'
#' @param cran The CRAN version.
#' Defaults to the "rprofile.cran" option if set, else
#' [rprofile::version_cran()].
#' @param bioc The Bioconductor version.
#' Defaults to the "rprofile.bioc" option if set, else
#' [rprofile::version_bioc()].
#'
#' @return
#' Returns a string which will be used as the versioned library name.
#'
#' @md
#' @export

library_name <- function(cran = getOption("rprofile.cran", version_cran()),
                         bioc = getOption("rprofile.bioc", version_bioc())) {

  prefix    <- 'library'
  r_stub    <- paste0('_R-', version_r_major_minor())
  cran_stub <- paste0('_CRAN-', cran)
  bioc_stub <- paste0('_Bioc-', bioc)

  if (is.null(bioc)) bioc_sub <- NULL

  paste0(prefix, r_stub, bioc_stub, cran_stub)
}


#' Construct the library path
#'
#' Constructs a path to the versioned library in the intended installation home.
#'
#' @param home Path to home of versioned library.
#' Defaults to the "rprofile.lib.home" option if set, else
#' [base::R.home()]
#' @param name Name of versioned library.
#' Defaults to the "rprofile.lib.name" option if set, else
#' [rprofile::library_name()]
#'
#' @md
#' @export

library_path <- function(home = getOption("rprofile.lib.home", R.home()),
                         name = getOption("rprofile.lib.name", library_name())) {
  file.path(home, name)
}


#' Set the library path
#'
#' Adds the versioned library to the top of the list of previously set
#' libraries. If the library directory does not exist, it will be created.
#'
#' @param lib Path to versioned library.
#' Defaults to [rprofile::library_path()].
#'
#' @md
#' @export

set_library <- function(lib = library_path()) {
  libs <- c(lib, .libPaths())
  lapply(libs[!file.exists(libs)], dir.create, recursive = TRUE)
  .libPaths(libs)
  return(invisible())
}
