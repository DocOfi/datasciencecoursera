## Reading the data in R
elec <- read.csv("household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";", na.strings = "?")
## Converting the Date Variable from Character to Date
elec$Date <- as.Date(elec$Date, format = "%d/%m/%Y")
## Subsetting the particular data we need
feb1and2 <- elec[elec$Date >= "2007-02-01" & elec$Date <= "2007-02-02", ]
## Creating a new variable
date_time <- paste(feb1and2$Date, feb1and2$Time)
feb1and2$date_time <- as.POSIXct(date_time)
## Plot 2, setting the parameters
png("plot2.png",width=480,height=480,units="px")
## Creating the plot
plot(feb1and2$Global_active_power~feb1and2$date_time, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
## Closing the graphic device
dev.off()
