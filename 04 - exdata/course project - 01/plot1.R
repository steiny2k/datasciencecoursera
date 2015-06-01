# load the data into our environment
source("load_data.R")

# Prepare plot 1: a histogram of the Global Active Power with red bars
png(filename = "plot1.png")
hist(my.data$Global_active_power, col = "red", main = "Global Active Power",
     xlab = "Global Active Power (kilowats)")
dev.off()

