Puppy Weight Gain
================
[Jim Tyhurst, Ph.D.](https://www.jimtyhurst.com/)
2020-06-16

  - [tl;dr](#tldr)
  - [Context](#context)
  - [Configuration](#configuration)
  - [The Data](#the-data)
      - [Measurement error](#measurement-error)
  - [Exploring the Data](#exploring-the-data)
      - [Puppy weight by day](#puppy-weight-by-day)
      - [Weight gain since birth](#weight-gain-since-birth)
      - [Mean weight gain since birth by
        sex](#mean-weight-gain-since-birth-by-sex)

[Source code](./PuppyWeightGain-2019.Rmd).

## tl;dr

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/PuppyWeightGain-2019_files/figure-gfm/reads_and_plots-1.png)<!-- -->

**Note**: I think there is an error in the weights for 2019-04-26, but I
did not catch it until after reviewing the weights for 2019-04-27. It is
extremely unlikely that all puppies lost weight on 2019-04-27. There was
probably an error in zeroing the scale on 2019-04-26 that caused all of
the readings to be a few ounces too high. Therefore, values for 4/26
should probably be replaced with a value that is midway between the
measurements of 4/25 and 4/27, although I have not done that in this
analysis.

Same puppy weight gain data as above, but presented in table format:

| date       | blue | emerald | orange | pink | purple | yellow |
| :--------- | ---: | ------: | -----: | ---: | -----: | -----: |
| 2019-03-20 |   17 |      17 |     19 |   17 |     16 |     17 |
| 2019-03-21 |   16 |      17 |     18 |   16 |     16 |     16 |
| 2019-03-22 |   16 |      16 |     18 |   16 |     16 |     16 |
| 2019-03-23 |   18 |      16 |     18 |   15 |     15 |     16 |
| 2019-03-24 |   19 |      16 |     19 |   17 |     15 |     16 |
| 2019-03-25 |   22 |      17 |     22 |   18 |     16 |     16 |
| 2019-03-26 |   22 |      18 |     23 |   18 |     18 |     18 |
| 2019-03-27 |   25 |      19 |     24 |   20 |     20 |     18 |
| 2019-03-28 |   25 |      20 |     25 |   21 |     21 |     20 |
| 2019-03-29 |   28 |      21 |     28 |   23 |     23 |     21 |
| 2019-03-30 |   29 |      22 |     30 |   23 |     24 |     22 |
| 2019-03-31 |   30 |      23 |     33 |   25 |     27 |     24 |
| 2019-04-01 |   31 |      24 |     34 |   27 |     29 |     26 |
| 2019-04-02 |   34 |      25 |     36 |   29 |     29 |     28 |
| 2019-04-03 |   35 |      26 |     37 |   31 |     30 |     30 |
| 2019-04-04 |   37 |      28 |     41 |   31 |     32 |     33 |
| 2019-04-05 |   40 |      29 |     42 |   32 |     32 |     34 |
| 2019-04-06 |   42 |      30 |     44 |   33 |     35 |     37 |
| 2019-04-07 |   44 |      30 |     47 |   34 |     36 |     38 |
| 2019-04-08 |   46 |      33 |     49 |   36 |     39 |     40 |
| 2019-04-09 |   48 |      34 |     50 |   37 |     41 |     41 |
| 2019-04-10 |   49 |      36 |     52 |   38 |     41 |     43 |
| 2019-04-11 |   49 |      39 |     54 |   40 |     43 |     47 |
| 2019-04-12 |   53 |      40 |     57 |   42 |     47 |     51 |
| 2019-04-13 |   57 |      43 |     61 |   45 |     50 |     55 |
| 2019-04-14 |   60 |      46 |     64 |   46 |     52 |     57 |
| 2019-04-15 |   64 |      48 |     69 |   51 |     56 |     60 |
| 2019-04-16 |   68 |      50 |     71 |   52 |     61 |     61 |
| 2019-04-17 |   70 |      53 |     75 |   54 |     62 |     67 |
| 2019-04-19 |   83 |      61 |     89 |   62 |     75 |     78 |
| 2019-04-21 |   89 |      66 |     96 |   64 |     78 |     81 |
| 2019-04-22 |   97 |      71 |    107 |   72 |     87 |     87 |
| 2019-04-23 |  101 |      74 |    110 |   75 |     90 |     93 |
| 2019-04-24 |  107 |      77 |    116 |   79 |     96 |     97 |
| 2019-04-25 |  119 |      85 |    124 |   87 |    103 |    105 |
| 2019-04-26 |  126 |      92 |    134 |   95 |    112 |    107 |
| 2019-04-27 |  121 |      90 |    128 |   92 |    108 |    109 |
| 2019-04-28 |  138 |     103 |    145 |  103 |    120 |    118 |
| 2019-04-30 |  131 |     113 |    160 |  112 |    131 |    131 |
| 2019-05-01 |  157 |     126 |    176 |  120 |    141 |    139 |
| 2019-05-02 |  176 |     144 |    184 |  134 |    152 |    152 |
| 2019-05-05 |  176 |     144 |    192 |  147 |    157 |    163 |
| 2019-05-07 |  182 |     147 |    202 |  144 |    157 |    173 |
| 2019-05-08 |  176 |     144 |    179 |  144 |    154 |    154 |
| 2019-05-13 |  230 |     205 |     NA |   NA |    224 |    205 |

## Context

This is a simple analysis and plot of the weight gain of a group of
German Shepherd puppies born on 2019-03-19.

## Configuration

``` r
library(codesamplerr)
library(readr)
library(tidyr)
library(dplyr)
library(forcats)
library(lubridate)
library(ggplot2)
```

## The Data

There are two CSV files contained in this package:

  - [puppies-2019-weight-in-oz.csv](../inst/weights-2019/puppies-2019-weight-in-oz.csv)
  - [puppies-2019-sex.csv](../inst/weights-2019/puppies-2019-sex.csv)

The puppies were weighed once daily on a digital kitchen scale until
2019-05-01. That scale measures to a fraction of an ounce, but we
rounded to the nearest ounce.

Starting 2019-05-02, we used a bathroom scale that measures in tenths of
a pound, i.e. one digit past the decimal point. We recorded those
weights exactly as shown on the scale.

### Measurement error

The kitchen scale display varies continuously as a puppy squirms on the
scale platform, so there is a little bit of interpretation involved to
read the weight. However, we do not think that any one reading has more
than one ounce of error, because the display only varied by 0.5 ounce
while a puppy moved. So in any particular reading, it is possible that
we rounded up when a non-moving weight would have rounded down or vice
versa. Even in the early stages, where the puppies only weighed 16
ounces, a 1 ounce error is only 6%. As the puppies gained weight to more
than 7 pounds by 2019-05-01, the error as a percentage of body weight
was much smaller.

Starting 2019-05-02, the largest puppies weighed more than 10 pounds,
which is the maximum capacity of the kitchen scale. Therefore, we
started weighing all puppies on a bathroom scale, where the person doing
the weighing weighed themself first, let the scale reset to zero, then
weighed again holding a puppy. The recorded weight was the total
measured weight of person plus puppy minus the measured weight of the
person. The person only weighed themself once, then weighed all the
puppies in a sequence. Unfortunately, the bathroom scale is not very
accurate. Although it measures to a tenth of a pound, the reading varies
by as much as pound when the same person measures themself several times
in a row. Therefore, we have little confidence in the accuracy of
individual weight measurements recorded starting 2019-05-02, but it was
the only scale we had available, so we include those measurements here
anyway.

## Exploring the Data

### Puppy weight by day

Read the data, convert to
[tidy](https://www.jstatsoft.org/article/view/v059i10/) format, and plot
weight by date for each individual.

``` r
# Reads CSV and converts to tidy format.
weights <- system.file(
    "weights-2019", 
    "puppies-2019-weight-in-oz.csv", 
    package = "codesamplerr"
  ) %>% 
  readr::read_csv() %>% 
  tidyr::gather(
    'pink', 'emerald', 'orange', 'purple', 'yellow', 'blue',
    key = 'puppy_id',
    value = 'weight'
  )
#> Parsed with column specification:
#> cols(
#>   date = col_date(format = ""),
#>   pink = col_double(),
#>   emerald = col_double(),
#>   orange = col_double(),
#>   purple = col_double(),
#>   yellow = col_double(),
#>   blue = col_double()
#> )
plot_weights(weights, puppy_id_to_color)
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/PuppyWeightGain-2019_files/figure-gfm/plots_weights-1.png)<!-- -->

### Weight gain since birth

Next, we plot the weight gain by individual from birth weight to maximum
weight. In all cases, a puppy lost some weight from birth weight, which
is completely normal. But we do *not* calculate:

``` r
    maximum weight - minimum weight   # Not this!
```

For this plot, we calculate:

``` r
    maximum weight - first measured weight   # <== Plot this!
```

``` r
# Calculates birth weights = first measured weights.
start_date <- min(weights$date)
birth_weights <- weights %>% 
  dplyr::filter(date == start_date) %>% 
  dplyr::select(puppy_id, birth_weight = weight)

# Uses fct_reorder to sort the puppy_id factor by weight gain (descending).
#   Otherwise, the puppy_id will display in alphabetical order.
sorted_weights <- weights %>% 
  dplyr::inner_join(birth_weights, by = "puppy_id") %>% 
  dplyr::group_by(puppy_id) %>% 
  dplyr::summarize(
    weight_gain = max(weight, na.rm = TRUE) - min(birth_weight, na.rm = TRUE)
  ) %>%
  dplyr::mutate(
    sorted_puppy_id = forcats::fct_reorder(puppy_id, weight_gain, .desc = TRUE)
  )
#> `summarise()` ungrouping output (override with `.groups` argument)
# Rebuild the color map, because the order of ids was changed
#   by the 'fct_reorder' call above.
sorted_puppy_id_to_color <- purrr::map(
  levels(sorted_weights$sorted_puppy_id),
  function (x) {
    puppy_id_to_color[[x]]
  }
)
sorted_weights %>% 
  ggplot(aes(sorted_puppy_id, weight_gain)) + 
    geom_col(fill = sorted_puppy_id_to_color) + 
    ggtitle("Weight gain since birth (= maximum weight - birth weight)") +
    labs(x = "Puppy", y = "Weight Gain (ounces)", color = "Puppy") +
    scale_y_continuous(
      expand = c(0, 0),
      limits = c(weight_gain_lower_bound_oz, weight_gain_upper_bound_oz), 
      minor_breaks = seq(
        weight_gain_lower_bound_oz, 
        weight_gain_upper_bound_oz, 
        by = 5
      ),
      breaks = seq(
        weight_gain_lower_bound_oz, 
        weight_gain_upper_bound_oz, 
        by = 10
      )
    ) +
    theme(
      panel.grid.minor = element_line(colour="grey60", size=0.5),
      panel.grid.major = element_line(colour="grey40", size=0.5),
      panel.background = element_rect(fill="snow2")
    )
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/PuppyWeightGain-2019_files/figure-gfm/weight_gains-1.png)<!-- -->

### Mean weight gain since birth by sex

Plot the mean weight gain by males and females:

``` r
sex <- system.file(
    "weights-2019", 
    "puppies-2019-sex.csv", 
    package = "codesamplerr"
  ) %>% 
  readr::read_csv()
#> Parsed with column specification:
#> cols(
#>   label = col_character(),
#>   sex = col_character()
#> )
weights %>% 
  dplyr::inner_join(birth_weights, by = "puppy_id") %>% 
  dplyr::group_by(puppy_id) %>% 
  dplyr::summarize(
    weight_gain = max(weight, na.rm = TRUE) - min(birth_weight, na.rm = TRUE)
  ) %>%
  dplyr::inner_join(sex, by = c("puppy_id" = "label")) %>% 
  dplyr::group_by(sex) %>% 
  dplyr::summarize(mean_gain = mean(weight_gain, na.rm = TRUE)) %>% 
  ggplot(aes(sex, mean_gain)) + 
    geom_col(fill = c("red", "blue")) + 
    ggtitle("Mean weight gain since birth by sex") +
    labs(x = "Sex", y = "Mean Weight Gain (ounces)") + 
    scale_y_continuous(
      expand = c(weight_gain_lower_bound_oz, weight_gain_lower_bound_oz),
      limits = c(weight_gain_lower_bound_oz, weight_gain_upper_bound_oz), 
      minor_breaks = seq(
        weight_gain_lower_bound_oz, 
        weight_gain_upper_bound_oz, 
        by = 10),
      breaks = seq(
        weight_gain_lower_bound_oz, 
        weight_gain_upper_bound_oz, 
        by = 10)
    ) +
    theme(
      panel.grid.minor = element_line(colour="grey60", size=0.5),
      panel.grid.major = element_line(colour="grey40", size=0.5),
      panel.background = element_rect(fill="snow2")
    )
#> `summarise()` ungrouping output (override with `.groups` argument)
#> `summarise()` ungrouping output (override with `.groups` argument)
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/PuppyWeightGain-2019_files/figure-gfm/mean_weight_gain_by_sex-1.png)<!-- -->
