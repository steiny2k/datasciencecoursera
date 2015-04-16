
# get the data from the given source
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "rawdata/source.zip", method = "curl")
dateDownloaded <- date()

# unzip it
unzip("rawdata/source.zip", exdir="rawdata")
