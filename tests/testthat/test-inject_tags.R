context("test-inject_tags.R")

test_that("inject_tags works", {

  dir.create("copyblog")
  file.copy(system.file(package = "blogyaml", "example_blog"),
           "copyblog", recursive = TRUE)
  tags <- get_tags(file.path(getwd(), "copyblog", "example_blog"), format = "*.md")
  expect_true(tags$community[1])
  tags[1,2] <- FALSE
  inject_tags(file.path(getwd(), "copyblog", "example_blog"), tags)

  newtags <- get_tags(file.path(getwd(), "copyblog", "example_blog"), format = "*.md")
  expect_false(newtags$community[1])

  unlink("copyblog", recursive = TRUE)

})
