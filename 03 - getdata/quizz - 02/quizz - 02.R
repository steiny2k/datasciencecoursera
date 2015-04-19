# create the rawdata directory
if (!file.exists("rawdata")) {
    dir.create("rawdata")
}

# Q1: find the creation time of the datasharing repo in
#     https://api.github.com/users/jtleek/repos

library(httr)
oauth_endpoints("github")
GITHUB_CONSUMER_SECRET <- "42567d27189f80dc40dd1850cae28991fb55c129"
myapp <- oauth_app("github", "13b1c43bd9658a2c7ac3", GITHUB_CONSUMER_SECRET)

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)

req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

library(jsonlite)
jsonData <- fromJSON(content(req, as = "text"))
jsonData[jsonData$name == "datasharing", c("name", "created_at")]
# A1: name           created_at
#     datasharing    2013-11-07T13:25:07Z

# Q2: 
download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", 
    destfile = "rawdata/getdata_data_ss06pid.csv", 
    method = "curl")
library(data.table)
acs <- fread("rawdata/getdata_data_ss06pid.csv")
library(sqldf)

# Q2: Which of the following commands will select only the data for the 
#     probability weights pwgtp1 with ages less than 50?
sqldf("select pwgtp1 from acs where AGEP < 50")
# A2: sqldf("select pwgtp1 from acs where AGEP < 50")

# Q3: Using the same data frame you created in the previous problem, what is 
#     the equivalent function to unique(acs$AGEP)
sqldf("select distinct AGEP from acs")
# A3: sqldf("select distinct AGEP from acs")

# Q4: How many characters are in the 10th, 20th, 30th and 100th lines of HTML 
#     from this page: http://biostat.jhsph.edu/~jleek/contact.html
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
htmlCode <- readLines(url)
lines <- c(nchar(htmlCode[10]), nchar(htmlCode[20]), 
           nchar(htmlCode[30]), nchar(htmlCode[100]))
# A4: 45 31  7 25

# Q5: Read this data set into R and report the sum of the numbers in the fourth
#     of the nine columns.
#     https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",
              destfile = "rawdata/getdata_wksst8110.for",
              method = "curl")

dat <- read.fwf("rawdata/getdata_wksst8110.for", 
                c(-1, 9, -5, 4, 4, -5, 4, 4, -5, 4, 4, -5, 4, 4), skip = 4, 
                col.names = c("week", "Nino12.SST", "Nino12.SSTA", "Nino3.SST", 
                              "Nino3.SSTA", "Nino34.SST", "Nino34.SSTA", 
                              "Nino4.SST", "Nino4.SSTA"))
sum(dat["Nino3.SST"])
# A5: 32426.7