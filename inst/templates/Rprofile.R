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
