if (!file.exists("rawdata")) {
    dir.create("rawdata")
}

if (!file.exists("rawdata/exdata_data_NEI_data.zip")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    dateDownloaded <- date()
    download.file(fileUrl,
                  "rawdata/exdata_data_NEI_data.zip",
                  method = "curl")
}

if (!( file.exists("rawdata/Source_Classification_Code.rds") ||
       file.exists("rawdata/summarySCC_PM25.rds"))) {
    unzip("rawdata/exdata_data_NEI_data.zip", exdir = "rawdata")
}

# load the source data into environment
NEI <- readRDS("rawdata/summarySCC_PM25.rds")
SCC <- readRDS("rawdata/Source_Classification_Code.rds")
