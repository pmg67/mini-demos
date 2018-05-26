# install.packages('recommenderlab')
# install.packages('data.table')
# install.packages('reshape2')
# install.packages('ggplot2')
# install.packages("rvest")

library(recommenderlab)
library(data.table)
library(reshape2)
library(ggplot2)
library(rvest)
library(dplyr)

# Read in the movies and ratings data sets
movies <- read.csv("data/movies.csv", stringsAsFactors = FALSE)
ratings <- read.csv("data/ratings.csv", stringsAsFactors = FALSE)

# Extract genre from movies data frame
genres <- as.data.frame(movies$genres, stringsAsFactors = FALSE)

genres <- as.data.frame(tstrsplit(genres[,1], '[|]', type.convert = TRUE), stringsAsFactors = FALSE)
colnames(genres) <- c(1:10)
genre_list <- c("Action", "Adventure", "Animation", "Children", 
                "Comedy", "Crime","Documentary", "Drama", "Fantasy",
                "Film-Noir", "Horror", "Musical", "Mystery","Romance",
                "Sci-Fi", "Thriller", "War", "Western") 

# Creates a matrix for the number of movies + 1 and the number of genres
genre_matrix <- matrix(0, 9126, 18)
# Set first row to genre list
genre_matrix[1,] <- genre_list
# Set column names to genre list
colnames(genre_matrix) <- genre_list

# Iterate through matrix
for (i in 1:nrow(genres)) {
  for (c in 1:ncol(genres)) {
    genmat_col = which(genre_matrix[1,] == genres[i,c])
    genre_matrix[i + 1,genmat_col] <- 1
  }
}

# Convert the matrix into a data frame
# Remove first row, which was the genre list
genre_matrix <- as.data.frame(genre_matrix[-1,], stringsAsFactors = FALSE) 
# Convert from characters to integers
for (c in 1:ncol(genre_matrix)) {
  genre_matrix[,c] <- as.integer(genre_matrix[,c])  
} 

# Create search matrix

search_matrix <- matrix(0, 9126, 18)

# Create ratings matrix. Rows = userId, Columns = movieId

user_col <- nrow(distinct(ratings, userId))

movie_col <- nrow(distinct(ratings, movieId))

ratings_matrix <- matrix(0, user_col, movie_col)

# Remove userId's
ratings_matrix <- as.data.frame(ratings_matrix[-1,], stringsAsFactors = FALSE)


# Convert rating matrix into a recommenderlab sparse matrix
sparse_matrix <- sparseMatrix(user_col, movie_col)

# Selecting relevant data
# Select minimum number of users per rated movie
# and the minimum views per user
filter_ratings <- group_by(ratings, userId) %>% summarise(n = n()) %>% filter(n == min(n))

# Normalize the data
# Remove bias instances of data 
# Averages the rating for each user to 0
normal_filter <- normalize(filter_ratings, method = "standardize", range = c(0, 1), margin = 1L)


# Define training and set data




# Building the recommendation model



# Applying the recommender system on the original dataset

# No. of recommendations we want per user 



# Recommendations for the first user


# A matrix of recommendations for each user


