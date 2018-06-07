context("test-get_tags.R")

test_that("get_tags works", {
  blog_path <- system.file(package = "blogyaml", "example_blog")
  expect_is(get_tags(blog_path, format = "*.md"),
              "data.frame")
})
