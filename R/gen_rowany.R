#' Generate rowwise match of a set of values
#'
#' This function performs a rowwise match of a set of supplied values across columns in a data frame. If any of the row values equal one of the supplied values, this function returns an integer 1 (`1L`) for that row, otherwise it returns an integer 0 (`0L`).
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#' @param values A list of values to match.
#'
#' @returns A binary integer vector indicating whether any supplied value was matched with an integer 1 (`1L`), otherwise it returns an integer 0 (`0L`).
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = 1:3,
#'   y = rep(NA, 3),
#'   z = letters[1:3],
#'   aa = rep(FALSE, 3)
#' )
#' val <- list(1, NA, "a", FALSE)
#' val2 <- list(5, NaN, "d", Inf)
#' gen_rowany(a, values = val)
#' b <- a %>%
#'   mutate(
#'     q = gen_rowany(., values = val),
#'     r = gen_rowany(., values = val2)
#'   )
#' b
#' @export
gen_rowany <- function(data, cols, values) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  stopifnot("values must be a list" = is.list(values))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_int(data, purrr::in_parallel(\(...) any(list(...) %in% values), values = values))
  x
}
