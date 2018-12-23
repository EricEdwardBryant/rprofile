#' Use rprofile
#'
#' Create an Rprofile from template.
#'
#' @param dir Path to directory to create the Rprofile.
#' Defaults to the current working directory (i.e. ".").
#' @param template Path to Rprofile template.
#' Defaults to a template included in the rprofile package.
#'
#' @export

use_rprofile <- function(dir = ".",
                         template = system.file('templates/Rprofile.R', package = 'rprofile')) {

  path <- file.path(dir, ".Rprofile")

  if (file.exists(path)) {
    message(
      "Skipping .Rprofile creation, file already exists at\n  ",
      normalizePath(dir)
    )
    return(invisible())
  }

  lines <- readLines(template)
  cat(lines, file = path, sep = "\n")
  message(".Rprofile created at\n  ", normalizePath(dir))
}
