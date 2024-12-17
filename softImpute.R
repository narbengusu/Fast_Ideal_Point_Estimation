# upload data here

setwd("/Users/bengusunar/Dropbox/movie_lens_data_glmm_recomm/ideal_point_estimation_movie/1M-Clean-Data")

data <- read.csv("1M_wide_df.csv", row.names = 1)
matrixdata = as.matrix(data)
library(softImpute)

#The minimum lambda for solving
minlam = lambda0(matrixdata)

#How to select lambda and rank max????

# Define the function to create the folds
create_folds <- function(data, k) {
  set.seed(123)  # For reproducibility
  non_missing_indices <- which(!is.na(data), arr.ind = TRUE)
  num_indices <- nrow(non_missing_indices)
  
  # Randomly shuffle the indices
  shuffled_indices <- non_missing_indices[sample(num_indices), , drop = FALSE]
  
  # Create folds
  fold_list <- vector("list", k)
  for (i in 1:k) {
    fold_list[[i]] <- shuffled_indices[seq(i, num_indices, by = k), ]
  }
  
  return(fold_list)
}


# Define the function to perform cross-validation
cross_validate <- function(data, lambda_seq, folds) {
  test_errors <- numeric(length(lambda_seq))
  train_errors <- numeric(length(lambda_seq))
  for (i in 1:length(lambda_seq)) {
    fold_test_errors <- numeric(length(folds))
    fold_train_errors <- numeric(length(folds))
    for (j in 1:length(folds)) {
      # Create a copy of the data with some entries removed
      train_data <- data
      test_indices <- folds[[j]]
      train_data[test_indices] <- NA
      
      # Apply SoftImpute
      svd_object <- softImpute(train_data, rank.max = 1, lambda = lambda_seq[i], maxit = 10000)
      imputed_data <- complete(train_data, svd_object)
      
      # Calculate MSE for the test fold
      observed <- data[test_indices]
      predicted <- imputed_data[test_indices]
      fold_test_errors[j] <- mean((observed - predicted)^2, na.rm = TRUE)
      
      # Calculate MSE for the training data (non-missing entries)
      train_indices <- which(!is.na(train_data), arr.ind = TRUE)
      train_observed <- data[train_indices]
      train_predicted <- imputed_data[train_indices]
      fold_train_errors[j] <- mean((train_observed - train_predicted)^2, na.rm = TRUE)
      print(fold_test_errors)
    }
    test_errors[i] <- mean(fold_test_errors)
    print(test_errors[i])
    train_errors[i] <- mean(fold_train_errors)
  }
  return(list(test_errors = test_errors, train_errors = train_errors))
}

# Define cross-validation parameters
k <- 5
lambda_seq <- seq(0, minlam, length.out = 20)

# Create the folds
folds <- create_folds(matrixdata, k)

# Perform cross-validation
cv_results <- cross_validate(matrixdata, lambda_seq, folds)

# Extract test and train errors
test_errors <- cv_results$test_errors

# Find the optimal lambda
optimal_lambda <- lambda_seq[which.min(test_errors)]
optimal_lambda

# Visualization using ggplot2
library(ggplot2)
df <- data.frame(lambda = lambda_seq, error = sqrt(test_errors))
ggplot(df, aes(x = lambda, y = error)) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = optimal_lambda, linetype = "dashed", color = "red") +
  labs(title = "Cross-Validation Error vs Lambda",
       x = "Lambda",
       y = "Test Error (RMSE)") +
  theme_minimal()



svdobject = softImpute(matrixdata, rank.max = 1, lambda = 0)
solution_matrix = complete(matrixdata, svdobject)

setwd("/Users/bengusunar/Dropbox/movie_lens_data_glmm_recomm/ideal_point_estimation_movie/Final-Estimations")

write.csv(solution_matrix, "softImpute_estimations.csv", row.names=FALSE)

