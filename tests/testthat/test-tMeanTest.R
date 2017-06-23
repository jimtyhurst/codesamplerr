# Experimenting with tMeanTest function options.
library(testthat)

TOLERANCE = 0.0001

context("tMeanTest for evaluating equivalence of samples")

test_that("using unpooled variance with no significant difference", {
  x1_mean = 486.4888
  x1_se = 12.563
  x2_mean = 497
  x2_se = -3.4
  expected_t = -0.8077
  actual_t = tMeanTest(x1_mean, x1_se, x2_mean, x2_se)
  expect_equal(actual_t$t, expected_t, tolerance = TOLERANCE)
  expect_false(actual_t$isSignificant)
})

test_that("using unpooled variance with significant difference", {
  x1_mean = 520.2804
  x1_se = 11.4252
  x2_mean = 496
  x2_se = -3.2
  expected_t = 2.0464
  actual_t = tMeanTest(x1_mean, x1_se, x2_mean, x2_se)
  expect_equal(actual_t$t, expected_t, tolerance = TOLERANCE)
  expect_true(actual_t$isSignificant)
})

