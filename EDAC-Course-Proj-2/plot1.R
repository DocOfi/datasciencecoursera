## setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
## Has fine particle pollution in the U.S. decreased from 1999 to 2012?
## Reading the data in R
NEI <- readRDS("summarySCC_PM25.rds")
## Attaching neccesary packages 
library(dplyr)
## Converting data frame to tbl_df
nei <- tbl_df(NEI)
## shaping the data
by_yr <- group_by(nei, year)
total_yrly <- summarise(by_yr, sum(Emissions))
colnames(total_yrly) <- c("Year", "Emissions")
## Setting the parameters for Plot 1
png("plot1.png",width=480,height=480,units="px")
## Creating the barplot
barplot(total_yrly$Emissions, names.arg = c("1999", "2002", "2005", "2008"), xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Air Quality Trends, USA", col = rainbow(20), cex.axis = 1, cex.names = 1, legend.text = c("1999", "2002", "2005", "2008"), args.legend = c(cex = 1))
## Closing the graphic device
dev.off()
## Based on the data obtained from the United States Environmental Protection Agency on PM25 levels between 1999 and 2008, there was a decrease in the total PM25 emissions in the United States of America.