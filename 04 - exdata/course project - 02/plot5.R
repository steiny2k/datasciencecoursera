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

library(ggplot2)
library(dplyr)
library(lubridate)

SCC_mobile <- SCC %>%
    filter(grepl("Vehicle", EI.Sector))

emissions_from_mobile_in_baltimore <- NEI %>%
    filter(SCC %in% SCC_mobile$SCC) %>%
    filter(fips == 24510) %>%
    group_by(year) %>%
    summarise(emission = sum(Emissions))

png(filename = "plot5.png")

plot(emission ~ year, emissions_from_mobile_in_baltimore, type="l",
     xlab = "year",
     ylab = expression('Emission of PM'[2.5]*' in tons'),
     main = expression('Sum of PM'[2.5]*' emitted by motor vehicles in Baltimore City'))

dev.off()
