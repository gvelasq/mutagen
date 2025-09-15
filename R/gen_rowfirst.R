#' Generate rowwise first nonmissing value
#'
#' This function returns the rowwise first nonmissing value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns A vector of the rowwise first nonmissing value. The vector's type will be of common type to all rowwise nonmissing values.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rowfirst(a)
#' gen_rowfirst(a, all_of(letters[25:26]))
#' b <- a %>% mutate(q = gen_rowfirst(.))
#' b
#' c <-
#'   a %>%
#'   mutate(w = c("a", TRUE, NA), .before = "x") %>%
#'   mutate(q = gen_rowfirst(.))
#' c # note that q is of type <chr>
#' @export
gen_rowfirst <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_vec(data, purrr::in_parallel(\(...) dplyr::first(c(...), na_rm = TRUE)))
  x
}
