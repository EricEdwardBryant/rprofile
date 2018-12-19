#' Startup message
#'
#' Message the user to indicate current system, repository and library
#' configuration.
#'
#' @param verbose Logical. Should the message be issued. Defaults to TRUE in
#' an interactive session, FALSE otherwise.
#'
#' @export

startup_message <- function(verbose = interactive()) {
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
