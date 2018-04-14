library(gutenbergr)
library(dplyr)
library(tidyr)
library(tidytext)

analyze_jules_verne <- function() {
  # Gutenberg ID 2488 is Jules Verne's "20,000 Leagues Under the Sea".
  full_text <- gutenberg_download(2488)

  tidy_book <- full_text %>%
    mutate(line = row_number()) %>%
    unnest_tokens(word, text)

  tidy_book %>%
    anti_join(stop_words) %>%
    count(word, sort = TRUE)

  most_common_words <- tidy_book %>%
    anti_join(stop_words) %>%
    count(word, sort = TRUE) %>%
    top_n(20) %>%
    mutate(word = reorder(word, n)) # %>%
    # ...

  # Sentiment analysis
  # sentiment lexicons
  get_sentiments("afinn")  # [-5, 5]
  get_sentiments("bing")  # [positive, negative]

  sentiment_count <- tidy_book %>%
    inner_join(get_sentiments("bing")) %>%
    count(sentiment, word, sort = TRUE)

  sentiment_count %>%
    group_by(sentiment) %>%
    top_n(10) %>%
    ungroup %>%
    mutate(word = reorder(word, n)) %>%
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
    unnest_tokens(word, text) %>%
    count(title, word, sort = TRUE)
  book_words

  book_words <- book_words %>%
    bind_tf_idf(word, title, n)
  book_words

  book_words %>%
    arrange(-tf_idf)

  # n-grams
  tidy_ngram <- full_text %>%
    unnest_tokens(bigram, text, token = "ngrams", n = 2)
  tidy_ngram

  tidy_ngram %>%
    count(bigram, sort = TRUE)

  tidy_ngram %>%
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    filter(!word1 %in% stop_words$word,
           !word2 %in% stop_words$word) %>%
    count(word1, word2, sort = TRUE)

  # What can you do with n-grams?
  #   tf-idf of n-grams
  #   network analysis
  #   negation

}
