## Downloading the data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "household_power_consumption.zip")
dateDownloaded <- date()
print(dateDownloaded)
## [1] "Sun Dec 13 13:02:11 2015"
## Reading the data in R
elec <- read.csv("household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";", na.strings = "?")
## Converting the Date Variable from Character to Date
elec$Date <- strptime(elec$Date, format = "%d/%m/%Y")
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
