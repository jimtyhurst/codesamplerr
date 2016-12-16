
library(testthat)
library(gmp)

context("gmp package")

test_that("Accuracy is preserved for large integers", {
  # This works fine with 15 digits:
  expect_equal(999999999999999 - 999999999999998, 1)
})

test_that("gmp also preserves accuracy for large integers", {
  # This works fine with 15 digits:
  expect_equal(sub.bigz("999999999999999", "999999999999998"), 1)
})

test_that("Accuracy fails for integers that are too large", {
  # See http://geocar.sdf1.org/numbers.html
  # Surprise! With 16 digits, result is 2, rather than 1:
  expect_equal(9999999999999999 - 9999999999999998, 2)
})

test_that("gmp preserves accuracy for integers that are 'too large'", {
  # This works fine with 16 digits:
  expect_equal(sub.bigz("9999999999999999", "9999999999999998"), 1)
})

test_that("Okay to convert individual operands", {
  # This works fine with 19 digits:
  expect_equal(sub.bigz(as.bigz("9876543210987654321"), as.bigz("9876543210987654320")), 1)
})

test_that("Accuracy is preserved for large floats", {
  # This works fine with 15 digits:
  expect_equal(999999999999999.0 - 999999999999998.0, 1)
})

test_that("Accuracy fails for floats that are too large", {
  # Surprise! With 16 digits, result is 2, rather than 1:
  expect_equal(9999999999999999.0 - 9999999999999998.0, 2)
})

test_that("gmp preserves accuracy for floats that are 'too large'", {
  # This works fine with 16 digits, but you have to represent
  # the number with integer numerator and denominator:
  expect_equal(sub.bigq(as.bigq("9999999999999994", 3), as.bigq("9999999999999991", 3)), 1)
})
