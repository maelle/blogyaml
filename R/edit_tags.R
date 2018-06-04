#' @param path path to where the posts are found
#' @export
edit_tags <- function(path = getwd()) {
  .GlobalEnv$.posts.path <- path
  on.exit(rm(.posts.path, envir=.GlobalEnv))
  appDir <- system.file("shiny", package = "blogyaml")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `blogyaml`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
