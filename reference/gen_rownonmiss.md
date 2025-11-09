# Generate rowwise count of nonmissing values

This function returns the rowwise count of nonmissing values in a data
frame.

## Usage

``` r
gen_rownonmiss(data, cols)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

## Value

An integer vector of the rowwise count of nonmissing values.

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
gen_rownonmiss(a)
#> [1] 2 1 2
gen_rownonmiss(a, all_of(letters[25:26]))
#> [1] 1 1 1
b <- a %>% mutate(q = gen_rownonmiss(.))
b
#> # A tibble: 3 × 4
#>       x     y     z     q
#>   <dbl> <dbl> <dbl> <int>
#> 1     1    NA     4     2
#> 2    NA     3    NA     1
#> 3     2    NA     5     2
```
