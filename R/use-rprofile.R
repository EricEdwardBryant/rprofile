#' Use rprofile
#'
#' Create an Rprofile from template.
#'
#' @param dir Path to directory to create the Rprofile.
#' Defaults to the current working directory (i.e. ".").
#' @param template Path to Rprofile template.
#' Defaults to "rprofile.template" option if set, else
#' a template included in the rprofile package.
#'
#' @export

use_rprofile <- function(dir = ".",
                         template = getOption("rprofile.template")) {

  if (is.null(template)) {
    template <- system.file('templates/Rprofile.R', package = 'rprofile')
  }

  lines <- readLines(template)
  path  <- file.path(dir, ".Rprofile")

  if (file.exists(path)) {
    existing <- readLines(path)

    if (identical(existing, lines)) {
      message(
        "Skipping .Rprofile creation, template already exists at\n  ",
        normalizePath(dir)
      )

      return(invisible())
    }

    message(
      "Skipping .Rprofile creation, file already exists at\n  ",
      normalizePath(dir), "\n",
      "Printing differences from default template below:"
    )

    diff_lines(existing, lines)
    return(invisible())
  }

  cat(lines, file = path, sep = "\n")
  message(".Rprofile created at\n  ", normalizePath(dir))
}


diff_lines <- function(x, y) {
  x_i <- which(!x %in% y)
  y_i <- which(!y %in% x)

  x_msg <- paste0(length(x_i), " lines unique to existing .Rprofile:\n")
  y_msg <- paste0(length(y_i), " lines unique to rprofile template:\n")

  if (length(x_i)) {
    x_msg <- c(x_msg, paste0(format(paste0("[", x_i, "] ")), x[x_i]), "\n")
  }

  if (length(y_i)) {
    y_msg <- c(y_msg, paste0(format(paste0("[", y_i, "] ")), x[y_i]), "\n")
  }

  cat(c(x_msg, y_msg), sep = "\n")
}


