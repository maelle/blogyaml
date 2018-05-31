# blogyaml

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)


The goal of `blogyaml` is to help batch editing tags of Markdown-based blog posts. The initial motivation is rOpenSci website. 

## Installation

You can, but probably shouldn't at the moment, install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/blogyaml")
```
## Example

Here is how to launch the app.

``` r
blogyaml::edit_tags()
```

## Notes

The package depends on an unexported `blogdown` function, `blogdown:::modify_yaml`.

## Meta

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

