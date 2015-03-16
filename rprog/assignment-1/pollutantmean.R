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
  
  # read all files with the id
  files_full <- list.files(directory, full.names = TRUE)
  observations <- do.call(rbind, lapply(files_full[id], read.csv))
  
  mean(observations[[pollutant]], na.rm = TRUE)
}