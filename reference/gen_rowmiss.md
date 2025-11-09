# Generate rowwise count of missing values

This function returns the rowwise count of missing values in a data
frame.

## Usage

``` r
gen_rowmiss(data, cols)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

## Value

An integer vector of the rowwise count of missing values.

## Details

Parallelization is supported via
[[`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html)](https://purrr.tidyverse.org/reference/in_parallel.html).

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <- tibble(
  x = c(1, NA, 2),
  y = c(NA, 3, NA),
  z = c(4, NA, 5)
)
gen_rowmiss(a)
#> [1] 1 2 1
gen_rowmiss(a, all_of(letters[25:26]))
#> [1] 1 1 1
b <- a %>% mutate(q = gen_rowmiss(.))
b
#> # A tibble: 3 × 4
#>       x     y     z     q
#>   <dbl> <dbl> <dbl> <int>
#> 1     1    NA     4     1
#> 2    NA     3    NA     2
#> 3     2    NA     5     1
```
