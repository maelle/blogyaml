#' @param path path to where the posts are found
#' @title Shiny app for batch tag editing
#' @description Launch Shiny app for batch tag editing
#' @details The YAML metadata can also be edited in other fields, e.g. a slug
#' can become lala instead of 'lala' which should not pose any problem.
#' That said, do check all edits before committing them (assuming your website is
#'  under version control!).
#' @examples
#' \dontrun{
#'  blog_path <- system.file(package = "blogyaml", "example_blog")
#'  edit_tags(blog_path)
#'  }
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
