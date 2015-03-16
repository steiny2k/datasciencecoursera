pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  observations <- NULL
  
  for (i in id) {
    path <- file.path(directory, sprintf("%03d.csv", i))
    local_obs <- read.csv(path)
    if (is.null(observations)) {
      observations <- local_obs
    } else {
      observations <- rbind(observations, local_obs)
    }
  }
  
  mean(observations[[pollutant]], na.rm = TRUE)
}