# Generate rowwise first nonmissing value

This function returns the rowwise first nonmissing value in a data
frame.

## Usage

``` r
gen_rowfirst(data, cols)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

## Value

A vector of the rowwise first nonmissing value. The vector's type will
be of common type to all rowwise nonmissing values.

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
gen_rowfirst(a)
#> [1] 1 3 2
gen_rowfirst(a, all_of(letters[25:26]))
#> [1] 4 3 5
b <- a %>% mutate(q = gen_rowfirst(.))
b
#> # A tibble: 3 × 4
#>       x     y     z     q
#>   <dbl> <dbl> <dbl> <dbl>
#> 1     1    NA     4     1
#> 2    NA     3    NA     3
#> 3     2    NA     5     2
c <-
  a %>%
  mutate(w = c("a", TRUE, NA), .before = "x") %>%
  mutate(q = gen_rowfirst(.))
c # note that q is of type <chr>
#> # A tibble: 3 × 5
#>   w         x     y     z q    
#>   <chr> <dbl> <dbl> <dbl> <chr>
#> 1 a         1    NA     4 a    
#> 2 TRUE     NA     3    NA TRUE 
#> 3 NA        2    NA     5 2    
```
