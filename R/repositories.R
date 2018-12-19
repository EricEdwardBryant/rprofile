# ---- Repositories ----
#' Create repository vector
#'
#' Create a named vector of repositories
#'
#' @param ... User specified repositories added to beginning of vector.
#' @param cran The CRAN snapshot date ("YYYY-MM-DD").
#' Defaults to [rprofile::version_cran()].
#' @param bioc The Bioconductor version.
#' Defaults to [rprofile::version_bioc()].
#' @param cran_mirror URL for CRAN snapshot mirror.
#' Defaults to
#' `getOption("rprofile.cran.mirror", "https://cran.microsoft.com/snapshot")`.
#' @param bioc_mirror URL for Bioconductor mirror.
#' Defaults to
#' `getOption("rprofile.bioc.mirror", "https://bioconductor.org")`.
#'
#' @examples
#' rprofile::repos()
#'
#' # Change the CRAN snapshot to an old date intended for a different R version
#' r <- "3.3"
#'
#' rprofile::repos(
#'   my_repo = "url/to/CRAN/like/repo",
#'   cran    = version_cran(r)
#' )
#'
#' @md
#' @export

repos <- function(...,
                  cran         = version_cran(),
                  bioc         = version_bioc(),
                  cran_mirror  = getOption("rprofile.cran.mirror",
                                           "https://cran.microsoft.com/snapshot"),
                  bioc_mirror  = getOption("rprofile.bioc.mirror",
                                           "https://bioconductor.org")) {
  c(...,
    repo_cran(cran, cran_mirror),
    repo_bioc(bioc, bioc_mirror)
  )
}

# ---- Repository Utilities ----
repo_cran <- function(snapshot, mirror) {
  c(CRAN = paste(mirror, snapshot, sep = "/"))
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
