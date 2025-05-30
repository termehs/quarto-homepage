print(here::here())

knitr::opts_chunk$set(
  digits = 3,
  comment = "#>",
  dev = 'svglite',
  dev.args = list(bg = "transparent"),
  fig.path = "figs/",
  fig.align = "center",
  collapse = TRUE
)
options(width = 80, cli.width = 70)

article_req_pkgs <- function(x, what = "To use code in this article, ") {
  x <- sort(x)
  x <- knitr::combine_words(x, and = " and ")
  paste0(
    what,
    " you will need to install the following packages: ",
    x,
    "."
  )
}
small_session <- function(pkgs = NULL) {
  pkgs <- c(
    pkgs,
    "recipes",
    "parsnip",
    "tune",
    "workflows",
    "dials",
    "dplyr",
    "broom",
    "ggplot2",
    "purrr",
    "rlang",
    "rsample",
    "tibble",
    "infer",
    "yardstick",
    "tidymodels",
    "infer"
  )
  pkgs <- unique(pkgs)
  library(sessioninfo)
  library(dplyr)
  sinfo <- sessioninfo::session_info()
  cls <- class(sinfo$packages)
  sinfo$packages <-
    sinfo$packages %>%
    dplyr::filter(package %in% pkgs)
  class(sinfo$packages) <- cls

  remove_double_newlines <- function(x) {
    ind <- x == ""
    count <- 0
    for (i in seq_along(ind)) {
      if (ind[i]) {
        count <- count + 1
        if (count == 1) {
          ind[i] <- FALSE
        }
      } else {
        count <- 0
      }
    }
    x[!ind]
  }

  sinfo <- capture.output(sinfo)

  sinfo <- sinfo |>
    stringr::str_subset("^ \\[\\d+\\] ", negate = TRUE) |>
    stringr::str_subset(
      "^ (setting|os|system|ui|collate|ctype|tz)",
      negate = TRUE
    ) |>
    stringr::str_remove(" @ .*") |>
    stringr::str_replace_all("\\*", " ") |>
    stringr::str_replace("lib source", "source") |>
    stringr::str_replace(" \\[\\d+\\] ", " ") |>
    stringr::str_subset(
      "Packages attached to the search path",
      negate = TRUE
    ) |>
    remove_double_newlines() 
  
  cat(sinfo, sep = "\n")
}
