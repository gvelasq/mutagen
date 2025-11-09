# Generate rowwise mean

This function returns the rowwise arithmetic mean value in a data frame.

## Usage

``` r
gen_rowmean(data, cols)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

## Value

A double vector of the rowwise arithmetic mean value. Missing values are
ignored.

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
gen_rowmean(a)
#> [1] 2.5 3.0 3.5
gen_rowmean(a, everything())
#> [1] 2.5 3.0 3.5
gen_rowmean(a, all_of(letters[25:26]))
#> [1] 4 3 5
b <- a %>% mutate(q = gen_rowmean(.))
b
#> # A tibble: 3 × 4
#>       x     y     z     q
#>   <dbl> <dbl> <dbl> <dbl>
#> 1     1    NA     4   2.5
#> 2    NA     3    NA   3  
#> 3     2    NA     5   3.5
```
