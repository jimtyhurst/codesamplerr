sum\_is\_null
================
[Jim Tyhurst](https://www.jimtyhurst.com/) <br>
2020-06-16

  - [Un problème](#un-problème)
  - [Les données](#les-données)
  - [Solution 1](#solution-1)
  - [Solution 2](#solution-2)

## Un problème

Est-ce qu’il y a un moyen d’écrire la fonction `sum_is_null` auquel le
code ci-dessous fait allusion?

``` r
d <- tibble::tibble(
  x = 1:3,
  y = list(NULL, NA, Inf),
  z = list(NULL, NULL, 0)
)
dplyr::summarise_all(
  d, ~ sum_is_null # is that doable?
)
# desired output:
# x y z
# 0 1 2
```

## Les données

``` r
d <- tibble::tibble(
  x = 1:3,
  y = list(NULL, NA, Inf),
  z = list(NULL, NULL, 0)
)
```

## Solution 1

``` r
sum_is_null <- function(x) 
  sum(sapply(x, is.null))

dplyr::summarise_all(d, sum_is_null)
```

    ## # A tibble: 1 x 3
    ##       x     y     z
    ##   <int> <int> <int>
    ## 1     0     1     2

## Solution 2

``` r
sum_is_null <- function(x) 
  sum(lengths(x) < 1)

dplyr::summarise_all(d, list(sum_is_null))
```

    ## # A tibble: 1 x 3
    ##       x     y     z
    ##   <int> <int> <int>
    ## 1     0     1     2
