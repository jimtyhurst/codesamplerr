# Experimenting with use of 'set.seed' function.
# http://stackoverflow.com/questions/13605271/reasons-for-using-the-set-seed-function
# claims that set.seed should be called before each use of random
# number generator, but these tests show that is not true.
library(testthat)

context("set.seed enables repeatable use of random number generator")

# Repeats the same sequence of calls using 'rnorm' to get random numbers.
test_that("sequence of rnorm calls is repeatable with set.seed", {
  set.seed(42)
  v11 <- rnorm(5, 0, 1)
  v12 <- rnorm(10, 0, 1)
  v13 <- rnorm(200, 0, 1)
  vs1 <- c(v11, v12, v13)

  set.seed(42)
  v21 <- rnorm(5, 0, 1)
  v22 <- rnorm(10, 0, 1)
  v23 <- rnorm(200, 0, 1)
  vs2 <- c(v21, v22, v23)

  expect_equal(vs1, vs2)
})

# Tries calling different functions, 'rnorm' and 'runif',
# that both use the RNG. Uses the same sequence of calls in each
# scenario, then compares results.
# Note that the 'n' parameter to the last call to 'rnorm' is itself
# a random number.
test_that("multiple calls to random generator are repeatable with set.seed", {
  set.seed(42)
  v11 <- rnorm(5, 0, 1)
  v12 <- rnorm(10, 0, 1)
  rn13 <- as.integer(runif(1, 200, 299))
  v13 <- rnorm(rn13, 0, 1)
  vs1 <- c(v11, v12, v13)

  set.seed(42)
  v21 <- rnorm(5, 0, 1)
  v22 <- rnorm(10, 0, 1)
  rn23 <- as.integer(runif(1, 200, 299))
  v23 <- rnorm(rn23, 0, 1)
  vs2 <- c(v21, v22, v23)

  expect_equal(vs1, vs2)
})
