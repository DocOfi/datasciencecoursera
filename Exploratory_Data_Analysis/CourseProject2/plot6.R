## setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
## Compare emissions from motor vehicle sources in Baltimore City with 
## emissions from motor vehicle sources in Los Angeles County, 
## California ( fips == "06037" ). Which city has seen greater changes 
## over time in motor vehicle emissions?
## Reading the data in R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
## Attaching neccesary packages 
library(ggplot2)
library(dplyr)
## Based on the information from the EPA website http://www3.epa.gov/air/emissions/basic.htm, emissions are grouped into 8 major source sectors.  One of these groups is Mobile.  Within this group, there are 10 sub-groups.
adv_mv <- grepl("^Mobile", SCC$EI.Sector)
## Subsetting the data from the SCC data frame
SCC_key <- SCC[adv_mv, ]
SCC_mv <- droplevels(SCC[adv_mv, ])
## Removing data we don't need
equip <- grepl("Equipment", SCC_mv$EI.Sector)
all_mv <- SCC_mv[!equip, ]
MV_SCC_EI <- all_mv[, c(1,4)]
## Using the Source Classification Codes (SCC) to Subset the data from the NEI dataset
vehicles <- merge(MV_SCC_EI, NEI, all.x = TRUE)
## Subsetting the data from Baltimore and Los Angeles County
Balt_LA <- droplevels(subset(vehicles, vehicles$fips == "24510" | vehicles$fips== "06037"))
## aggregating the data to show the sum of emissions per year and fips
agg_Balt_LA <- aggregate(Emissions ~ year + fips, data = Balt_LA, sum)
## Changing variable names
names(agg_Balt_LA) <- c("Year", "County", "Emissions")
## Changing factor names to be more descriptive
agg_Balt_LA$County <- gsub("24510", "Baltimore", agg_Balt_LA$County)
agg_Balt_LA$County <- gsub("06037", "Los Angeles", agg_Balt_LA$County)
## Creating a new variable to reflect the changes that occurred over the years from 1999 t0 2008
grp_byc <- group_by(agg_Balt_LA, County)
changes <- mutate(grp_byc, change = Emissions - lag(Emissions))
## Creating seperate data frames for Baltimore and Los Angeles
LA_delta <- filter(changes, County == "Los Angeles")
Balt_delta <- filter(changes, County == "Baltimore")
## Changing NAs to be our basseline value = 0
Balt_delta$change <- c(0, -496.021179, 7.401559, 144.89264)
LA_delta$change <- c(0, 2454.6902, 354.7385, -1878.0913)
## Setting the parameters for Plot 5
png("plot6.png",width=480,height=480,units="px")
## Creating the graph
p <- ggplot() + geom_line(data = Balt_delta, aes(x = Year, y = change, color = "red"), linetype = "dashed", size = 1.5) + geom_line(data = LA_delta, aes(x = Year, y = change, color = "blue"), size = 1.5)  + xlab("Year") + ylab("change") + theme(legend.title = element_text(colour="purple", size=10, face="bold")) + scale_color_discrete(name="County", labels = c("Los Angeles", "Baltimore")) + ggtitle("Changes in PM 25 Emissions from Vehicles\n(relative to the previous year)") + theme(legend.position = c(.3, .15)) + ylab("")
p
## Closing the graphic device
dev.off()
## Based on the data obtained from the United States Environmental Protection Agency on PM25 emissions between 1999 and 2008, there was a greater amount of change in emissions from motor vehicles in Los Angeles compared to Baltimore