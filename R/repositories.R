# ---- Repositories ----
#' Set repositories
#'
#' Convenience function for setting repositories.
#'
#' @param repos A named character vector of repositories.
#' Defaults to [rprofile::repos()].
#'
#' @md
#' @export

set_repositories <- function(urls = repos()) {
  options(repos = urls)
}

#' Create repository vector
#'
#' Create a named vector of repositories
#'
#' @param ... User specified repositories added to beginning of vector.
#' @param cran The CRAN snapshot date ("YYYY-MM-DD").
#' Defaults to the "rprofile.cran" option if set, else
#' [rprofile::version_cran()].
#' @param bioc The Bioconductor version.
#' Defaults to the "rprofile.bioc" option if set, else
#' [rprofile::version_bioc()].
#' @param cran_mirror URL for CRAN snapshot mirror.
#' Defaults to the "rprofile.cran.mirror" option if set, else
#' `"https://cran.microsoft.com"`.
#' @param bioc_mirror URL for Bioconductor mirror.
#' Defaults to the "rprofile.bioc.mirror" option if set, else
#' `"https://bioconductor.org"`.
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
                  cran         = getOption("rprofile.cran", version_cran()),
                  bioc         = getOption("rprofile.bioc", version_bioc()),
                  cran_mirror  = getOption("rprofile.cran.mirror",
                                           "https://cran.microsoft.com"),
                  bioc_mirror  = getOption("rprofile.bioc.mirror",
                                           "https://bioconductor.org")) {
  c(...,
    repo_cran(cran, cran_mirror),
    repo_bioc(bioc, bioc_mirror)
  )
}

# ---- Repository Utilities ----
repo_cran <- function(snapshot, mirror) {
  if (snapshot == "latest") {
    url <- mirror
  } else {
    url <- paste(mirror, "snapshot", snapshot, sep = "/")
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
