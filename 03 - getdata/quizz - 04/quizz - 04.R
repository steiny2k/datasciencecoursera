# create the rawdata directory
if (!file.exists("rawdata")) {
    dir.create("rawdata")
}

# Q1: get data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",
              destfile = "rawdata/getdata_data_ss06hid.csv",
              method = "curl")

# Q1: get code book
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf",
              destfile = "rawdata/getdata_data_PUMSDataDict06.pdf",
              method = "curl")
# Q1: load data
library(data.table)
dat <- fread("rawdata/getdata_data_ss06hid.csv")
# Q1: Apply strsplit() to split all the names of the data frame on the 
#     characters "wgtp". What is the value of the 123 element of the resulting 
#     list?
strsplit(names(dat), "wgtp")[123]
# A1: ""   "15"

# Q2: get data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
              destfile = "rawdata/getdata_data_GDP.csv",
              method = "curl")

# Q2: load data
dat1 <- read.csv("rawdata/getdata_data_GDP.csv", fileEncoding = "Latin1", 
                 skip = 5, nrows = 231, strip.white = TRUE, header = FALSE)
dat1 <- subset(dat1, select = c(1, 2, 4, 5))
names(dat1) <- c("CountryCode", "Rank", "Country", "GDP")

# Q2: Remove the commas from the GDP numbers in millions of dollars and average
#     them. What is the average?
dat1$GDP <- as.numeric(gsub(",", "", as.character(dat1$GDP)))
mean(dat1$GDP[ 1:190 ])
# A2: 377652.4

# Q3: In the data set from Question 2 what is a regular expression that would 
#     allow you to count the number of countries whose name begins with 
#     "United"? Assume that the variable with the country names in it is named 
#     countryNames. How many countries begin with United?
countryNames <- dat1$Country
grep("^United",countryNames)
length(grep("^United",countryNames))
# A3: grep("^United",countryNames), 3

# Q4: load second dataset
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
              destfile = "rawdata/getdata_data_EDSTATS_Country.csv",
              method = "curl")

# Q4: load data and link to dat1
dat2 <- fread("rawdata/getdata_data_EDSTATS_Country.csv")
dat3 <- merge(dat2, dat1, by = c("CountryCode"))

# Q4: Of the countries for which the end of the fiscal year is available, how 
#     many end in June?
length(grep("Fiscal year end: June", dat3[["Special Notes"]]))
# A4: 13

# Q5: Use the following code to download data on Amazon's stock price and get 
#     the times the data was sampled.
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
# Q5: How many values were collected in 2012?
#     How many values were collected on Mondays in 2012?
library(lubridate)
sampleTimes <- ymd(sampleTimes)
y2012 <- year(sampleTimes) == '2012'
sum(y2012)
sum(wday(sampleTimes[y2012]) == 2)
# A5: 250, 47


