# Check whether this package is up to date
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste(strwrap("USGS Support Package: https://owi.usgs.gov/R/packages.html#support"), collapse='\n'))
  packageStartupMessage(paste(strwrap(
    paste("Funding for", pkgname, "expires summer 2017, after which bugfixes & new features will be minimal")), collapse='\n'))
  
  GRAN_update_code <- paste0(
    '  update.packages(\n',
    '    oldPkgs=c("powstreams","gsplot","mda.streams","sbtools","streamMetabolizer","unitted"),\n',
    '    dependencies = TRUE, repos=c("http://owi.usgs.gov/R", "https://cran.rstudio.com"))')
  github_owner <- 'USGS-R'
  github_branch <- 'master'
  github_pkg_ref <- paste0(github_owner,'/',pkgname,'@',github_branch)
  github_update_code <- paste0(
    '  devtools::install_github("',github_pkg_ref,'")')
  
  tryCatch({
    GRAN_pkg <- utils::available.packages(utils::contrib.url("http://owi.usgs.gov/R"))
    GRAN_version <- package_version(GRAN_pkg[[pkgname, 'Version']])
    local_version <- utils::packageVersion(pkgname)
    if(local_version < GRAN_version) {
      packageStartupMessage(
        'Time to update to ', pkgname, ' version ', GRAN_version, '! You have ', local_version, '. Get stable updates with\n',
        GRAN_update_code)
    }
  }, error=function(e) {
    packageStartupMessage("Can't check GRAN for new package versions just now. We'll try again next time.")
  })
  
  if(requireNamespace('devtools', quietly=TRUE)) {
    tryCatch({
      github_ref <- devtools:::github_resolve_ref(
        devtools::github_release(), 
        devtools:::parse_git_repo(github_pkg_ref))$ref
      github_version <- package_version(gsub('v', '', github_ref))
      if(local_version < github_version) {
        packageStartupMessage(
          'New development version of ', pkgname, ' (', github_version, ') is ready! You have ', local_version, '. Get dev updates with\n',
          github_update_code)
      }
    }, error=function(e) {
      packageStartupMessage("Can't check GitHub for new package versions just now. We'll try again next time.")
    })
  }
}
