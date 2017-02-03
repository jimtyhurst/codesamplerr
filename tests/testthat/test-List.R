library(testthat)

context("Experimenting with list of named data.frames")

test_that("Access data.frame by its name using double brackets [[]]", {
  df1 = data.frame(rating = c("low", "med", "high"), color = c("green", "torquoise", "emerald"), stringsAsFactors = FALSE)
  df2 = data.frame(rating = c("low", "med", "high"), color = c("red", "dayglo", "ruby"), stringsAsFactors = FALSE)
  themes <- list("cool" = df1, "hot" = df2)
  coolTheme <- themes[["cool"]]
  expect_equal(coolTheme[coolTheme$rating == "low", "color"], "green")
})
