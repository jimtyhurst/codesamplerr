Distribution of Meetup Days for the [Portland R User Group
Meetup](https://www.meetup.com/portland-r-user-group/)
================
[Jim Tyhurst](https://www.jimtyhurst.com/)
2020-06-16

  - [The Question](#the-question)
  - [Configuration](#configuration)
  - [The Data](#the-data)
  - [Design decisions](#design-decisions)
  - [Feature Engineering](#feature-engineering)
  - [Visualizing the Distribution of Meeting
    Days](#visualizing-the-distribution-of-meeting-days)
  - [Statistical Analysis](#statistical-analysis)
  - [Conclusion](#conclusion)

## The Question

*Overheard*

Meetup Member P:  
“It would be really great if there were things scheduled on nights other
than Mondays or Tuesdays\!”

Meetup Member Q:  
“Events are scheduled throughout the week on Mondays to Thursdays
traditionally. Feel free to check out past meetups to see the variety
there in terms of days of the week scheduled.”

I could not resist this invitation\! What *is* the distribution of
events by day of the week for the [Portland R User
Group](https://www.meetup.com/portland-r-user-group)?

Disclaimer: I am neither Member P nor Member Q. This is just for fun\!

## Configuration

``` r
library(codesamplerr)
library(readr)
library(dplyr)
library(lubridate)
#> 
#> Attaching package: 'lubridate'
#> The following object is masked from 'package:cowplot':
#> 
#>     stamp
#> The following object is masked from 'package:base':
#> 
#>     date
library(ggplot2)
```

## The Data

[pdxRlang-meetup-days.csv](../inst/pdxRlang-meetup-days.csv) is a
one-column CSV file that has the dates for the last 3 years of Events
listed on the [Portland R User
Group](https://www.meetup.com/portland-r-user-group/) web site. I
created the file on 2019-03-15 by browsing the [Past
Events](https://www.meetup.com/portland-r-user-group/events/past/) web
page and typing the dates into a file manually.

## Design decisions

  - I included all events that were listed, even the two that were
    canceled: 2019-03-06, 2016-12-14. I decided that we are trying to
    evaluate the Meetup Organizers’ choices of meetup days, so even
    canceled meetups should be part of this data.
  - The dates are given in the format of the
    [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html)
    international standard as YYYY-MM-DD.
  - Features such as `DayOfWeek`, `Month`, and `Year` can be derived
    from the date, so I did not bother to include those variables in the
    data file.
  - I stopped recording events at 3 years into the past, because:
      - I think the original discussion was mostly focused on the
        current distribution of meetup days.
      - Going back further than 3 years, there was a series of weekly
        study groups that met on Saturdays. I decided to ignore that
        data, focusing on the more common pattern of meetups that are
        held during Monday through Thursday.
      - Most importantly, I realized I was wasting too much time on this
        project, so I decided to stop gathering data and start the
        analysis.
  - Sadly, I did not record the start and end times of the events. This
    would certainly enrich the analysis, as we would be able to consider
    the breakdown of events held during standard working hours vs events
    held in the evening. There are events in both categories, so I
    regret my slothfulness in not recording times. I leave the task of
    additional data gathering and analysis as an opportunity for
    industrious readers.

## Feature Engineering

Let’s read the data and add variables that will help us to group the
data:

``` r
events <- system.file("pdxRlang-meetup-days.csv", package = "codesamplerr") %>% 
  readr::read_csv() %>% 
  dplyr::mutate(
    DayOfWeek = lubridate::wday(Day),  # numeric, 1 = Sunday
    DayOfWeekLabel = lubridate::wday(Day, label = TRUE),  # Mon, Tue, ...
    Month = lubridate::month(Day), # numeric
    MonthLabel = lubridate::month(Day, label = TRUE), # Jan, Feb, ...
    Year = lubridate::year(Day)
  )
#> Parsed with column specification:
#> cols(
#>   Day = col_date(format = "")
#> )
print(sprintf(
  "Summary: %d events from %s to %s", 
  length(events$Day), 
  min(events$Day), 
  max(events$Day)
))
#> [1] "Summary: 77 events from 2016-01-16 to 2019-03-12"
events
#> # A tibble: 77 x 6
#>    Day        DayOfWeek DayOfWeekLabel Month MonthLabel  Year
#>    <date>         <dbl> <ord>          <dbl> <ord>      <dbl>
#>  1 2019-03-12         3 Tue                3 Mar         2019
#>  2 2019-03-06         4 Wed                3 Mar         2019
#>  3 2019-02-19         3 Tue                2 Feb         2019
#>  4 2019-01-16         4 Wed                1 Jan         2019
#>  5 2019-01-03         5 Thu                1 Jan         2019
#>  6 2018-12-11         3 Tue               12 Dec         2018
#>  7 2018-12-04         3 Tue               12 Dec         2018
#>  8 2018-11-14         4 Wed               11 Nov         2018
#>  9 2018-11-07         4 Wed               11 Nov         2018
#> 10 2018-10-16         3 Tue               10 Oct         2018
#> # … with 67 more rows
```

## Visualizing the Distribution of Meeting Days

First, we plot the entire past 3 years:

``` r
start_date <- min(events$Day)
end_date <- max(events$Day)
n_events <- length(events$Day)
events %>% 
  ggplot(aes(DayOfWeekLabel)) +
  geom_bar(na.rm = TRUE) +
  ggtitle(sprintf(
    "Distribution of %d Meeting Days: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  xlab("Day of Week") +
  scale_y_continuous(name = "Number of Events", limits = c(0, 30), breaks = seq(0, 30, by = 5))
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/DistributionOfMeetupDays_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

The distribution does not seem like a uniform distribution. Tuesday and
Wednesday are definitely the favored days, although many events are also
scheduled on Monday and Thursday.

Let’s focus on just the past year:

``` r
start_date <- max(events$Day) - dyears(1)
end_date <- max(events$Day)
recent_events <- events %>% dplyr::filter(Day >= start_date)
n_events <- length(recent_events$Day)
recent_events %>% 
  ggplot(aes(DayOfWeekLabel)) +
  geom_bar(na.rm = TRUE) +
  ggtitle(sprintf(
    "Distribution of %d Meeting Days: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  xlab("Day of Week") +
  scale_y_continuous(name = "Number of Events", limits = c(0, 30), breaks = seq(0, 30, by = 5))
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/DistributionOfMeetupDays_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

This *recent* data looks much more uniform than the previous plot of all
3 years of data, although Monday has clearly been neglected in the past
year.

While we are exploring and visualizing the data, let’s look at the
distribution of events across months of the year:

``` r
start_date <- min(events$Day)
end_date <- max(events$Day)
n_events <- length(events$Day)
events %>% 
  ggplot(aes(MonthLabel)) +
  geom_bar(na.rm = TRUE) +
  ggtitle(sprintf(
    "Distribution of %d Events by Month: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  xlab("Month") +
  scale_y_continuous(name = "Number of Events", limits = c(0, 10), breaks = seq(0, 10, by = 2))
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/DistributionOfMeetupDays_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

And the distribution of events by year:

``` r
start_date <- min(events$Day)
end_date <- max(events$Day)
n_events <- length(events$Day)
events %>% 
  ggplot(aes(Year)) +
  geom_bar(na.rm = TRUE) +
  ggtitle(sprintf(
    "Distribution of %d Events by Year: %s to %s",
    n_events,
    start_date,
    end_date
  )) +
  scale_x_continuous(name = "Year", limits = c(2015, 2020), breaks = seq(2015, 2020, by = 1)) +
  scale_y_continuous(name = "Number of Events", limits = c(0, 30), breaks = seq(0, 30, by = 5))
```

![](/Users/jimtyhurst/src/r/codesamplerr/vignettes/DistributionOfMeetupDays_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

It appears that the [Portland R User
Group](https://www.meetup.com/portland-r-user-group/) is stable with
approximately the same number of events each year.

## Statistical Analysis

If each day Monday - Thursday had an equal probability of being chosen,
then we would expect roughly the same number of events for each day for
a large sample of events. That would be a uniform distribution. I want
to determine whether the actual distribution of events across the four
days Monday - Thursday is statistically different than a uniform
distribution.

A [chi-square
test](https://stats.idre.ucla.edu/sas/whatstat/what-statistical-analysis-should-i-usestatistical-analyses-using-sas/)
is often used to compare two distributions for categorical variables.
However, this is a very small set of observations. In particular, the
observations for the past year have some cells with less than 5
observations, which violates an assumpution of a chi-square test.
Therefore, Fisher’s Exact Test is a better choice for comparing the
actual distribution to a a uniform distribution across Monday through
Thursday for the past 3 years and for the past year.

``` r
actual_distribution <- events %>% 
  dplyr::filter(DayOfWeek >= 2, DayOfWeek <= 5) %>% 
  dplyr::group_by(DayOfWeekLabel) %>% 
  summarise(n = n())
#> `summarise()` ungrouping output (override with `.groups` argument)
print(actual_distribution)
#> # A tibble: 4 x 2
#>   DayOfWeekLabel     n
#>   <ord>          <int>
#> 1 Mon                9
#> 2 Tue               29
#> 3 Wed               22
#> 4 Thu               12
n_events <- sum(actual_distribution$n)
n_days <- length(actual_distribution$DayOfWeekLabel)
print(sprintf(
  "There are %d total events distributed across %d weekdays.",
  n_events,
  n_days
))
#> [1] "There are 72 total events distributed across 4 weekdays."

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
#> 
#>  Fisher's Exact Test for Count Data
#> 
#> data:  data.frame(x = actual_distribution$n, y = uniform_distribution)
#> p-value = 0.06854
#> alternative hypothesis: two.sided
```

Fisher’s Exact Test results in a p-value = `0.0685`, so the difference
is not significant at a 0.05 level, meaning that events over the past 3
years are not significantly different from a uniform distribution.

Let’s use the same test restricted to only the past year of events,
which is a *very* small sample:

``` r
actual_distribution <- recent_events %>% 
  dplyr::filter(DayOfWeek >= 2, DayOfWeek <= 5) %>% 
  dplyr::group_by(DayOfWeekLabel) %>% 
  summarise(n = n())
#> `summarise()` ungrouping output (override with `.groups` argument)
print(actual_distribution)
#> # A tibble: 4 x 2
#>   DayOfWeekLabel     n
#>   <ord>          <int>
#> 1 Mon                1
#> 2 Tue               11
#> 3 Wed                6
#> 4 Thu                5
n_events <- sum(actual_distribution$n)
n_days <- length(actual_distribution$DayOfWeekLabel)
print(sprintf(
  "There are %d total events distributed across %d days.",
  n_events,
  n_days
))
#> [1] "There are 23 total events distributed across 4 days."

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
#> 
#>  Fisher's Exact Test for Count Data
#> 
#> data:  data.frame(x = actual_distribution$n, y = uniform_distribution)
#> p-value = 0.1725
#> alternative hypothesis: two.sided
```

Considering data for the past year, Fisher’s Exact Test results in a
p-value = `0.1725`, indicating that the difference is not significant,
meaning that the distribution of events over the past 1 year are not
significantly different than a uniform distribution.

## Conclusion

I spent an interesting couple of hours:

  - collecting data from the [Portland R User Group
    Meetup](https://www.meetup.com/portland-r-user-group/); and
  - analyzing the distribution of events by day of the week.

The distribution of events favors Tuesdays and Wednesdays, but there are
events on Mondays and Thursdays also. It appears that the Meetup
Organizers are selecting a variety of days, so that people who have
conflicts on certain days of the week will still be able to attend some
of the Meetup events. Good job,
[Organizers](https://www.meetup.com/portland-r-user-group/members/?op=leaders)\!
