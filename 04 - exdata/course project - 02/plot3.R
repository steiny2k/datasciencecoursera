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

emissions_by_type_year_in_baltimore <- NEI %>%
    filter(fips == 24510) %>%
    group_by(year, type) %>%
    summarise(emission = sum(Emissions))

png(filename = "plot3.png")

ggplot(emissions_by_type_year_in_baltimore,
       aes(x = year, y = emission, colour = type, shape = type)) +
    geom_line() +
    geom_point() +
    labs(list(title = "Emissions in Baltimore by type and year",
              y = "Emission in tons"))

dev.off()