#' Replace NULLs in a list-column with NAs
#'
#' This function takes a list and replaces all `NULL` values with `NA`. It is useful for working with list-columns in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param x A list or list-column to modify.
#'
#' @returns A list with all `NULL` values replaced with `NA`.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <-
#'   mtcars %>%
#'   select(cyl, vs, am) %>%
#'   slice(1:6) %>%
#'   as_tibble() %>%
#'   mutate(listcol = list(NULL, "b", "c", "d", "e", "f"))
#' glimpse(a)
#' b <-
#'   a %>%
#'   mutate(across(starts_with("listcol"), gen_na_listcol))
#' glimpse(b)
#' @export
gen_na_listcol <- function(x) {
  stopifnot("x must be a list" = is.list(x))
  x <- purrr::modify_tree(
    x,
    leaf = purrr::in_parallel(\(x) replace(x, is.null(x), NA))
  )
  x
}
