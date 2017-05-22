# List accessors
library(testthat)
context("list accessors")

test_that("single [] yields sublist", {
  a <- list(
    a = 1:3,
    b = "a string",
    c = pi,
    d = list(-1, -5)
  )
  expect_equal(1, length(a[4]))
  expect_equal(2, length(a$d))
  expect_equal(2, length(a[[4]]))
  expect_equal(list(-1, -5), a[[4]])
  expect_equal("list", class(a[[4]][1]))
  expect_equal("numeric", class(a[[4]][[1]]))
})
