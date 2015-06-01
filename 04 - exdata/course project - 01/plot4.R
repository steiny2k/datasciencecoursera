# load the data into our environment
source("load_data.R")

# Prepare plot 4: Create 2by2 plot matrix
png(filename = "plot4.png")
par(mfrow = c(2, 2))
plot(my.data$TStamp, my.data$Global_active_power, type = "l", xlab = "", 
     ylab = "Global Active Power")
plot(my.data$TStamp, my.data$Voltage, type = "l", xlab = "datetime", 
     ylab = "Voltage")
plot(my.data$TStamp, my.data$Sub_metering_1, type = "l", xlab = "", 
     ylab = "Energy sub metering")
lines(my.data$TStamp, my.data$Sub_metering_2, col = "red")
lines(my.data$TStamp, my.data$Sub_metering_3, col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = c(1,1), bty = "n")
plot(my.data$TStamp, my.data$Global_reactive_power, type = "l", 
     xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
