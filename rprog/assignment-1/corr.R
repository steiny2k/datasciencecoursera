corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
  result <- numeric()
  compcases <- complete(directory)
  for (i in compcases$id[compcases$nobs > threshold]) {
    path <- file.path(directory, sprintf("%03d.csv", i))
    local_obs <- read.csv(path)
    result <- append(result, cor(local_obs$sulfate, local_obs$nitrate, use = "complete.obs"))
  }
  
  result
}