library(testthat)
context("cut that keeps identical values together")

test_that("typical assignment of quartiles", {
  observations <- c(10, 20, 30, 40, 50, 60, 70, 80)
  quartile_breaks <- quantile(
    observations,
    probs = seq(0, 1, 0.25),
    type = 6
  )
  expect_true(quartile_breaks[[2]] > 20)
  expect_true(quartile_breaks[[2]] < 30)
  expect_true(quartile_breaks[[3]] > 40)
  expect_true(quartile_breaks[[3]] < 50)

  # Expect cut into equal quantities per quartile.
  level_codes <- cut(
    observations,
    breaks = quartile_breaks,
    include.lowest = TRUE,
    right = TRUE,
    labels = FALSE
  )
  expect_equal(sum(level_codes == 1), sum(level_codes == 2))
  expect_equal(sum(level_codes == 2), sum(level_codes == 3))
  expect_equal(sum(level_codes == 3), sum(level_codes == 4))
})

test_that("cut fails when quantile breaks are not unique", {
  observations <- c(23, 42, 42, 42, 42, 42, 84, 96)
  quartile_breaks <- quantile(
    observations,
    probs = seq(0, 1, 0.25),
    type = 6
  )
  # 25% and 50% breaks are identical
  expect_equal(quartile_breaks[[2]], 42)
  expect_equal(quartile_breaks[[3]], 42)

  # cut expects that breaks are unique
  expect_error(
    cut(
      observations,
      breaks = quartile_breaks,
      include.lowest = TRUE, # include an x[i] equal to upper bound
      right = TRUE, # closed interval on the right
      labels = FALSE
    ),
    ".*'breaks' are not unique")
})

# This is actual data from a customer.
# Two observations with value of 0.963884306 fall exactly
# on the upper bound of the first quartile. Per customer, these
# values should be included in the first quartile.
# The data is sorted here for convenience of developer review,
# but it is not necessary for the 'quantile' and 'cut' functions
# to work correctly.
getValues <- function() {
  return(c(-0.882332254,
           0.1338623,
           0.215971655,
           0.273843389,
           0.288379391,
           0.292232265,
           0.379572845,
           0.406928303,
           0.432346897,
           0.786682461,
           0.892456064,
           0.895333557,
           0.895333557,
           0.902776789,
           0.938268317,
           0.963884306,
           0.963884306,
           0.999116674,
           1.038401724,
           1.050939066,
           1.216881199,
           1.225567745,
           1.229586293,
           1.229586293,
           1.237477609,
           1.247182861,
           1.267921673,
           1.276053136,
           1.317569133,
           1.346648891,
           1.346648891,
           1.346648891,
           1.346648891,
           1.348288901,
           1.388335998,
           1.434631731,
           1.434631731,
           1.482184361,
           1.486617112,
           1.486617112,
           1.489340391,
           1.496462811,
           1.50421368,
           1.504312646,
           1.523700358,
           1.526535848,
           1.574599952,
           1.584580322,
           1.593867641,
           1.638701735,
           1.663555395,
           1.711811286,
           1.751538235,
           1.751538235,
           1.751538235,
           1.916191835,
           1.927155017,
           1.933473878,
           2.003022218,
           2.003022218,
           2.003022218,
           2.003022218,
           2.167675818,
           2.417554607,
           2.505537447,
           2.670191047))
}

# Every observation with a value equal to the upper bound of a
# quartile break should be assigned to that quartile, even if
# that quartile will hold more than 25% of the observations.
test_that("cut for observations equal to upper bound of a quartile", {
  observations <- getValues()
  quartile_breaks <- quantile(
    observations,
    probs = seq(0, 1, 0.25),
    type = 6
  )
  # 2 observations fall exactly on 25% break point.
  expect_equal(sum(observations == 0.963884306), 2)
  expect_equal(quartile_breaks[[2]], 0.963884306)

  # Verify that equal values are put in the same quartile.
  level_codes <- cut(
    observations,
    breaks = quartile_breaks,
    include.lowest = TRUE, # include an x[i] equal to upper bound
    right = TRUE, # closed interval on the right
    labels = FALSE
  )
  # All observations on upper bound of quartile are assigned to that quartile.
  quartile_assignments <- data.frame(observations, level_codes)
  expect_equal(
    quartile_assignments[quartile_assignments$observations == 0.963884306, "level_codes"],
    c(1, 1))
  # Expected number of students in 1st quartile.
  expect_equal(sum(level_codes == 1), 17)
})

