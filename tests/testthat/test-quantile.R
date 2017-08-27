library(testthat)
context("Generic quantile and cut functions")

# Use case which cannot be handled with these functions:
# Divide observations into equal length bins, even when there are many
# duplicate values, so that some of the duplicates should be in one
# bin and other duplicates should be in an adjacent bin.
# For example, we want the following results:
# observations <- c(-0.8614885, -0.3551012, 0.0444554, 0.7464999, 0.7464999, 1.0488452, 1.0488452, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725)
# quartile 25% = [-0.8614885, -0.3551012, 0.0444554]
# quartile 50% = [0.7464999, 0.7464999, 1.0488452]
# quartile 75% = [1.0488452, 1.5339725, 1.5339725]
# quartile 100% = [1.5339725, 1.5339725, 1.5339725]
# Note that 1.5339725 appears in quartile 75% and 100%.
# And in the completely degenerate case:
# observations <- c(1.0488452, 1.0488452, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725)
# the same value 1.5339725 appears in all four quartiles:
# quartile 25% = [1.5339725, 1.5339725]
# quartile 50% = [1.5339725, 1.5339725]
# quartile 75% = [1.5339725, 1.5339725]
# quartile 100% = [1.5339725, 1.5339725]

test_that("cut for heavily skewed non-unique observations", {
  observations <- c(-0.8614885, -0.3551012, 0.0444554, 0.7464999, 0.7464999, 1.0488452, 1.0488452, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725)
  level_codes <- cut(observations, 4, labels = FALSE)
  expect_equal(sum(level_codes == 1), 2)
  expect_equal(sum(level_codes == 2), 1)
  expect_equal(sum(level_codes == 3), 2)
  # All of the non-unique values are in the same quartile.
  # So more than 50% of observations are in the 4th "quartile"!
  expect_equal(sum(level_codes == 4), 8)
})

test_that("quantile for heavily skewed non-unique observations", {
  observations <- c(-0.8614885, -0.3551012, 0.0444554, 0.7464999, 0.7464999, 1.0488452, 1.0488452, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725)
  cutoffs <- quantile(observations, probs = seq(0, 1, 0.25), labels = FALSE)
  expect_equal(cutoffs[["75%"]], 1.5339725)
  expect_equal(cutoffs[["100%"]], 1.5339725)

  # But cannot use these cutoff points with 'cut':
  expect_error(cut(observations, cutoffs, "'breaks' are not unique"))
})

test_that("cut_number for heavily skewed non-unique observations", {
  observations <- c(-0.8614885, -0.3551012, 0.0444554, 0.7464999, 0.7464999, 1.0488452, 1.0488452, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725, 1.5339725)
  # Unable to divide into equal quantities in 4 bins, so fails:
  expect_error(ggplot2::cut_number(observations, 4, labels = FALSE), "Insufficient data values to produce 4 bins")
})
