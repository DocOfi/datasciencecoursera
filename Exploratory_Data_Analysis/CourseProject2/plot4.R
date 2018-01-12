## setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
## Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999-2008?
## Reading the data in R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
## Attaching neccesary packages 
library(ggplot2)
## Based on the information from the EPA website http://www3.epa.gov/air/emissions/basic.htm, emissions are gouped into 8 major source sectors.  One of these groups is Fuel Combustion.  Within this group, there are 3 that uses coal as fuel.
comb_coal <- grepl("Coal", SCC$EI.Sector)
## Subsetting the data from the SCC data frame
SCC_key <- droplevels(SCC[comb_coal, ])
SCC_EI <- SCC_key[, c(1,4)]
## Using merge and the Source Classification Codes from the data frame SCC to subset the data from the NEI data frame
scc_nei <- merge(SCC_EI,NEI, all.x = TRUE)
## aggregating the data to show the sum of emissions per year and source
agg_EI <- aggregate(Emissions ~ year + EI.Sector, data = scc_nei, sum)
## Changing factor names to provide better visual descriptive terms for the graph
agg_EI$EI.Sector <- gsub("Fuel Comb - Industrial Boilers, ICEs - Coal", "Ind'l Boilers", agg_EI$EI.Sector)
agg_EI$EI.Sector <- gsub("Fuel Comb - Electric Generation - Coal", "Elect Gen", agg_EI$EI.Sector)
agg_EI$EI.Sector <- gsub("Fuel Comb - Comm/Institutional - Coal", "Comm/Inst", agg_EI$EI.Sector)
names(agg_EI) <- c("Year", "Sources", "Emissions")
## Setting the parameters for Plot 4
png("plot4.png",width=480,height=480,units="px")
## Creating the graph
ggplot(agg_EI,aes(x=Year,y=Emissions, fill=Sources), color=Sources) + stat_summary(fun.y=sum, geom="bar") + facet_wrap(~Sources) + ggtitle("Emissions (tons) from \ncoal combustion-related sources (1999-2008)") + ylab("PM25 Emissions (tons)") + xlab("Year (1999, 2002, 2005, 2008)") +  theme(legend.position = "top") + expand_limits(x=c(1997,2009))
## Closing the graphic device
dev.off()
## Based on the data obtained from the United States Environmental Protection Agency on PM25 emissions between 1999 and 2008, there was a decrease in the PM25 emissions from electrical generation sources from 1999 to 2008. A small decline in emissions was observed from commercial/industrial sources. An initial increase in emissions from industrial boilers/ICEs was observed from 1999 to 2002 followed by a decrease in emission from 2002 to 2008. 