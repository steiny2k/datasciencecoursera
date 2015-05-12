# create the rawdata directory
if (!file.exists("rawdata")) {
    dir.create("rawdata")
}

# get the data from the given source
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "rawdata/source.zip", method = "curl")
dateDownloaded <- date()

# unzip it
unzip("rawdata/source.zip", exdir="rawdata")

# column titles can be derived from features.txt
# load the data using LaF (Large ASCII Files), as it performs much better
# than the read.fwf, and read.csv / read.table did not really work for me with
# the format.

library(LaF)
library(ffbase)

col.titles <- read.table("rawdata/UCI HAR Dataset/features.txt", sep=" ", as.is = TRUE)
activity.lables <- read.table("rawdata/UCI HAR Dataset/activity_labels.txt", sep=" ", as.is = TRUE)
subject <- list()
dset <- list()
labels <- list()

for (d in c("train", "test")) {
    subject[[d]] <- read.table(paste("rawdata/UCI HAR Dataset/", d, "/subject_", d, ".txt", sep = ""), 
                               col.names = c("subject"))
    
    my.dset.laf <- laf_open_fwf(paste("rawdata/UCI HAR Dataset/", d, "/X_", d, ".txt", sep = ""), 
                                column_types = rep("double", times = 561), 
                                column_widths = rep(16, times = 561), 
                                column_names = col.titles[[2]])
    my.data <- laf_to_ffdf(my.dset.laf)
    dset[[d]] <- as.data.frame(my.data)
    close(my.dset.laf)
    labels[[d]]  <- read.table(paste("rawdata/UCI HAR Dataset/", d, "/y_", d, ".txt", sep = ""), 
                               col.names = c("activity"))
}

# clean up temp objects
rm(my.dset.laf, my.data, d)

library(dplyr)

# bind the training and test datasets together, and combine everything in a
# data.frame with the activity labels and subject numbers attached.
my.data <- bind_cols(bind_rows(dset$train, dset$test), 
                     bind_rows(labels$train, labels$test), 
                     bind_rows(subject$train, subject$test))

# clean up objects we don't need anymore.
rm(dset, labels, subject, col.titles)

# we're only interested in the columns holding mean and standard deviation of
# the X_[train, test].txt file.
# plus the activities in a descriptive way given in file y_[train, test].txt
# joined against the activity_labels.txt file

# drop unnecessary columns
my.data <- select(my.data, 
                  contains("activity"), 
                  contains("subject"), 
                  matches("mean\\.\\.|std\\.\\.", ignore.case = FALSE), 
                  -starts_with("angle.tBodyAccJerkMean..gravityMean."))

# give the activities some meaning ful names
my.data$activity <- factor(my.data$activity)
levels(my.data$activity) <- activity.lables$V2

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

my.summary <- my.data %>%
    group_by(activity, subject) %>%
    summarise_each(funs(mean))

# reshape it into a long list of only 4 columns
library(reshape2)
my.summary.slim <- melt(my.summary, id.vars = c("subject", "activity"))

# save it for submission
write.table(my.summary, "output/5.txt", row.names = FALSE)
write.table(my.summary.slim, "output/5.slim.txt", row.names = FALSE)
