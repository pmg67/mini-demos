# install.packages('dplyr')
# install.packages('stringr')
# install.packages('tidytext')
# install.packages('tidyr')
# install.packages('ggplot2')

library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)
library(ggplot2)

##### LEXICONS #####
# Use the get_sentiments() function to get your dictionary of positive
# and negative words. Use the lexicon which categorizes words into
# positive and negative.

sentiment_table <- get_sentiments()

##### DATA ANALYSIS + WRANGLING #####
# Read books data in 

books_data <- read.csv("data/austen_books.csv",
                         stringsAsFactors = FALSE
)

# Map each word in the 'books' dataset to its dictionary-prescribed sentiment.

combined_books <- left_join(books_data, sentiment_table)

# Instead of having each individual word, count the number of positive/negative
# words in each chapter.

combined_chapter <- group_by(combined_books, chapter)

pos_amount <- filter(combined_chapter, score > 0) %>% summarize(pos_sum = n())

neg_amount <- filter(combined_chapter, score < 0) %>% summarize(neg_sum = n())

# A chapter's overarching feeling will be calculated by the number of positive
# words minus the number of negative words. Create a new column called 
# 'sentiment' with this value.

combined_sentiment <- left_join(pos_amount, neg_amount) %>% mutate(sentiment = pos_sum - neg_sum)

##### CREATE OUR VISUALIZATION #####
# Use ggplot to plot each chapter's sentiment by book.

sentiment_total <- ggplot(data = combined_sentiment) +
  geom_point(aes(x = chapter, y = sentiment))

sentiment_total


