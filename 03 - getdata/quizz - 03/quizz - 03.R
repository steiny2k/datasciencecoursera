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

library(data.table)
dat <- fread("rawdata/getdata_data_ss06hid.csv")
agricultureLogical = dat$ACR==3 & dat$AGS==6
# Q1: What are the first 3 values that result?
which(agricultureLogical)[1:3]
# A1: 125 238 262

# Q2: load jpeg image
library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",
              destfile = "rawdata/getdata_jeff.jpg",
              method = "curl")
ima <- readJPEG("rawdata/getdata_jeff.jpg", native = TRUE)
quantile(ima, probs = c(0.3, 0.8))
# A2: -15259150 -10575416

# Q3: load GDP dataset and cleanse it a little bit
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
              destfile = "rawdata/getdata_data_GDP.csv",
              method = "curl")
dat1 <- read.csv("rawdata/getdata_data_GDP.csv", fileEncoding = "Latin1", 
                 skip = 5, nrows = 231, strip.white = TRUE, header = FALSE)
dat1 <- subset(dat1, select = c(1, 2, 4, 5))
names(dat1) <- c("CountryCode", "Rank", "Country", "GDP")
dat1$GDP <- as.numeric(gsub(",", "", as.character(dat1$GDP)))

# Q3: laod second dataset
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
              destfile = "rawdata/getdata_data_EDSTATS_Country.csv",
              method = "curl")
dat2 <- fread("rawdata/getdata_data_EDSTATS_Country.csv")

# Q3: merge it & order it
dat3 <- merge(dat2, dat1, by = c("CountryCode"))
dat3 <- dat3[order(dat3$Rank, decreasing = TRUE)]

# Q3: How many of the IDs match?
length(dat3$Rank[na.exclude(dat3$Rank)])
# A3: 189

# Q3: 13th country
dat3$Country[13]
# A3: St. Kitts and Nevis

# Q4:
library(dplyr)
dat3 <- rename(dat3, IncomeGroup = `Income Group`)
grouped_avg <- group_by(dat3, IncomeGroup)
summarize(grouped_avg, mean(Rank, na.rm = TRUE))
# A4: 32.96667, 91.91304

# Q5: Cut the GDP ranking into 5 separate quantile groups. Make a table versus 
#     Income.Group. How many countries are Lower middle income but among the 38
#     nations with highest GDP?
dat4 <- cut(dat3$Rank, breaks = 5)
table(dat4, dat3$IncomeGroup)
# A5: 5