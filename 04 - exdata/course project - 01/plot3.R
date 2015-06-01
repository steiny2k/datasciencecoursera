# load the data into our environment
source("load_data.R")

# Prepare plot 3: 
png(filename = "plot3.png")
plot(my.data$TStamp, my.data$Sub_metering_1, type = "l", xlab = "", 
     ylab = "Energy sub metering")
lines(my.data$TStamp, my.data$Sub_metering_2, col = "red")
lines(my.data$TStamp, my.data$Sub_metering_3, col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = c(1,1))
dev.off()
