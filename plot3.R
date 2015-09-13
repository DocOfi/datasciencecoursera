## Reading the data in R
elec <- read.csv("household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";", na.strings = "?")
## Converting the Date Variable from Character to Date
elec$Date <- as.Date(elec$Date, format = "%d/%m/%Y")
## Subsetting the particular data we need
feb1and2 <- elec[elec$Date >= "2007-02-01" & elec$Date <= "2007-02-02", ]
## Creating a new variable
date_time <- paste(feb1and2$Date, feb1and2$Time)
feb1and2$date_time <- as.POSIXct(date_time)
## Plot 3, setting the parameters
png("plot3.png",width=480,height=480,units="px")
## Creating the plot
plot(feb1and2$date_time, feb1and2$Sub_metering_1, type = "l", xlab = "", ylab = "Energy Sub metering")
lines(feb1and2$date_time, feb1and2$Sub_metering_2, type = "l", col = "red")
lines(feb1and2$date_time, feb1and2$Sub_metering_3, type = "l", col = "blue")
legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1), lwd = c(1, 1), cex = 1, y.intersp = .8)
## Closing the graphic device
dev.off()