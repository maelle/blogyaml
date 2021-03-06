# blogyaml

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Travis build status](https://travis-ci.org/ropenscilabs/blogyaml.svg?branch=master)](https://travis-ci.org/ropenscilabs/blogyaml) [![Coverage status](https://codecov.io/gh/ropenscilabs/blogyaml/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/blogyaml?branch=master)



The goal of `blogyaml` is to help batch editing tags of Markdown-based blog posts. The initial motivation is rOpenSci website. 

## Installation

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/blogyaml")
```
## How and why use this app

Here is how to launch the app.

``` r
blogyaml::edit_tags()
```

The workflow shoud ideally be:

* Have a local copy/clone of the website, and even work in a branch.

* Update tags (adding tags to posts, creating new tags) by using the app. 

* Have a look at changes in a git editor before committing/pushing/merging them.

This sounds in my opinion more appealing than opening each post on its own, because one gets to see all posts at once. My goal is to make adding tags to posts as user-friendly as adding topics to GitHub repositories.

### First step

After launching the app via `blogyaml::edit_tags()` you can select the folder where the posts to be modified are. You can pass the path to the function, or rely on its getting your current directory, as well as all directories under `path.expand("~")`. All of this made possible by [`shinyFiles`](https://github.com/thomasp85/shinyFiles).

![](README_files/where.png)

### Edit away

First load the tags, then edit, then click on "Save edits to posts YAML". After that, go look at the folder where your posts are and check the edits with e.g. your favourite git interface. Note: I might record a small video of my screen.

![](README_files/editing.png)

## What this app shouldn't be used for

Standardization of tags (e.g. making all tags lowercase, or transforming all occurrences of "Community" into "community") doesn't need to happen manually via this app. It can be scripted using [`blogdown:::modify_yaml`](https://bookdown.org/yihui/blogdown/from-jekyll.html) or similar helpers, cf [this example](https://github.com/ropensci/roweb2/issues/197#issuecomment-394264824).

## Note

The package uses a copy-pasted [internal `blogdown` function](https://github.com/rstudio/blogdown/blob/ad8be3ffb5ec8576a008375d8da6ec76ab01a902/R/utils.R#L465) hence the licence being GPL-3 like `blogdown`.

## Meta

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

