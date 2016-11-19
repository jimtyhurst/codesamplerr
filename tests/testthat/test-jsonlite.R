# Demonstrates use of jsonlite package, especially handling of null,
# empty objects, and empty lists.
# For jsonlite documentation, see the vignettes listed at:
#   https://cran.r-project.org/package=jsonlite

library(jsonlite)
library(testthat)

test_that("single object yields one row.", {
  bookJson <- '[
    {"author": "Susan Cain", "copyrightYear": 2012, "name": "Quiet"}
  ]'
  books <- bookJson %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
  expect_equal(length(books$author), 1)
  expect_equal(books$author[1], "Susan Cain")
  expect_equal(books$copyrightYear[1], 2012)
  expect_equal(books$name[1], "Quiet")
})

test_that("simple properties yield simple rows.", {
  bookJson <- '[
    { "author": "Susan Cain",
      "copyrightYear": 2012,
      "name": "Quiet: The Power of Introverts in a World That Can\'t Stop Talking"},
    { "author":
      "Sophia Dembling",
      "copyrightYear": 2012,
      "name": "The Introvert\'s Way: Living A Quiet Life in A Noisy World"},
    { "author": "Marti Olsen Laney",
      "copyrightYear": 2002,
      "name": "The Introvert Advantage: How to Thrive in An Extrovert World"}
  ]'
  books <- bookJson %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
  expect_length(books$author, 3)
  expect_that(books$author[2], equals("Sophia Dembling"))
  expect_that(books$copyrightYear[2], equals(2012))
  expect_that(books$name[2], equals("The Introvert's Way: Living A Quiet Life in A Noisy World"))
})

test_that("null 'copyrightYear' value yields NA value in data.frame.", {
  bookJson <- '[
    {"author": "Susan Cain", "copyrightYear": null, "name": "Quiet: The Power of Introverts in a World That Can\'t Stop Talking"},
    {"author": "Sophia Dembling", "copyrightYear": 2012, "name": "The Introvert\'s Way: Living A Quiet Life in A Noisy World"},
    {"author": "Marti Olsen Laney", "copyrightYear": 2002, "name": "The Introvert Advantage: How to Thrive in An Extrovert World"}
  ]'
  books <- bookJson %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
  expect_true(is.na(books$copyrightYear[1]))
})

test_that("empty 'comment' object yields NA value in data.frame", {
  bookJson <- '[
    { "author": "Susan Cain",
      "copyrightYear": 2012,
      "name": "Quiet: The Power of Introverts in a World That Can\'t Stop Talking",
      "comment": {}},
    { "author": "Sophia Dembling",
      "copyrightYear": 2012,
      "name": "The Introvert\'s Way: Living A Quiet Life in A Noisy World",
      "comment": {"author": "ZZ", "text": "Excellent!"}},
    { "author": "Marti Olsen Laney",
      "copyrightYear": 2002,
      "name": "The Introvert Advantage: How to Thrive in An Extrovert World",
      "comment": {"author": "Zoe", "text": "Recommended"}}
  ]'
  books <- bookJson %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
  # Expect NA for empty object.
  expect_true(is.na(books$comment$author[1]))
  expect_equal(books$comment$author[2], "ZZ")
  expect_equal(books$comment$author[3], "Zoe")
  expect_true(is.na(books$comment$text[1]))
  expect_equal(books$comment$text[2], "Excellent!")
  expect_equal(books$comment$text[3], "Recommended")
})

test_that("array of 'comments' yields embedded data.frame of comment objects.", {
  bookJson <- '[
    { "author": "Susan Cain",
      "comments": [{"author": "Jordan", "text": "Powerful"}],
      "copyrightYear": 2012,
      "name": "Quiet: The Power of Introverts in a World That Can\'t Stop Talking"
    },
    { "author": "Sophia Dembling",
      "comments": [{"author": "ZZ", "text": "Excellent"}],
      "copyrightYear": 2012,
      "name": "The Introvert\'s Way: Living A Quiet Life in A Noisy World"
    },
    { "author": "Marti Olsen Laney",
      "comments": [
        {"author": "Alana", "text": "Boring!"},
        {"author": "Monique", "text": "Chouette!"},
        {"author": "Zoe", "text": "Recommended"}
      ],
      "copyrightYear": 2002,
      "name": "The Introvert Advantage: How to Thrive in An Extrovert World"
    }
  ]'
  books <- bookJson %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
  # Expect 3 commenters on Laney's book, embedded in books[3, "comments"].
  expect_equal(length(books$author), 3)
  expect_equal(books$author[1], "Susan Cain")
  expect_equal(books$author[2], "Sophia Dembling")
  expect_equal(books$author[3], "Marti Olsen Laney")
  expect_equal(books[1, "comments"][[1]]$author[1], "Jordan")
  expect_equal(books[2, "comments"][[1]]$author[1], "ZZ")
  expect_equal(books[3, "comments"][[1]]$author[1], "Alana")
  expect_equal(books[3, "comments"][[1]]$author[2], "Monique")
  expect_equal(books[3, "comments"][[1]]$author[3], "Zoe")
})

test_that("empty array of 'comments' yields empty embedded data.frame.", {
  bookJson <- '[
    { "author": "Susan Cain",
      "comments": [],
      "copyrightYear": 2012,
      "name": "Quiet: The Power of Introverts in a World That Can\'t Stop Talking"
      },
    { "author": "Sophia Dembling",
      "comments": [
        {"author": "ZZ", "text": "Excellent"}
      ],
      "copyrightYear": 2012,
      "name": "The Introvert\'s Way: Living A Quiet Life in A Noisy World"
    },
    { "author": "Marti Olsen Laney",
      "comments": [
        {"author": "Alana", "text": "Boring!"},
        {"author": "Monique", "text": "Chouette!"},
        {"author": "Zoe", "text": "Recommended"}
      ],
      "copyrightYear": 2002,
      "name": "The Introvert Advantage: How to Thrive in An Extrovert World"
    }
  ]'
  books <- bookJson %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
  # Expect 0 commenters on Cain's book and 3 commenters on Laney's book.
  expect_equal(length(books$author), 3)
  expect_equal(books$author[1], "Susan Cain")
  expect_equal(books$author[2], "Sophia Dembling")
  expect_equal(books$author[3], "Marti Olsen Laney")
  expect_equal(length(books[1, "comments"][[1]]), 0)
  expect_equal(books[2, "comments"][[1]]$author, "ZZ")
  expect_equal(books[2, "comments"][[1]]$text, "Excellent")
  expect_equal(books[3, "comments"][[1]]$author[1], "Alana")
  expect_equal(books[3, "comments"][[1]]$author[2], "Monique")
  expect_equal(books[3, "comments"][[1]]$text[2], "Chouette!")
  expect_equal(books[3, "comments"][[1]]$author[3], "Zoe")
})
