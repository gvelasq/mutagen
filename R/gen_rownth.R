#' Generate rowwise nth nonmissing value
#'
#' This function returns the rowwise nth nonmissing value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#' @param n An integer vector of length 1 that specifies the position of the rowwise nth nonmissing value to search for. A negative integer will index from the end.
#'
#' @returns A vector of the rowwise nth nonmissing value. The vector's type will be of common type to all rowwise nonmissing values.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rownth(a, n = 1)
#' gen_rownth(a, n = 2)
#' gen_rownth(a, all_of(letters[25:26]), n = 1)
#' b <- a %>% mutate(q = gen_rownth(., n = 1), r = gen_rownth(., n = 2))
#' b
#' c <-
#'   a %>%
#'   mutate(w = c("a", TRUE, NA), .before = "x") %>%
#'   mutate(q = gen_rownth(., n = 1), r = gen_rownth(., n = 2))
#' c # note that q and r are of type <chr>
#' @export
gen_rownth <- function(data, cols, n) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  stopifnot("n must be a length 1 numeric vector coercible to an integer" = is.numeric(n) & length(n) == 1)
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_vec(data, purrr::in_parallel(\(...) dplyr::nth(c(...), n, na_rm = TRUE), n = n))
  x
}
