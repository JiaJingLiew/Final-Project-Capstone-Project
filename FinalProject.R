setwd("~/Final Project/final")
suppressPackageStartupMessages({
  library(tidytext)
  library(tidyverse)
  library(stringr)
  library(knitr)
  library(wordcloud)
  library(ngram)
})

blogs_file <- "~/Final Project/final/en_US/en_US.blogs.txt"
news_file <- "~/Final Project/final/en_US/en_US.news.txt"
twitter_file <- "~/Final Project/final/en_US/en_US.twitter.txt"

blogs <- readLines(blogs_file, skipNul = TRUE)
con <- file(news_file, open="rb")
news <- readLines(con,  skipNul = TRUE)
twitter <- readLines(twitter_file, skipNul = TRUE)
close(con)
rm(con)

blogs <- data_frame(text = blogs)
news <- data_frame(text = news)
twitter <- data_frame(text = twitter)

set.seed(50)
sample_percentage <- 0.02
blogs_sample<-blogs%>%sample_n(., nrow(blogs)*sample_percentage)
news_sample<-news%>%sample_n(., nrow(news)*sample_percentage)
twitter_sample<-twitter%>%sample_n(., nrow(twitter)*sample_percentage)
sampleData <- bind_rows(
  mutate(blogs_sample, source = "blogs"),
  mutate(news_sample,  source = "news"),
  mutate(twitter_sample, source = "twitter")
)
sampleData$source <- as.factor(sampleData$source)

rm(list = c("twitter_sample", "news_sample", "blogs_sample", "sample_percentage",
            "twitter", "news", "blogs", "twitter_file", "news_file", "blogs_file")
)

data("stop_words")

swear_words <- read_delim("~/Final Project/final/en_US/swearWords.csv", delim = "\n", col_names = FALSE)
swear_words <- unnest_tokens(swear_words, word, X1)
replace_reg <- "[^[:alpha:][:space:]]*"
replace_url <- "http[^[:space:]]*"
replace_aaa <- "\\b(?=\\w*(\\w)\\1)\\w+\\b"

clean_sampleData <-  sampleData %>%
  mutate(text = str_replace_all(text, replace_reg, "")) %>%
  mutate(text = str_replace_all(text, replace_url, "")) %>%
  mutate(text = str_replace_all(text, replace_aaa, "")) %>%
  mutate(text = iconv(text, "UTF-8"))
rm(list = c("sampleData"))

unigramData<-clean_sampleData%>%unnest_tokens(word, text)%>%anti_join(swear_words)%>%anti_join(stop_words)

bigramData <- clean_sampleData %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)
trigramData <- clean_sampleData %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3)
quadgramData <- clean_sampleData %>%
  unnest_tokens(quadgram, text, token = "ngrams", n = 4)

bigram_tiny<-bigramData%>%count(bigram)%>%filter(n > 10)%>%arrange(desc(n))
rm(list = c("bigramData"))
trigram_tiny<-trigramData%>%count(trigram)%>%filter(n > 10)%>%arrange(desc(n))
rm(list = c("trigramData"))
quadgram_tiny<-quadgramData%>%count(quadgram)%>%filter(n > 10)%>%arrange(desc(n))
rm(list = c("quadgramData"))

bi_words<-bigram_tiny%>%separate(bigram, c("word1", "word2"), sep = " ")
tri_words<-trigram_tiny%>%separate(trigram, c("word1", "word2", "word3"), sep = " ")
quad_words<-quadgram_tiny%>%separate(quadgram, c("word1", "word2", "word3", "word4"), sep = " ")

dir.create("final_project_ngram_data", showWarnings = FALSE)
saveRDS(bi_words, "~/Final Project/final/bi_words_top.rds")
saveRDS(tri_words, "~/Final Project/final/tri_words_top.rds")
saveRDS(quad_words,"~/Final Project/final/quad_words_top.rds")

