# create the rawdata directory
if (!file.exists("rawdata")) {
    dir.create("rawdata")
}

# Q1: get the data from the given source
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "rawdata/getdata_data_ss06hid.csv", method = "curl")
fileUrlCodebook <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
download.file(fileUrlCodebook, destfile = "rawdata/getdata_data_PUMSDataDict06.pdf", method = "curl")
dateDownloaded <- date()

# Q1: read the data into R
hid <- read.csv("rawdata/getdata_data_ss06hid.csv")

# Q1: How many properties are worth $1,000,000 or more?
sum(hid$VAL == 24, na.rm = TRUE)
# A1: 53

# Q2: Consider the variable FES in the code book. Which of the "tidy data" 
# principles does this variable violate? 

# A2: Tidy data has one variable per column.

# Q3: 
download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx",
    destfile = "rawdata/getdata_data_DATA.gov_NGAP.xlsx",
    method = "curl")

library(xlsx)
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("rawdata/getdata_data_DATA.gov_NGAP.xlsx", sheetIndex = 1, 
                 rowIndex = rowIndex, colIndex = colIndex)

# Q3: What is the value of: sum(dat$Zip*dat$Ext,na.rm=T)
sum(dat$Zip*dat$Ext,na.rm=T)
# A3: 36534720

# Q4:
download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml",
    destfile = "rawdata/getdata_data_restaurants.xml",
    method = "curl")

library(XML)
doc <- xmlTreeParse("rawdata/getdata_data_restaurants.xml", useInternalNodes = TRUE)
# Q4: How many restaurants have zipcode 21231?
sum(xpathSApply(doc, "//zipcode", xmlValue) == "21231")


# Q5: 
download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv",
    destfile = "rawdata/getdata_data_ss06pid.csv",
    method = "curl")
library(data.table)
DT <- fread("rawdata/getdata_data_ss06pid.csv")
# Q5: Which of the following is the fastest way to calculate the average value 
# of the variable "pwgtp15" broken down by sex using the data.table package?

# Q5.1: mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
# A5.1: User        System      verstrichen 
# A5.1: 0.027       0.003       0.030 

# Q5.2: mean(DT$pwgtp15,by=DT$SEX)
system.time(mean(DT$pwgtp15,by=DT$SEX))
mean(DT$pwgtp15,by=DT$SEX)
# A5.2: does not work by sex

# Q5.3: DT[,mean(pwgtp15),by=SEX]
system.time(DT[,mean(pwgtp15),by=SEX])
DT[,mean(pwgtp15),by=SEX]
# A5.3: User        System      verstrichen 
# A5.3: 0.001       0.000       0.001 

# Q5.4: rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
rowMeans(DT)[DT$SEX==1]
rowMeans(DT)[DT$SEX==2]
# A5.4: does not work. Error: Fehler in rowMeans(DT) : 'x' muss numerisch sein

# Q5.5: tapply(DT$pwgtp15,DT$SEX,mean)
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
tapply(DT$pwgtp15,DT$SEX,mean)
# A5.5: User        System      verstrichen 
# A5.5: 0.001       0.000       0.001 

# Q5.6: sapply(split(DT$pwgtp15,DT$SEX),mean)
sapply(split(DT$pwgtp15,DT$SEX),mean)
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
# A5.6: User        System      verstrichen 
# A5.6: 0.000       0.000       0.001

# A5: DT[,mean(pwgtp15),by=SEX] is fastest...