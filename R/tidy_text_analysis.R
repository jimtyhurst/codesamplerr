library(gutenbergr)
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)

analyze_jules_verne <- function() {
  # Gutenberg ID 2488 is Jules Verne's "20,000 Leagues Under the Sea".
  full_text <- gutenbergr::gutenberg_download(2488)

  tidy_book <- full_text %>%
    dplyr::mutate(line = row_number()) %>%
    tidytext::unnest_tokens(word, text)

  tidy_book %>%
    dplyr::anti_join(stop_words) %>%
    dplyr::count(word, sort = TRUE)

  most_common_words <- tidy_book %>%
    dplyr::anti_join(stop_words) %>%
    dplyr::count(word, sort = TRUE) %>%
    dplyr::top_n(20) %>%
    dplyr::mutate(word = reorder(word, n)) # %>%
    # ...

  # Sentiment analysis
  # sentiment lexicons
  get_sentiments("afinn")  # [-5, 5]
  get_sentiments("bing")  # [positive, negative]

  sentiment_count <- tidy_book %>%
    dplyr::inner_join(get_sentiments("bing")) %>%
    dplyr::count(sentiment, word, sort = TRUE)

  sentiment_count %>%
    dplyr::group_by(sentiment) %>%
    dplyr::top_n(10) %>%
    dplyr::ungroup %>%
    dplyr::mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n)) +
      geom_col() +
      coord_flip() +
      facet_wrap(~ sentiment, scales = "free")

  # What is a document about?
  # tf-idf = Term Frequency - Inverse Document Frequency
  # corpus = a collection of documents
  # term frequency = number of times a word occurs in a document.
  # idf(term) = ln(n_documents / n_documents containing)
  # find words that are good for distinguishing documents.

  # Analyze a corpus of Jules Verne's books
  full_collection <- gutenberg_download(c(2488, 103, 83, 21489), meta_fields = "title")
  full_collection

  full_collection %>% count(title)

  book_words <- full_collection %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::count(title, word, sort = TRUE)
  book_words

  book_words <- book_words %>%
    tidytext::bind_tf_idf(word, title, n)
  book_words

  book_words %>%
    dplyr::arrange(-tf_idf)

  # n-grams
  tidy_ngram <- full_text %>%
    tidytext::unnest_tokens(bigram, text, token = "ngrams", n = 2)
  tidy_ngram

  tidy_ngram %>%
    dplyr::count(bigram, sort = TRUE)

  tidy_ngram %>%
    tidyr::separate(bigram, c("word1", "word2"), sep = " ") %>%
    dplyr::filter(!word1 %in% stop_words$word,
           !word2 %in% stop_words$word) %>%
    dplyr::count(word1, word2, sort = TRUE)

  # What can you do with n-grams?
  #   tf-idf of n-grams
  #   network analysis
  #   negation

}
