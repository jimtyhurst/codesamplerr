# Experimenting with t.test function options.
library(testthat)
TOLERANCE = 0.0001

context("t.test for evaluating equivalence of samples")

t_test_unpooled <- function(x1_mean, x1_se, x2_mean, x2_se) {
  return ((x1_mean - x2_mean) / sqrt((x1_se ^ 2) + (x2_se ^ 2)))
}

test_that("using unpooled variance with no significant difference", {
  x1_mean = 486.4888
  x1_se = 12.563
  x2_mean = 497
  x2_se = -3.4
  expected_t = -0.8077
  actual_t = t_test_unpooled(x1_mean, x1_se, x2_mean, x2_se)
  expect_equal(actual_t, expected_t, tolerance = TOLERANCE)
})

test_that("using unpooled variance with significant difference", {
  x1_mean = 605.2804
  x1_se = 11.4252
  x2_mean = 496
  x2_se = -3.2
  expected_t = 9.2104
  actual_t = t_test_unpooled(x1_mean, x1_se, x2_mean, x2_se)
  expect_equal(actual_t, expected_t, tolerance = TOLERANCE)
})

