library(testthat)
library(lsa)

# Simple 2D vectors
v0 <- c(1, 0)
v45 <- c(1, 1)
v90 <- c(1, 0)

# For comparison of actual values to expected values.
TOLERANCE <- 0.0001

test_that("cosine of 45 degrees", {
  expect_equal(
    lsa::cosine(v0, v45)[1, 1],
    expected = 0.7071,
    tolerance = TOLERANCE
  )
  expect_equal(
    lsa::cosine(v45, v90)[1, 1],
    expected = 0.7071,
    tolerance = TOLERANCE
  )
})

test_that("cosine of 90 degrees", {
  expect_equal(
    lsa::cosine(v0, v90)[1, 1],
    expected = 1.0,
    tolerance = TOLERANCE
  )
})

test_that("cosine of 0 degrees", {
  expect_equal(
    lsa::cosine(
      c(30, 30),
      c(40, 40)
    )[1, 1],
    expected = 1.0,
    tolerance = TOLERANCE
  )
})

# Pairwise comparison of many vectors.
vectors <- cbind(
  x = c(23, 24, 34, 35, 22, 25, 33, 24),
  y = c(10, 10, 22, 26, 16, 22, 11, 20),
  z = c(14, 15, 35, 16, 11, 23, 10, 41)
)

test_that("matrix columns of vectors", {
  expect_true(any(class(vectors) == "matrix"))
  expect_equal(dim(vectors), c(length(vectors[, "x"]), 3))
})

similarity_matrix <- cosine(vectors)
print(similarity_matrix)

test_that("cosine of same vector", {
  expect_equal(similarity_matrix["x", "x"], 1.0)
  expect_equal(similarity_matrix["y", "y"], 1.0)
  expect_equal(similarity_matrix["z", "z"], 1.0)
})

test_that("cosine is commutative", {
  expect_equal(
    similarity_matrix["x", "y"],
    similarity_matrix["y", "x"]
  )
  expect_equal(
    similarity_matrix["x", "z"],
    similarity_matrix["z", "x"]
  )
})
