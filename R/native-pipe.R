library(dplyr)
library(ggplot2)

rnorm(100, mean = 4, sd = 1) |>
  density() |>
  plot()

mtcars |>
  dplyr::group_by(cyl) |>
  dplyr::summarise(mpg = mean(mpg))

mtcars |>
  dplyr::group_by(wt) |>
  dplyr::summarise(mpg = mean(mpg)) |>
  ggplot(aes(wt, mpg)) +
  geom_point()
