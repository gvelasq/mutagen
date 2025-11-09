# Generate column percent

This function calculates a column percent. The `by` argument calculates
column percents within unique categories of grouping columns. The `prop`
argument calculates a proportion rather than a percent.

## Usage

``` r
gen_percent(data, col, by, prop = FALSE)
```

## Arguments

- data:

  A data frame.

- col:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  A single column with which to calculate a column percent.

- by:

  An optional character vector of columns to group by.

- prop:

  If `TRUE`, percent will be shown as a proportion between 0-1 rather
  than a percent between 0-100. Default is `FALSE`.

## Value

A double vector totaling 100 within `col`. If grouping columns are
specified with `by`, the percent for each unique category of grouping
columns will total 100 within `col`. If `prop` is specified, a double
vector totaling 1 within `col` (or totaling 1 within unique categories
of grouping columns specified with `by`).

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <- as_tibble(mtcars)
gen_percent(a, gear)
#>  [1] 3.389831 3.389831 3.389831 2.542373 2.542373 2.542373 2.542373 3.389831
#>  [9] 3.389831 3.389831 3.389831 2.542373 2.542373 2.542373 2.542373 2.542373
#> [17] 2.542373 3.389831 3.389831 3.389831 2.542373 2.542373 2.542373 2.542373
#> [25] 2.542373 3.389831 4.237288 4.237288 4.237288 4.237288 4.237288 3.389831
b <-
  a %>%
  select(gear, cyl, carb) %>%
  arrange(gear, cyl, carb) %>%
  mutate(
    pct1 = gen_percent(., gear),
    pct2 = gen_percent(., gear, by = "cyl"),
    pct3 = gen_percent(., gear, by = c("cyl", "carb")),
    prop1 = gen_percent(., gear, prop = TRUE)
  )
b
#> # A tibble: 32 × 7
#>     gear   cyl  carb  pct1  pct2  pct3  prop1
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
#>  1     3     4     1  2.54  6.67  15.8 0.0254
#>  2     3     6     1  2.54 11.1   50   0.0254
#>  3     3     6     1  2.54 11.1   50   0.0254
#>  4     3     8     2  2.54  6.52  25   0.0254
#>  5     3     8     2  2.54  6.52  25   0.0254
#>  6     3     8     2  2.54  6.52  25   0.0254
#>  7     3     8     2  2.54  6.52  25   0.0254
#>  8     3     8     3  2.54  6.52  33.3 0.0254
#>  9     3     8     3  2.54  6.52  33.3 0.0254
#> 10     3     8     3  2.54  6.52  33.3 0.0254
#> # ℹ 22 more rows
```
