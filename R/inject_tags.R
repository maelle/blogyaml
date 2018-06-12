#' Title
#'
#' @param path Path to where the posts are located
#' @param tags Tags as returned by \code{get_tags} and then edited
#'
#' @export
#'
#' @examples
#' \dontrun{
#' path <- system.file(package = "blogyaml", "example_blog")
#' tags <- get_tags(path, format = "*.md")
#' # do something to tags
#' inject_tags(path, tags)
#' }
inject_tags <- function(path, tags){
  tags_df <- split(tags, tags$file)
  purrr::walk(tags_df, inject_tags_file, path)
  message("Check the edits carefully before pushing them!")
}

inject_tags_file <- function(tags_one, path){
  file <- tags_one$file
  tags <- names(tags_one[2:ncol(tags_one)])[t(tags_one[2:ncol(tags_one)])]
  meta <- rmarkdown::yaml_front_matter(file.path(path, file),
                                       encoding = "utf8")
  original_tags <- meta$tags

  # only edit if needed
  if(!all(tags %in% original_tags)|any (!original_tags %in% tags)){
    file_content <- readLines(file.path(path, file))
    i = grep('^---\\s*$', file_content)
    file_content <- file_content[(i[2]+1):length(file_content)]
    meta$tags <- as.list(tags)
    file_content <- c(c("---"),
                      as.yaml(meta),
                      c("---"),
                      file_content)
    writeLines(file_content, file.path(path, file),
               useBytes = TRUE)
  }

  }

# from blogdown
# https://github.com/rstudio/blogdown/blob/ad8be3ffb5ec8576a008375d8da6ec76ab01a902/R/utils.R#L465
# a wrapper of yaml::as.yaml() to indent sublists by default and trim white spaces
as.yaml = function(..., .trim_ws = TRUE) {
  res = yaml::as.yaml(..., indent.mapping.sequence = TRUE)
  Encoding(res) = 'UTF-8'
  if (.trim_ws) sub('\\s+$', '', res) else res
}
