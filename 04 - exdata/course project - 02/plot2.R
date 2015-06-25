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

library(dplyr)
library(lubridate)

emission_by_year_in_baltimore <- NEI %>%
    filter(fips == 24510) %>%
    group_by(year) %>%
    summarise(emission = sum(Emissions)) %>%
    mutate(date_year = years(year))


png(filename = "plot2.png")

plot(emission ~ year, emission_by_year_in_baltimore, type="l",
     xlab = "year",
     ylab = expression('Emission of PM'[2.5]*' in tons'),
     main = expression('Sum of PM'[2.5]*' emitted over years in Baltimore'))

dev.off()