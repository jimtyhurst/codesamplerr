
library(testthat)

context("Arithmetic with big numbers")

test_that("Accuracy is preserved for large floats", {
  # This works fine with 15 digits:
  expect_equal(999999999999999.0 - 999999999999998.0, 1)
})

test_that("Accuracy fails for floats that are too large", {
  # Surprise! With 16 digits, result is 2, rather than 1:
  expect_equal(9999999999999999.0 - 9999999999999998.0, 2)
})

test_that("Accuracy is preserved for large integers", {
  # This works fine with 15 digits:
  expect_equal(999999999999999 - 999999999999998, 1)
})

test_that("Accuracy fails for integers that are too large", {
  # Surprise! With 16 digits, result is 2, rather than 1:
  expect_equal(9999999999999999 - 9999999999999998, 2)
})
