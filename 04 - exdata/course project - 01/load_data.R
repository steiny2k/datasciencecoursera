if (!file.exists("rawdata")) {
    dir.create("rawdata")
}

if (!file.exists("rawdata/exdata_data_household_power_consumption.zip")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    dateDownloaded <- date()
    download.file(fileUrl, 
                  "rawdata/exdata_data_household_power_consumption.zip", 
                  method = "curl")
}

library(data.table)
library(lubridate)
library(dplyr)
library(tidyr)

my.data <- fread("unzip -p rawdata/exdata_data_household_power_consumption.zip")
my.data$Date <- dmy(my.data$Date)

# We will only be using data from the dates 2007-02-01 and 2007-02-02.
# Combine Date and Time into a Timestamp object
# Convert the numeric columns from string to numbers
my.data <- my.data %>%
    filter(Date >= dmy("01.02.2007"), Date <= dmy("02.02.2007")) %>%
    mutate(TStamp = Date + hms(Time)) %>%
    select(TStamp, Global_active_power, Global_reactive_power, Voltage, 
           Global_intensity, starts_with("Sub_metering")) %>%
    mutate_each(funs(as.numeric), Global_active_power, Global_reactive_power, 
                Voltage, Global_intensity, starts_with("Sub_metering"))