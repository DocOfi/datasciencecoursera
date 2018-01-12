## setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland ( fips == "24510" ) from ##1999 to 2008? Use the base 
## plotting system to make a plot answering this question.
## Reading the data in R
NEI <- readRDS("summarySCC_PM25.rds")
## Attaching neccesary packages 
library(dplyr)
## Converting data frame to tbl_df
nei <- tbl_df(NEI)
## Filtering the data for Baltimore
Balt <-filter(nei, fips == "24510")
## shaping the data
tap_balt <- with(Balt, tapply(Emissions, list(year, type), sum))
tap_balt <- as.data.frame(tap_balt)
tap_balt_df <- mutate(tap_balt, Year = rownames(tap_balt))
tap_balt_df <- select(tap_balt_df, c(5, 1:4))
names(tap_balt_df) <- gsub("-", "_", names(tap_balt_df))
agg_baltm <- aggregate(Emissions ~ year, data = Balt, sum)
names(agg_baltm) <- c("Year", "TOTAL")
mrg_balt <- merge(tap_balt_df, agg_baltm)
## Setting the parameters for Plot 2
png("plot2.png",width=480,height=480,units="px")
## Creating the graph
plot(mrg_balt$Year, mrg_balt$TOTAL, type = "b", lty = 1, lwd = 2, xlab = "Years (1999-2008)", ylab = "PM 2.5 Emissions", xlim=c(1999,2008), ylim=c(50,3300), main = "Baltimore")
points(mrg_balt$Year, mrg_balt$NON_ROAD, type = "b", lty = 2, lwd = 2, col = "red")
points(mrg_balt$Year, mrg_balt$NONPOINT, type = "b", lty = 3, lwd = 2, col = "blue")
points(mrg_balt$Year, mrg_balt$ON_ROAD, type = "b", lty = 4, lwd = 2, col = "green")
points(mrg_balt$Year, mrg_balt$POINT, type = "b", lty = 5, lwd = 2,col = "orange")
legend("topright", col = c("black", "red", "blue", "green", "orange" ), c("TOTAL", "Non-road", "Non-point", "On-road", "Point"), lty = c(1, 2, 3, 4, 5), lwd = 2, cex = .8)
## Closing the graphic device
dev.off()
## Based on the data obtained from the United States Environmental Protection Agency on PM25 levels between 1999 and 2008, there was a decrease in the total PM25 emissions in Baltimore City, Maryland from 1999 to 2008.  However, there was an increase in total PM 25 emisions during the intervening period of 2002 and 2005, primarily due to an increase in PM25 levels from Point type sources. 
