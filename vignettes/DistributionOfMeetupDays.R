## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(codesamplerr)
library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

## ------------------------------------------------------------------------
events <- system.file("extdata", "pdxRlang-meetup-days.csv", package = "codesamplerr") %>% 
  readr::read_csv() %>% 
  dplyr::mutate(
    DayOfWeek = lubridate::wday(Day),  # numeric, 1 = Sunday
    DayOfWeekLabel = lubridate::wday(Day, label = TRUE),  # Mon, Tue, ...
    Month = lubridate::month(Day), # numeric
    MonthLabel = lubridate::month(Day, label = TRUE), # Jan, Feb, ...
    Year = lubridate::year(Day)
  )
print(sprintf(
  "Summary: %d events from %s to %s", 
  length(events$Day), 
  min(events$Day), 
  max(events$Day)
))
events

## ------------------------------------------------------------------------
start_date <- min(events$Day)
end_date <- max(events$Day)
n_events <- length(events$Day)
events %>% 
  ggplot(aes(DayOfWeekLabel)) +
  geom_bar() +
  ggtitle(sprintf(
    "Distribution of %d Meeting Days: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  xlab("Day of Week") +
  scale_y_continuous(name = "Number of Events", limits = c(0, 30), breaks = seq(0, 30, by = 5))

## ------------------------------------------------------------------------
start_date <- max(events$Day) - dyears(1)
end_date <- max(events$Day)
recent_events <- events %>% dplyr::filter(Day >= start_date)
n_events <- length(recent_events$Day)
recent_events %>% 
  ggplot(aes(DayOfWeekLabel)) +
  geom_bar() +
  ggtitle(sprintf(
    "Distribution of %d Meeting Days: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  xlab("Day of Week") +
  scale_y_continuous(name = "Number of Events", limits = c(0, 30), breaks = seq(0, 30, by = 5))

## ------------------------------------------------------------------------
start_date <- min(events$Day)
end_date <- max(events$Day)
n_events <- length(events$Day)
events %>% 
  ggplot(aes(MonthLabel)) +
  geom_bar() +
  ggtitle(sprintf(
    "Distribution of %d Events by Month: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  xlab("Month") +
  scale_y_continuous(name = "Number of Events", limits = c(0, 10), breaks = seq(0, 10, by = 2))

## ------------------------------------------------------------------------
start_date <- min(events$Day)
end_date <- max(events$Day)
n_events <- length(events$Day)
events %>% 
  ggplot(aes(Year)) +
  geom_bar() +
  ggtitle(sprintf(
    "Distribution of %d Events by Year: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  scale_x_continuous(name = "Year", limits = c(2015, 2020), breaks = seq(2015, 2020, by = 1)) +
  scale_y_continuous(name = "Number of Events", limits = c(0, 30), breaks = seq(0, 30, by = 5))

## ------------------------------------------------------------------------
actual_distribution <- events %>% 
  dplyr::filter(DayOfWeek >= 2, DayOfWeek <= 5) %>% 
  dplyr::group_by(DayOfWeekLabel) %>% 
  summarise(n = n())
print(actual_distribution)
n_events <- sum(actual_distribution$n)
n_days <- length(actual_distribution$DayOfWeekLabel)
print(sprintf(
  "There are %d total events distributed across %d weekdays.",
  n_events,
  n_days
))

# Build uniform distribution with same number of events in each of
# the day slots for Monday - Thursday.
uniform_distribution <- ceiling(rep(n_events / n_days, n_days))

# Use Fisher's Test on a contingency table with the actual distribution compared
# to a uniform distribution.
test_result <- fisher.test(data.frame(
  x = actual_distribution$n, 
  y = uniform_distribution
))
print(test_result)

## ------------------------------------------------------------------------
actual_distribution <- recent_events %>% 
  dplyr::filter(DayOfWeek >= 2, DayOfWeek <= 5) %>% 
  dplyr::group_by(DayOfWeekLabel) %>% 
  summarise(n = n())
print(actual_distribution)
n_events <- sum(actual_distribution$n)
n_days <- length(actual_distribution$DayOfWeekLabel)
print(sprintf(
  "There are %d total events distributed across %d days.",
  n_events,
  n_days
))

# Build uniform distribution with same number of events in each of
# the day slots for Monday - Thursday.
uniform_distribution <- ceiling(rep(n_events / n_days, n_days))

# Use Fisher's Test on a contingency table with the actual distribution compared
# to a uniform distribution.
test_result <- fisher.test(data.frame(
  x = actual_distribution$n, 
  y = uniform_distribution
))
print(test_result)

