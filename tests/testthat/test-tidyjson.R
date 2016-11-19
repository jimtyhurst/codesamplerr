
# Demonstrates use of tidyjson package, especially handling of NULL,
# empty objects, and empty lists.

library(tidyjson)
library(testthat)

context("tidyson")

test_that("single object yields one row", {
  bookJson <- '[
    {"author": "Susan Cain", "copyrightYear": 2012, "name": "Quiet"}
  ]'
  books <- bookJson %>% 
    as.tbl_json %>% 
    gather_array %>% 
    spread_values(
      author = jstring("author"),
      copyrightYear = jnumber("copyrightYear"),
      title = jstring("name")
    )
  expect_equal(length(books$author), 1)  
})

test_that("simple properties yield simple rows", {
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
    as.tbl_json %>% 
    gather_array %>% 
    spread_values(
      author = jstring("author"),
      copyrightYear = jnumber("copyrightYear"),
      title = jstring("name")
    )
  expect_length(books$author, 3)
  expect_that(books$author[2], equals("Sophia Dembling"))
  expect_that(books$copyrightYear[2], equals(2012))
  expect_that(books$title[2], equals("The Introvert\'s Way: Living A Quiet Life in A Noisy World"))
})

test_that("null 'copyrightYear' value yields NA value in data.frame", {
  bookJson <- '[
    {"author": "Susan Cain", "copyrightYear": null, "name": "Quiet: The Power of Introverts in a World That Can\'t Stop Talking"}, 
    {"author": "Sophia Dembling", "copyrightYear": 2012, "name": "The Introvert\'s Way: Living A Quiet Life in A Noisy World"}, 
    {"author": "Marti Olsen Laney", "copyrightYear": 2002, "name": "The Introvert Advantage: How to Thrive in An Extrovert World"}
  ]'
  books <- bookJson %>% 
    as.tbl_json %>% 
    gather_array %>% 
    spread_values(
      author = jstring("author"),
      copyrightYear = jnumber("copyrightYear"),
      title = jstring("name")
    )
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
    as.tbl_json %>% 
    gather_array %>% 
    spread_values(
      author = jstring("author"),
      copyrightYear = jnumber("copyrightYear"),
      title = jstring("name"),
      commenter = jstring("comment", "author"),
      comment = jstring("comment", "text")
    )
  expect_true(is.na(books$commenter[1]))
  expect_equal(books$commenter[3], "Zoe")
})

test_that("array of 'comments' yields repeated data in data.frame", {
  bookJson <- '[
    { "author": "Susan Cain", 
      "comments": [{"author": "Jordan", "text": "Powerful"}], 
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
    as.tbl_json %>% 
    gather_array %>% 
    spread_values(
      author = jstring("author"),
      copyrightYear = jnumber("copyrightYear"),
      title = jstring("name")
    ) %>% 
    enter_object("comments") %>% 
    gather_array %>% 
    spread_values(
      commenter = jstring("author"),
      comment = jstring("text")
    )
  # Expect 3 commenters on Laney's book, causing repeat in 'author' column.
  expect_equal(length(books$author), 5)
  expect_equal(books$author[1], "Susan Cain")
  expect_equal(books$author[2], "Sophia Dembling")
  expect_equal(books$author[3], "Marti Olsen Laney")
  expect_equal(books$author[4], "Marti Olsen Laney")
  expect_equal(books$author[5], "Marti Olsen Laney")
  expect_equal(books$commenter[1], "Jordan")
  expect_equal(books$commenter[2], "ZZ")
  expect_equal(books$commenter[3], "Alana")
  expect_equal(books$commenter[4], "Monique")
  expect_equal(books$commenter[5], "Zoe")
})

test_that("empty array of 'comments' yields missing row in data.frame", {
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
    as.tbl_json %>% 
    gather_array %>% 
    spread_values(
      author = jstring("author"),
      copyrightYear = jnumber("copyrightYear"),
      title = jstring("name")
    ) %>% 
    enter_object("comments") %>% 
    gather_array %>% 
    spread_values(
      commenter = jstring("author"),
      comment = jstring("text")
    )
  # I expected 'Susan Cain' with NA for comments, *but*
  #   the result does *not* include 'Susan Cain' in data, 
  #   due to empty list of comments.
  # Expect 3 commenters on Laney's book, causing repeat in 'author' column.
  expect_equal(length(books$author), 4)
  expect_equal(books$author[1], "Sophia Dembling")
  expect_equal(books$author[2], "Marti Olsen Laney")
  expect_equal(books$author[3], "Marti Olsen Laney")
  expect_equal(books$author[4], "Marti Olsen Laney")
  expect_equal(books$commenter[1], "ZZ")
  expect_equal(books$commenter[2], "Alana")
  expect_equal(books$commenter[3], "Monique")
  expect_equal(books$commenter[4], "Zoe")
})


