# load the data into our environment
source("load_data.R")

# Prepare plot 2: a line-plot of the time-series of Global Active Power over the 
# two day period
png(filename = "plot2.png")
plot(my.data$TStamp, my.data$Global_active_power, type = "l", xlab = "", 
     ylab = "Global Active Power (kilowatts)")
dev.off()
