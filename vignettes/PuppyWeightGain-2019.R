## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE, message=FALSE-------------------------------------------
library(codesamplerr)
library(readr)
library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)

# Reads CSV and converts to tidy format.
raw_weights <- system.file(
    "weights-2019", 
    "puppies-2019-weight-in-oz.csv", 
    package = "codesamplerr"
  ) %>% 
  readr::read_csv()
weights <- raw_weights %>% 
  tidyr::gather(
    'pink', 'emerald', 'orange', 'purple', 'yellow', 'blue',
    key = 'puppy_id',
    value = 'weight'
  )

# Plots weight by day.
# Need to jitter the lines vertically slightly, otherwise one 
#   line segment might cover others.
puppy_id_to_color = c(blue = 'blue', emerald = 'green', orange = 'orange', pink = 'red', purple = 'purple', yellow = 'yellow')
plot_weights <- function(weights, puppy_id_to_color) {
  weights %>% 
  mutate(id = factor(puppy_id)) %>% 
  ggplot(aes(x = date, y = weight, group = puppy_id, color = puppy_id)) + 
  geom_point(na.rm = TRUE) +
  geom_line(aes(y = jitter(weight, amount = 0)), na.rm = TRUE) + 
  scale_color_manual(values=puppy_id_to_color) +
  ggtitle("Puppy weight by day") +
  scale_y_continuous(
    limits = c(14, 32), 
    minor_breaks = seq(14, 32, 1),
    breaks = seq(14, 32, by = 2)
  ) + 
  theme(
    panel.grid.minor = element_line(colour="grey60", size=0.5),
    panel.grid.major = element_line(colour="grey40", size=0.5),
    panel.background = element_rect(fill="snow2")
  ) +
  labs(x = "Date", y = "Weight (ounces)", color = "Puppy")
}
plot_weights(weights, puppy_id_to_color) %>% print()

## ----echo=FALSE----------------------------------------------------------
library(knitr)
raw_weights %>% 
  select(date, blue, emerald, orange, pink, purple, yellow) %>% 
  kable(na.print = "NA")

## ------------------------------------------------------------------------
library(codesamplerr)
library(readr)
library(tidyr)
library(dplyr)
library(forcats)
library(lubridate)
library(ggplot2)

## ------------------------------------------------------------------------
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

plot_weights(weights, puppy_id_to_color)


## ------------------------------------------------------------------------
# Uses fct_reorder to sort the puppy_id factor by weight gain (descending).
#   Otherwise, the puppy_id will display in alphabetical order.
weights %>% 
  dplyr::group_by(puppy_id) %>% 
  dplyr::summarize(
    weight_gain = max(weight, na.rm = TRUE) - min(weight, na.rm = TRUE)
  ) %>%
  dplyr::mutate(
    sorted_puppy_id = forcats::fct_reorder(puppy_id, weight_gain, .desc = TRUE)
  ) %>% 
  ggplot(aes(sorted_puppy_id, weight_gain)) + 
    geom_col(fill = puppy_id_to_color) + 
    ggtitle("Total weight gain since birth") +
    labs(x = "Puppy", y = "Weight Gain (ounces)", color = "Puppy") +
    scale_y_continuous(
      expand = c(0, 0),
      limits = c(0, 16), 
      minor_breaks = seq(0, 16, 1),
      breaks = seq(0, 16, by = 2)
    ) +
    theme(
      panel.grid.minor = element_line(colour="grey60", size=0.5),
      panel.grid.major = element_line(colour="grey40", size=0.5),
      panel.background = element_rect(fill="snow2")
    )


## ------------------------------------------------------------------------
sex <- system.file(
    "weights-2019", 
    "puppies-2019-sex.csv", 
    package = "codesamplerr"
  ) %>% 
  readr::read_csv()
weights %>% 
  dplyr::group_by(puppy_id) %>% 
  dplyr::summarize(
    weight_gain = max(weight, na.rm = TRUE) - min(weight, na.rm = TRUE)
  ) %>% 
  dplyr::inner_join(sex, by = c("puppy_id" = "label")) %>% 
  dplyr::group_by(sex) %>% 
  dplyr::summarize(mean_gain = mean(weight_gain, na.rm = TRUE)) %>% 
  ggplot(aes(sex, mean_gain)) + 
    geom_col(fill = c("red", "blue")) + 
    ggtitle("Mean weight gain since birth by sex") +
    labs(x = "Sex", y = "Mean Weight Gain (ounces)") + 
    scale_y_continuous(
      expand = c(0, 0),
      limits = c(0, 16), 
      minor_breaks = seq(1, 15, 2),
      breaks = seq(0, 16, by = 2)
    ) +
    theme(
      panel.grid.minor = element_line(colour="grey60", size=0.5),
      panel.grid.major = element_line(colour="grey40", size=0.5),
      panel.background = element_rect(fill="snow2")
    )


