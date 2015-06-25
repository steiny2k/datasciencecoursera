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
library(plyr)
library(dplyr)
library(lubridate)

SCC_mobile <- SCC %>%
    filter(grepl("Vehicle", EI.Sector))

emissions_from_mobile_in_baltimore_and_la <- NEI %>%
    filter(SCC %in% SCC_mobile$SCC) %>%
    filter(fips %in% c('24510', '06037')) %>%
    group_by(year, fips) %>%
    summarise(emission = sum(Emissions))

emissions_from_mobile_in_baltimore_and_la$County <- revalue(
    emissions_from_mobile_in_baltimore_and_la$fips,
    c("24510" = "Baltimore City",
      "06037" = "Los Angeles County, California"))

png(filename = "plot6.png")

ggplot(emissions_from_mobile_in_baltimore_and_la,
       aes(x = year, y = emission,
           colour = County, shape = County)) +
    geom_line() + geom_point() +
    labs(y = expression('Emission of PM'[2.5]*' in tons'),
         title = expression(atop('Sum of PM'[2.5]*' emitted by motor vehicles',
                                 'in Baltimore City vs. Los Angeles')))

dev.off()
