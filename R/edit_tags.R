#' @export
edit_tags <- function() {
  appDir <- system.file("shiny", package = "blogyaml")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `blogyaml`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
