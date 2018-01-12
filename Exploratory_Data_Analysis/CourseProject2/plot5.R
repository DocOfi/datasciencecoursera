## setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
## How have emissions from motor vehicle sources changed from 1999-2008
##in Baltimore City?
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
## Subsetting the data from Baltimore
Balt_mv <- droplevels(subset(vehicles, vehicles$fips == "24510"))
## aggregating the data to show the sum of emissions per year and source
agg_Balt_mv <- aggregate(Emissions ~ year + EI.Sector, data = Balt_mv, sum)
## Changing variable names
names(agg_Balt_mv) <- c("Year", "Sources", "Emissions")
## Removing data for aircraft as there is only one entry and therefore does not show a trend
no_plane <- filter(agg_Balt_mv, Sources != "Aircraft")
## Changing factor names in the variable Sources
no_plane$Sources <- gsub("Mobile - Commercial Marine Vessels", "watercraft", no_plane$Sources)
no_plane$Sources <- gsub("Mobile - Locomotives", "Trains", no_plane$Sources)
no_plane$Sources <- gsub("Mobile - On-Road Diesel Heavy Duty Vehicles", "Hvy_Cars Diesel", no_plane$Sources)
no_plane$Sources <- gsub("Mobile - On-Road Diesel Light Duty Vehicles", "Lite_Cars Diesel", no_plane$Sources)
no_plane$Sources <- gsub("Mobile - On-Road Gasoline Heavy Duty Vehicles", "Hvy_Cars Gas", no_plane$Sources)
no_plane$Sources <- gsub("Mobile - On-Road Gasoline Light Duty Vehicles", "Lite_Cars Gas", no_plane$Sources)
## Setting the parameters for Plot 5
png("plot5.png",width=480,height=480,units="px")
## Creating the graph
g <- ggplot(data = no_plane, aes(x = Year, y = Emissions, color = Sources))
g + geom_point(aes(size = Sources), shape = 21) + geom_line(aes(linetype = Sources), size = 1.5) + xlab("Year (1999-2008)") + ylab("PM25 Emissions (tons)") + ggtitle("Baltimore County \nEmissions from Motor Vehicles (1999-2008)") + theme(legend.position=c(.5, .7)) + theme(legend.background = element_rect(fill="gray60")) + theme(legend.text = element_text(colour="dark blue"))
## Closing the graphic device
dev.off()
## Based on the data obtained from the United States Environmental Protection Agency on PM25 emissions between 1999 and 2008, emissions from motor vehicles were decreasing except for emissions coming from watercrafts which showed an increasing trend from 2002 to 2008
