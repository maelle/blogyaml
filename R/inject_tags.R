#' Title
#'
#' @param path Path to where the posts are located
#' @param tags Tags as returned by \code{get_tags} and then edited
#'
#' @export
#'
#' @examples
#' path <- "C:\\Users\\Maelle\\Documents\\ropensci\\roweb2\\content\\blog"
#' tags <- get_tags(path)
#' # do something to tags
#' inject_tags(path, tags)
inject_tags <- function(path, tags){
  tags_df <- split(tags, tags$file)
  purrr::walk(tags_df, inject_tags_file)
  message("Check the edits carefully before pushing them!")
}

inject_tags_file <- function(path, tags_one){
  file <- tags_one$file
  tags <- names(tags_one[2:ncol(tags_one)])[t(tags_one[2:ncol(tags_one)])]
  blogdown:::modify_yaml(file.path(path, file), tags = tags)
}
