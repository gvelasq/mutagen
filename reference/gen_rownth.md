# Generate rowwise nth nonmissing value

This function returns the rowwise nth nonmissing value in a data frame.

## Usage

``` r
gen_rownth(data, cols, n)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

- n:

  An integer vector of length 1 that specifies the position of the
  rowwise nth nonmissing value to search for. A negative integer will
  index from the end.

## Value

A vector of the rowwise nth nonmissing value. The vector's type will be
of common type to all rowwise nonmissing values.

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
gen_rownth(a, n = 1)
#> [1] 1 3 2
gen_rownth(a, n = 2)
#> [1]  4 NA  5
gen_rownth(a, all_of(letters[25:26]), n = 1)
#> [1] 4 3 5
b <- a %>% mutate(q = gen_rownth(., n = 1), r = gen_rownth(., n = 2))
b
#> # A tibble: 3 × 5
#>       x     y     z     q     r
#>   <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1     1    NA     4     1     4
#> 2    NA     3    NA     3    NA
#> 3     2    NA     5     2     5
c <-
  a %>%
  mutate(w = c("a", TRUE, NA), .before = "x") %>%
  mutate(q = gen_rownth(., n = 1), r = gen_rownth(., n = 2))
c # note that q and r are of type <chr>
#> # A tibble: 3 × 6
#>   w         x     y     z q     r    
#>   <chr> <dbl> <dbl> <dbl> <chr> <chr>
#> 1 a         1    NA     4 a     1    
#> 2 TRUE     NA     3    NA TRUE  3    
#> 3 NA        2    NA     5 2     5    
```
