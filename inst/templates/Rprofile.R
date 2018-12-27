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
    rprofile.verbose     = interactive(),
    rprofile.system_pkgs = c("remotes", "rprofile"),
    rprofile.template    = NULL # path to template for rprofile::use_rprofile()
  )

  if (.rprofile_installed()) rprofile::set_environment()
}

# Check for rprofile package
.rprofile_installed <- function(lib = .libPaths()) {
  is_needed <- function(x, lib) find.package(x, lib, quiet = TRUE) == 0L
  need_remotes  <- is_needed("remotes", lib)
  need_rprofile <- is_needed("rprofile", lib)

  if (need_remotes)
    message(
      'Please install the "remotes" package:\n  ',
      'install.packages("remotes", lib = "', lib, '")\n')

  if (need_rprofile)
    message(
      'Please install the "rprofile" package:\n  ',
      'remotes::install_github("EricEdwardBryant/rprofile", lib = "', lib, '")\n')

  !need_remotes && !need_rprofile
}
