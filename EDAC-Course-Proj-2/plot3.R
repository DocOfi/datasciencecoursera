## setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
## Of the four types of sources indicated by the type (point, nonpoint,
## onroad, nonroad) variable, which of these four sources have seen 
## decreases in emissions from 1999-2008 for Baltimore City? Which
## have seen increases in emissions from 1999-2008? Use the ggplot2 
## plotting system to make a plot answer this question.
## Reading the data in R
NEI <- readRDS("summarySCC_PM25.rds")
## Attaching neccesary packages 
library(dplyr)
library(ggplot2)
## Converting data frame to tbl_df
nei <- tbl_df(NEI)
## Filtering the data for Baltimore
Balt <-filter(nei, fips == "24510")
## shaping the data
agg_baltl <- aggregate(Emissions ~ year + type, data = Balt, sum)
## Setting the parameters for Plot 3
png("plot3.png",width=480,height=480,units="px")
## Creating the graph
qplot(year, Emissions, data = agg_baltl, group = type, color = type, geom = c("point", "line"), ylab = expression("PM2.5 Emissions (tons)"), xlab = "Year", main = "Air Quality Trend in Baltimore County")
## Closing the graphic device
dev.off()
## Based on the data obtained from the United States Environmental Protection Agency on PM25 levels between 1999 and 2008, there was a decrease in the PM25 emissions from all sources in Baltimore City, Maryland from 1999 to 2008, except from Point type sources between the period of 1999 to 2005. A steep decline in the PM25 emissions however. was observed from Point sources from 2005 to 2008.