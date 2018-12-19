# ---- CRAN snapshot configuration ---------------------------------------------
#' Get the designated CRAN date for a version of R
#'
#' This function assigns a date to each version of R, which can be used to set
#' a versioned CRAN package repository.
#'
#' @param r The R version (e.g. "3.5").
#' Defaults to `rprofile::version_r_major_minor()`.
#' @param map Named character vector mapping R version (names) to snapshot date
#' (values).
#' Defaults to `rprofile::map_r_to_snapshot()`.
#'
#' @return
#' Returns a date in "YYYY-MM-DD" format.
#' For unkown R versions, the release date for the current R session version
#' will be used as a fall back.
#'
#' @examples
#' # Get default snapshot date for current R version
#' rprofile::version_cran()
#'
#' # Get snapshot intended for version 3.3
#' rprofile::version_cran("3.3")
#'
#' # Custom snapshot for R version 3.5.1
#' custom_snapshots <-
#'   rprofile::map_r_to_snapshot(
#'     "3.5.1" = "2100-05-01", # Add a patch level snapshot date
#'     "3.5"   = "2100-99-01"  # Override existing default
#'   )
#'
#' # Use patch level R version and the custom snapshots
#' rprofile::version_cran(rprofile::version_r(), custom_snapshots)
#'
#' @md
#' @export

version_cran <- function(r   = version_r_major_minor(),
                         map = map_r_to_snapshot()) {
  current_release <- with(R.version, paste(year, month, day, sep = '-'))
  cran <- map[as.character(r)]
  if (is.na(cran)) return(current_release) else return(cran)
}

#' @rdname version_cran
#' @export
map_r_to_snapshot <- function(...) {
  c(...,
    '3.5' = '2018-12-20',
    '3.4' = '2018-04-22',
    '3.3' = '2017-07-01'
  )
}

# ---- Bioconductor version configuration --------------------------------------
#' Get Bioconductor version
#'
#' Given an R version, return a Bioconductor version.
#'
#' @param r The R version (e.g. "3.5").
#' Defaults to `version_r_major_minor()`.
#' @param mapp Named character vector mapping R versions (names) to
#' Bioconductor versions (values).
#' Defaults to `map_r_to_bioc()`.
#'
#' @return
#' Returns a Bioconductor version string, or `NULL`` if no version yet specified
#' in `mapping_r_to_bioc`.
#'
#' @md
#' @export

version_bioc <- function(r   = version_r_major_minor(),
                         map = map_r_to_bioc()) {
  bioc <- map[as.character(r)]
  if (is.na(bioc)) return(NULL) else return(bioc)
}


#' @rdname version_bioc
#' @param ... Custom mappings in name (R version) value (Bioc version) pairs.
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

# Can't see use for this at the moment
# @rdname version_bioc
# @export

# map_bioc_to_r <- function(...) {
#   r_to_bioc <- map_r_to_bioc(...)
#   bioc_to_r <- names(r_to_bioc)
#   names(bioc_to_r) <- r_to_bioc
#   bioc_to_r
# }


# ---- R versions ----
#' Granular R versions
#'
#' R version utilities. Why? `rprofile::version_r_major_minor()` makes the
#' granularity of the version information clear.
#'
#' @param r Numeric R version as is returned by `base::getRversion()`.
#'
#' @md
#' @export

version_r <- function() getRversion()

#' @rdname version_r
#' @export

version_r_major <- function(r = version_r()) r[, 1]

#' @rdname version_r
#' @export

version_r_major_minor <- function(r = version_r()) r[, 1:2]
