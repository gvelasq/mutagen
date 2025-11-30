#' Generate column percent
#'
#' This function calculates a column percent. The `by` argument calculates column percents within unique categories of grouping columns. The `prop` argument calculates a proportion rather than a percent.
#'
#' @param data A data frame.
#' @param col <[`tidy-select`][dplyr::dplyr_tidy_select]> A single column with which to calculate a column percent.
#' @param by An optional character vector of columns to group by.
#' @param prop If `TRUE`, percent will be shown as a proportion between 0-1 rather than a percent between 0-100. Default is `FALSE`.
#'
#' @returns A double vector totaling 100 within `col`. If grouping columns are specified with `by`, the percent for each unique category of grouping columns will total 100 within `col`. If `prop` is specified, a double vector totaling 1 within `col` (or totaling 1 within unique categories of grouping columns specified with `by`).
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- as_tibble(mtcars)
#' gen_colpercent(a, gear)
#' b <-
#'   a %>%
#'   select(gear, cyl, carb) %>%
#'   arrange(gear, cyl, carb) %>%
#'   mutate(
#'     pct1 = gen_colpercent(., gear),
#'     pct2 = gen_colpercent(., gear, by = "cyl"),
#'     pct3 = gen_colpercent(., gear, by = c("cyl", "carb")),
#'     prop1 = gen_colpercent(., gear, prop = TRUE)
#'   )
#' b
#' @export
gen_colpercent <- function(data, col, by, prop = FALSE) {
  stopifnot("`data` argument must be a data frame" = is.data.frame(data))
  if (!missing(col)) {
    check <- dplyr::select(data, {{ col }})
    stopifnot("`col` argument must select a single column" = length(check) == 1)
    nm <- names(check)
  }
  if (!missing(by)) {
    stopifnot("`by` argument must be a character vector" = is.character(by))
    data <- dplyr::group_by(data, across(all_of(by)))
  }
  if (!missing(prop)) {
    stopifnot("`prop` argument must be a logical vector" = is.logical(prop))
  }
  if (prop) {
    data <- dplyr::mutate(data, .proportion = .data[[nm]] / sum(.data[[nm]]), .keep = "none")
    out <- data[[".proportion"]]
  } else {
    data <- dplyr::mutate(data, .percent = .data[[nm]] / sum(.data[[nm]]) * 100, .keep = "none")
    out <- data[[".percent"]]
  }
  out
}
