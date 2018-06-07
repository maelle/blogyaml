#' Title
#'
#' @param path Path to where the posts are located
#' @param format String of post formats
#'
#' @return data.frame of filenames and tags as Booleans
#' @export
#'
#' @examples
get_tags <- function(path, format){
  if(format == c("*Rmd", "*.md")){
    format <- "*.(R)?md"
  }
  posts <- fs::dir_ls(path, regexp = format)
  posts <- purrr::map_chr(posts, get_filename)
  posts <- posts[!grepl("^\\_", posts)]
  tags_info <- unique(purrr::map_df(posts, get_tags_post, path = path))
  if(nrow(tags_info) > 0){
    tags_info$value <- TRUE
    tags_info <- tidyr::spread(tags_info, tags, value, fill = FALSE)
    tags_info <- tibble::tibble(file = posts) %>%
      dplyr::left_join(tags_info, by = "file")
    tags_info[is.na(tags_info)] <- FALSE
  }else{
    tags_info <- tibble::tibble(file = posts)
  }
  return(tags_info)
}

get_filename <- function(file_path){
  pieces <- fs::path_split(file_path)[[1]]
  pieces[length(pieces)]
}

# C:\\Users\\Maelle\\Documents\\ropensci\\roweb2\\content\\blog
get_tags_post <- function(file, path){

  tags <- rmarkdown::yaml_front_matter(file.path(path, file),
                                       encoding = "utf8")$tags
  if(!is.null(tags)){
    tibble::tibble(file = file,
                   tags = tags)
  }else{
    NULL
  }


}
