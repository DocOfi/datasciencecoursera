---
title: "Plotting using Metricsgraphics"
author: "Edmund julian L Ofilada"
date: "January 22, 2018"
output: 
        html_document:
                keep_md: TRUE

---



### Plotting using the Metricsgraphics package

This document was created as an introduction for students of the Coursera course Exploratory Data Analysis offered by Johns Hopkins University to the plotting functions in the package metricgraphics. While trying to learn how to use the the package metricgraphics, I thought to myself, this could have been very useful for me when I was taking the Exploratory Data Analysis Course. The document is patterned after the course project 2 assignment for the course. 

The example plots provided for in this document borrowed heavily from the vignette, [Introduction to metricsgraphics](http://cran.r-project.org/web/packages/metricsgraphics/vignettes/introductiontometricsgraphics.html) by Bob Rudis.  Bob Rudis is the author and maintainer of the package metricsgraphics. You can find him in Github at http://github.com/hrbrmstr/metricsgraphics. The functions and syntax for using metricgraphics are easy to learn and it provides a nice interface for the presentation of plots.

The content of this document borrowed heavily from the datascience specialization course offered by Coursera. Particularly, from the presentations of Roger D. Peng, Associate Professor of Biostatistics Johns Hopkins Bloomberg School of Public Health. I took the course in 2015 and up to now the content still manages to teach me something new, whenever I re-visit it. While figuring out how to work git and GitHub, I accidentally, cloned the whole content of the course from GitHub. It was such a large file and took forever to download. I was eating at a fastfood chain using their wifi as I didn't have wifi of my own. The waiters and managers where giving me the eye suggesting that I order again, since I was in there for more than an hour already. it was a mistake worth repeating over and over again.

The datascience course will probably be remade as some years has passed since it was launched and there has been so much new development in terms of packages in R. This presentation tries to show how a new package may fit in learning the concepts of the Exploratory Data Analysis Course.

### Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the <a href="http://www.epa.gov/ttn/chief/eiinformation.html">EPA National Emissions Inventory web site</a>.

For each year and for each type of PM source, the NEI records show how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

### Data

The data for this assignment are available from the course web site as a single zip file:

<a href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip">Data for Peer Assessment</a> [29Mb]
The zip file contains two files:

PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

|    |   fips  |   SCC   | Pollutant  | Emissions |  type  |  year  |
|--- | ------- | ------- | ---------- | --------- | ------ | ------ |   
| 4  |  09001  | 10100401|  PM25-PRI  |  15.714   |  POINT |  1999  |
| 8  |  09001  | 10100404|  PM25-PRI  | 234.178   |  POINT |  1999  |
| 12 |  09001  | 10100501|  PM25-PRI  |   0.128   |  POINT |  1999  |
| 16 |  09001  | 10200401|  PM25-PRI  |   2.036   |  POINT |  1999  |
| 20 |  09001  | 10200504|  PM25-PRI  |   0.388   |  POINT |  1999  |

* <b>fips</b>: A five-digit number (represented as a string) indicating the U.S. county

* <b>SCC</b>: The name of the source as indicated by a digit string (see source code classification table)

* <b>Pollutant</b>: A string indicating the pollutant

* <b>Emissions</b>: Amount of PM2.5 emitted, in tons

* <b>type</b>: The type of source (point, non-point, on-road, or non-road)

* <b>year</b>: The year of emissions recorded

Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source "10100101" is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".

### loading the packages we'll need


```r
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(htmltools)
library(metricsgraphics)
# this lets us add a title to the plot since the package follows the guidance
# of the htmlwidgets authors and does not include the MetricsGraphics.js title
# option to ensure consistent div sizing.

show_plot <- function(plot_object, title) {
  div(style="margin:auto;text-align:center", strong(title), br(), plot_object)
}
```

You can read each of the two files using the readRDS() function in R. For example, reading in each file can be done with the following code:

### Reading in the data 


```r
NEI <- readRDS("DATA/summarySCC_PM25.rds")             ###Reading in the data 
SCC <- readRDS("DATA/Source_Classification_Code.rds")  ###Reading in the data 
```

as long as each of those files is in your current working directory (check by calling dir() and see if those files are in the listing).

### Questions

<p style="color: darkblue">We will ask a series of questions and allow the plots to provide the answers. Plots contstructed well can convey more in a single glance than a sentence of words.</p>.

#### 1. Have total emissions from PM2.5 in Fresno county, California (fips = 06019) decreased from 1999 to 2008? .

<br>


```r
fresno <-filter(NEI, fips == "06019")                ### Subset data to only include fresno county
fresno_by_yr <- fresno %>%                           ### take the data of fresno county
        group_by(year) %>%                           ### group the data by year
        summarize(Total_Emissions = sum(Emissions))  ### summarize emissions by taking their sum
```


```r
fresno_by_yr %>% 
        mjs_plot(y = year,                                   ### plot variable year on y-axis    
                 x = Total_Emissions,                        ### Plot Total Emission on x-axis
                 width = 800,                                ### set width of plot to 800 pixels
                 height = 400) %>%                           ### set height of plot to 800 pixels
        mjs_bar() %>%                                        ### plot a bar graph
        mjs_axis_x(xax_format = 'plain') %>%                 ### set x-axis format to plain
        mjs_labs(x="Year", y="PM2.5 Emissions (tons)") %>%   ### add axis labels
        show_plot("Air Quality Trends - Fresno County, CA")  ### provide title for the plot
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>Air Quality Trends - Fresno County, CA</strong>
<br/>
<div id="mjs-5609882363ab9a3631f4caee714435" class="metricsgraphics html-widget" style="width:800px;height:400px;"></div>
<div id="mjs-5609882363ab9a3631f4caee714435-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-5609882363ab9a3631f4caee714435">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"year":["1999","2002","2005","2008"],"Total_Emissions":[12184.438,7033.9207931812,15914.1830706848,8652.64486440427]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"bar","xax_format":"plain","x_label":"Year","y_label":"PM2.5 Emissions (tons)","markers":null,"baselines":null,"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_y":null,"max_y":null,"bar_margin":1,"binned":true,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"Total_Emissions","y_accessor":"year","multi_line":null,"geom":"bar","yax_units":"","legend":null,"legend_target":null,"y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-5609882363ab9a3631f4caee714435"},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

<br>

#### 2. Have total emissions from PM2.5 decreased in the Laramie County, Wyoming (fips = 56021) from 1999 to 2008?

<br>




```r
laramie_by_yr %>% 
        mjs_plot(x = year,                                   ### plot variable year on x-axis
                 y = Total_Emissions,                        ### plot Total_Emission on y-axis
                 width = 800,                                ### set width of plot to 800 pixels
                 height = 400) %>%                           ### set height to 400
        mjs_line(area = TRUE) %>%                            ### plot a line and shade the area below
        mjs_axis_x(xax_format = 'plain') %>%                 ### format x-axis as plain
        mjs_labs(x="Year", y="PM2.5 Emissions (tons)") %>%   ### add axis labels
        show_plot("Air Quality Trends - Laramie County, WY") ### provide title for plot
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>Air Quality Trends - Laramie County, WY</strong>
<br/>
<div id="mjs-8746227e0531492d87cf7273c33c76" class="metricsgraphics html-widget" style="width:800px;height:400px;"></div>
<div id="mjs-8746227e0531492d87cf7273c33c76-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-8746227e0531492d87cf7273c33c76">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"year":[1999,2002,2005,2008],"Total_Emissions":[5850.98,3671.26151879024,3661.83069003998,2799.72274074635]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"line","xax_format":"plain","x_label":"Year","y_label":"PM2.5 Emissions (tons)","markers":null,"baselines":null,"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":true,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"year","y_accessor":"Total_Emissions","multi_line":null,"geom":"line","yax_units":"","legend":null,"legend_target":null,"y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-8746227e0531492d87cf7273c33c76","animate_on_load":false},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

<br>

#### 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Fresno County? Which have seen increases in emissions from 1999-2008? 

<br>




```r
fresno_by_yr_type %>%                   ### take the summarized fresno data and
  mjs_plot(x=year,                      ### plot the variable year on the x-axis
           y=NON.ROAD,                  ### plot the variable NON>ROAD on the y axis
           width=800,                   ### set plot width to 800 pixels
           height=400) %>%              ### set plot height to 400 pixels
  mjs_line() %>%                        ### create a line plot
  mjs_add_line(NONPOINT) %>%            ### plot another line with the variable NONPOINT
  mjs_add_line(ON.ROAD) %>%             ### plot another line with the variable ON.ROAD
  mjs_add_line(POINT) %>%               ### plot another line with the variable POINT  
  mjs_axis_x(xax_format="plain") %>%    ### format x-axis as plain
  mjs_labs(x="PM2.5 Emissions (tons)", y="Year") %>%   ### add axis labels
  mjs_add_legend(legend=c("NON-ROAD", "NONPOINT", "ON-ROAD", "POINT")) %>%    ### add legend to plot
  show_plot("PM2.5 emission According to Sources, Fresno County, California") ### add title
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>PM2.5 emission According to Sources, Fresno County, California</strong>
<br/>
<div id="mjs-633a61e24823e92427217d6dddace8" class="metricsgraphics html-widget" style="width:800px;height:400px;"></div>
<div id="mjs-633a61e24823e92427217d6dddace8-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-633a61e24823e92427217d6dddace8">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"year":[1999,2002,2005,2008],"NON.ROAD":[701.83,626.52,569.31,487.456712],"NONPOINT":[10734.528,5230.55,13835.83,6922.324309601],"ON.ROAD":[420.05,780.2767013087,816.320158524568,814.0965],"POINT":[328.03,396.5740918725,692.722912160211,428.767342803268]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"line","xax_format":"plain","x_label":"PM2.5 Emissions (tons)","y_label":"Year","markers":null,"baselines":null,"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"year","y_accessor":"NON.ROAD","multi_line":["NONPOINT","ON.ROAD","POINT"],"geom":"line","yax_units":"","legend":["NON-ROAD","NONPOINT","ON-ROAD","POINT"],"legend_target":"#mjs-633a61e24823e92427217d6dddace8-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-633a61e24823e92427217d6dddace8","animate_on_load":false},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

<br>

#### 4. Comparing Laramie county with Fresno county, which county had a more sustained decline in Pm2.5 emissions from 1999-2008?

<br>


```r
fresno_by_yr$year <- gsub("CST", "", strptime(fresno_by_yr$year, "%Y"))   ### format variable year
fresno_by_yr$year <- gsub("25", "01", fresno_by_yr$year)                  ### change 25 to 01
fresno_by_yr$year <- as.factor(fresno_by_yr$year)                         ### set year as factor
fresno_by_yr$Total_Emissions <- as.integer(round(fresno_by_yr$Total_Emissions))  ### set Total_ Emission as integer
names(fresno_by_yr) <- c("date", "value")                                 ### change variable names
laramie_by_yr$year <- gsub("CST", "", strptime(laramie_by_yr$year, "%Y")) ### format variable year
laramie_by_yr$year <- gsub("25", "01", laramie_by_yr$year)                ### change 25 to 01
laramie_by_yr$year <- as.factor(laramie_by_yr$year)                       ### set year as factor
laramie_by_yr$Total_Emissions <- as.integer(round(laramie_by_yr$Total_Emissions))  ### set Total_ Emission as integer
names(laramie_by_yr) <- c("date", "value")                                ### change variable names

fresno_by_yr %>%                       ### take the summarized fresno data by year
  mjs_plot(x = date,                   ### assign the variable date to the x-axis
           y = value,                  ### assign the variable value to the y-axis
           width = 800,                ### set the width of the plot to 800 pixels
           height = 300,               ### set the height of th plot to 300 pixels
           linked = TRUE) %>%          ### link the two plots
  mjs_axis_x(xax_format = "date",      ### format x-axis as date
             xax_count = 4) %>%        ### set the ticks to 4
  mjs_labs(x="Year", y="PM2.5 Emissions (tons)") %>%   ### add axis labels        
  mjs_line(area = TRUE) -> mjs_brief_1 ### assign  name for linking

laramie_by_yr %>%                      ### take the summarized laramie data by year
  mjs_plot(x = date,                   ### assign the variable date to the x-axis
           y = value,                  ### assign the variable value to the y-axis
           width = 800,                ### set the width of the plot to 800 pixels
           height = 300,               ### set the height of th plot to 300 pixels
           linked = TRUE) %>%          ### link the two plots
  mjs_axis_x(xax_format = "date",      ### format x-axis as date
             xax_count = 4) %>%        ### set the ticks to 4
  mjs_labs(x="Year", y="PM2.5 Emissions (tons)") %>%   ### add axis labels 
  mjs_line() -> mjs_brief_2            ### assign name for linking

div(style="margin:auto;text-align:center",            ### align text to center
    strong("Fresno County, CA"), br(), mjs_brief_1,   ### set first text to bold
    strong("Laramie County, WY"), br(), mjs_brief_2)  ### set second text to bold
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>Fresno County, CA</strong>
<br/>
<div id="mjs-c869fd05be227710e7fea055b48f1b" class="metricsgraphics html-widget" style="width:800px;height:300px;"></div>
<div id="mjs-c869fd05be227710e7fea055b48f1b-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-c869fd05be227710e7fea055b48f1b">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"date":["1999-02-08","2002-02-08","2005-02-08","2008-02-08"],"value":[12184,7034,15914,8653]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"line","xax_format":"date","x_label":"Year","y_label":"PM2.5 Emissions (tons)","markers":null,"baselines":null,"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":4,"x_rug":false,"y_rug":false,"area":true,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"date","y_accessor":"value","multi_line":null,"geom":"line","yax_units":"","legend":null,"legend_target":null,"y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-c869fd05be227710e7fea055b48f1b","animate_on_load":false},"evals":[],"jsHooks":[]}</script>
<strong>Laramie County, WY</strong>
<br/>
<div id="mjs-177c458c6588da8a716d5ea17bbe2b" class="metricsgraphics html-widget" style="width:800px;height:300px;"></div>
<div id="mjs-177c458c6588da8a716d5ea17bbe2b-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-177c458c6588da8a716d5ea17bbe2b">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"date":["1999-02-08","2002-02-08","2005-02-08","2008-02-08"],"value":[5851,3671,3662,2800]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"line","xax_format":"date","x_label":"Year","y_label":"PM2.5 Emissions (tons)","markers":null,"baselines":null,"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":4,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"date","y_accessor":"value","multi_line":null,"geom":"line","yax_units":"","legend":null,"legend_target":null,"y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-177c458c6588da8a716d5ea17bbe2b","animate_on_load":false},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

<br>

#### Annual average PM2.5 averaged over the period 2008 through 2010

If i didn't accidentally downloaded the whole content of the datascience course repository from GitHub, I wouldn't have been able to find the various goodies stored within them. For example, there was a video presentation by Roger Peng on the 4th week of the course but the link to download the csv file used for the presentation was the not provided.

Within the folders of the repository I downloaded, I found the R mardown files used to make the wondeful ioslide presentations as well as the csv file containing the averaged PM2.5 over the period from 2008 to 2010.

We will now take a look at that file containing the averaged PM2.5 emissions in the USA from 2008 to 2010. The file according to Roger Peng comes from the [U.S. Environmental Protection Agency (EPA)](http://www.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm). 

<br>


```r
pollution <- read.csv("DATA/avgpm25.csv",               ### file to read
                      colClasses = c("numeric",         ### set column classes
                                     "character",
                                     "factor",
                                     "numeric",
                                     "numeric"))
head(pollution)                                         ### show first 6 rows of data
```

```
##        pm25  fips region longitude latitude
## 1  9.771185 01003   east -87.74826 30.59278
## 2  9.993817 01027   east -85.84286 33.26581
## 3 10.688618 01033   east -87.72596 34.73148
## 4 11.337424 01049   east -85.79892 34.45913
## 5 12.119764 01055   east -86.03212 34.01860
## 6 10.827805 01069   east -85.35039 31.18973
```

<br>

PM2.5 Emissions Data (avgpm25.csv): This file contains a data frame of the annual average PM2.5 Emissions, averaged over the period 2008 through 2010. Please take note that unlike the previous dataset we explored, where the PM 2.5 Emissions were reported in units of tons, the units for the PM 2.5 Emissions levels in the current dataset we are exploring, are in micrograms per meter cube ($\mu g/m^3$)

<br>

The variables in the dataset are the following:

- `pm2.5` - particulate matter measured in micrograms per meter cube ($\mu g/m^3$)
- `fips` - A five-digit number (represented as a string) indicating the U.S. county
- `region` - a factor which tells the location from where the observation was taken (west/east)
- `longitude` - geospatial location in longitude
- `latitude` - geospatial location in latitude 

<br>


```r
summary(pollution$pm25)                                 ### 5-number summary
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   3.383   8.549  10.047   9.836  11.356  18.441
```

<br>

The highest average PM2.5 emission for a county was $18.4~\mu g/m^3$ while the lowest was $3.8~\mu g/m^3$.   

<br>      
      
#### 5. What is the distribution of averaged PM2.5 emissions across the USA from 2008 through 2010?

<br>


```r
pollution %>% 
        mjs_plot(pm25,                                  ### variable to plot on x-axis
                 width="500px") %>%                     ### width of plot in pixels
        mjs_histogram(bar_margin=2) %>%                 ### type of plot, space between bars =2
        mjs_labs(x_label="PM2.5 Emissions (??g/m3") %>% ### add label on x-axis
        mjs_add_marker(12, "national standard") %>%     ### add horizontal line and label
        show_plot("Average PM2.5 Emissions Across the USA")   ### add title
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>Average PM2.5 Emissions Across the USA</strong>
<br/>
<div id="mjs-4d5b2684844e9f1782a43315b0f64c" class="metricsgraphics html-widget" style="width:500px;height:500px;"></div>
<div id="mjs-4d5b2684844e9f1782a43315b0f64c-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-4d5b2684844e9f1782a43315b0f64c">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":[9.77118522614686,9.99381725284814,10.6886181012839,11.3374236874237,12.1197644686119,10.8278048723489,11.5839280137523,11.2619958748527,9.41442269955754,11.3914937063423,12.3847949521764,10.6495003064202,11.3338213580728,12.3024361179754,11.0245082815735,6.05886019051495,11.1014667422525,7.30811257305026,7.14762626262626,6.92984404484405,6.132350718065,8.22833917280753,5.3284750021471,10.5028619597453,11.3264992137362,5.16541323932628,10.8355150496786,10.4362348272642,11.1147433188335,10.8231569069069,10.7455228065043,10.4503506375228,10.7239588859416,10.4417366946779,11.0976451597588,11.8400858533296,11.1050030345373,10.8870238095238,10.6965244667289,10.641452991453,9.46590188607592,9.84229717813051,6.76874278843292,6.94475890985325,8.54517291213449,16.1945239442507,7.19696623951355,9.41794677963536,6.43133065191889,15.803779721076,18.4407314017251,3.49435096561789,16.6618011295383,8.15131805731041,15.0157326718079,6.45565456155149,5.28099869664386,14.5062723406882,7.96918321142459,9.67839312107419,17.4290486592135,9.67934206826549,5.99577421686427,9.84362711860765,10.7410869231163,11.5600218772021,7.30846636864851,8.99963596301318,8.41596420305724,9.84144647290684,6.19679173840357,5.5605463980464,5.70241404638811,10.0994598549599,6.9254031864888,16.2519038272246,7.30965689062766,16.1835830784913,9.61713614709045,7.7050032488629,8.46951893407169,6.65466368191024,6.77176468914163,7.73387698622957,5.73200461553332,4.18609021246952,5.97189954174968,6.61487829803047,9.32877602411928,6.27593990755008,7.68074488100719,9.82177829367954,8.89481883497206,7.02987073611182,10.001609188939,8.82187485318614,10.4129542695584,11.5517555159747,10.8377180079334,11.0238225610986,7.50346095206785,6.87720081743389,6.9775362209526,7.37522901571828,8.3783776391644,8.96184160987206,8.3415452544009,6.74496639545312,9.79596697012138,5,7.28553506718511,6.34854026253636,7.73819636495411,7.67951903770358,7.58490910924539,6.8008151008151,7.50035481331534,7.21377345515277,11.9592084944023,10.8244700530908,11.2922785144695,12.9139027854494,12.018415914295,12.1454136960407,11.746439215797,11.8178209192191,9.79381248890527,12.1452780063074,11.1883344861037,11.4223252694182,9.70988046483951,12.2006601852966,10.9490592810391,12.392874647024,10.6727069308928,11.3584635917969,12.1213807083732,6.82441875383051,5.78351927988093,5.6939448645207,10.3294045074514,4.91714043782155,10.7924482408342,8.8466406534255,10.3763269924492,12.4378980220572,13.3469102904998,9.35373976746836,11.059005118607,11.8780076805531,10.9013088512241,11.2698378522063,10.336829004329,10.5814567968035,9.2564950627936,10.2752187901461,10.003862064924,10.4695875139353,11.6319264428935,12.702122831133,11.1160700016684,10.1047342756054,9.65526315789474,12.3310604774049,11.0390648425787,10.5051792723394,10.0347250809987,13.0931187500138,13.1446592093778,11.8553016640881,13.0239225555372,12.0461756061115,12.3671405767727,11.630028527498,11.4432521852433,11.6924524127122,11.8117812795938,12.7532869466665,10.6469459530144,12.0895111242388,13.8832168707687,12.1973541767198,13.4352543307883,12.224040041983,12.1950547177351,12.8288775395985,12.2609157118629,10.4736962770473,11.6990452738192,10.9172629816653,11.1236639236879,10.407355367073,9.28889224065695,12.679210751879,8.82850404312669,9.40201510835567,10.8313455499634,11.9607604301067,9.28110499880411,8.93896188478685,9.33779024592978,9.05711530713215,9.32216152841153,8.68183331819695,9.7411819651878,11.2818263607737,11.405536872264,12.6653247822665,11.8011875934401,9.68513234753605,11.3224653698792,12.0517527673095,12.3957936523464,11.1037138188609,11.7650292954172,11.8591950782035,13.0588135499759,11.9036446011229,11.6700302343159,10.3434330163497,11.5546621879169,10.0901497369687,11.5114626909954,10.8511742051786,8.87430973517136,9.97039679617448,9.76181836142642,9.07945329347656,9.79997038240766,9.70396147150449,8.89871776296726,12.1783537749805,9.13448640646916,8.52827622014538,11.8026775921897,7.79428610906411,6.16244323094984,8.18271314335201,4.50453934354474,7.33442566054635,8.25966374269006,7.38414669783752,5.18625013760234,11.4394020016885,11.0231924080553,11.6654863989306,9.52946522657514,10.6695080583002,10.9266248723521,10.9197430826349,11.3709750520062,9.19451914098973,8.28275446883394,7.94932478030371,9.24457581475404,8.03113665833102,8.55000722475601,9.78867233024303,8.83497903990617,8.93590525709103,8.40468536211813,9.20833768350815,14.6235004359233,9.14099752540553,9.25362380726576,10.071916144362,10.2299157315414,9.53532501124606,9.6692579869516,6.74509066901192,6.15330113532256,10.370515751246,9.09049954542503,10.0200564971751,9.99355289703415,9.88888637303393,10.1040336280696,10.8806689799788,9.56867589462954,9.64989309691582,9.59445850469261,10.2050152804098,6.26349779607528,9.42211912179202,8.55998200089996,10.2877507209013,10.7581823929192,10.6451528237764,11.9985754985755,9.76825280429092,8.99327614784088,11.4474117631613,9.70573684210526,12.1574041554997,11.497954956176,11.3042534581891,11.3759900746382,9.82397108745685,10.1992643383914,9.60990396323765,10.1352400106444,11.1735921402681,10.9352417209583,12.5235490845219,8.18520238962262,6.87545272286954,8.03003253664964,11.4640386259067,8.29427321917999,7.18724327002699,5.13591559259374,6.17056584886774,8.85858796296296,9.37695599122917,7.36736819076215,8.50389554904833,10.0064754815115,8.75971822341257,6.6724260979013,7.20333687724705,5.71197632058288,10.2082991657245,6.83499782024821,8.34972918709436,8.5159294969901,7.59825818049018,8.82701794307081,9.03590451416538,9.87622644263949,9.11774527637991,10.6562578539116,9.02415923073705,8.6325129421166,8.07352846617576,8.67711568456971,9.53897002479153,10.4323571790708,9.55134699454577,5.42580029507551,5.6890965386104,7.83828823219103,4.79364360267758,5.67873831775701,4.60140846243545,4.19568783609012,8.23348825302021,11.3671288501025,7.77127949484879,10.0348218426317,4.62527947083762,10.8843581622251,8.25159006795928,9.70476598677189,11.7849004678274,8.9042444268613,7.92652243117573,8.59196938859061,10.1146409158338,9.93635420143594,7.50027150782794,8.92497366203119,9.61133772773696,11.27216297368,9.31947705785482,10.383642317916,11.8062762938835,9.70731034235409,11.3768352028353,12.43392079794,9.75080353306394,10.954336282998,10.0627506645497,10.9714908974219,11.308122722154,11.0229603167885,11.0450660684255,9.44562298758968,9.80939098232848,11.0337415490157,9.44409520768716,11.3151363836954,10.1944771429818,10.5068090610659,9.97160810956816,10.7108377702256,11.6810608083505,10.1507817845627,10.7478311836223,9.43459239453357,11.0599438832772,4.46019342212702,7.05767640265159,8.59815859385905,6.12148745519713,9.71960606060606,13.4246728289138,12.77689765739,11.5753587266828,12.5936655468382,11.9092415807718,11.8757667688817,13.7709865393588,12.8078287596983,12.2284521854719,10.4150769529002,11.5563892135782,12.4347670067491,11.1490500162763,13.2179099035547,11.4944177911044,11.6850967823027,11.5947060815405,13.2246412927179,13.0829872749355,11.8646892655367,12.23285559637,8.9506436717737,10.7164075537989,10.5491344604625,9.6306288837866,9.46711323763955,10.2178741406663,10.2451206140351,11.1472156911725,4.978396874298,11.4225845410628,6.54402211698387,7.85746426250812,11.2011307767945,9.60610446840563,7.98116553828948,9.55933933933934,7.13897840264273,7.51253738783649,6.72289109682447,8.61749931072512,11.3551950960356,13.1360618372132,12.8972542216254,11.1321021621822,11.3428938232784,13.1956295726496,9.92346120659214,13.6544290469195,13.9194602707098,12.4209249399068,13.3081934177611,10.5110734476415,9.6772187240439,12.7020435686769,11.0205342125979,10.7740011336332,12.7091824512936,11.5009953445245,11.838172412336,13.2813176174198,12.4597419915924,6.61591751334222,8.69011815774355,9.20163304752858,10.2971142483007,10.7400240500241,10.5630495400263,11.5585938746887,11.4228027810029,8.60029074381825,11.2039298127196,8.31935611851578,8.13603942755946,8.63198170755892,4.32473577258088,4.17590077169482,9.10132321826058,6.10528517104277,11.7823916935195,10.8153386745778,10.1044988057919,11.4809949081829,12.1552691594563,9.04344598105775,12.445652173913,11.7211199914749,9.7214552545156,9.75586180958521,10.6075389666176,10.4591444106378,12.0353832018138,10.6580542566339,11.0539762954624,10.431050257732,8.9111255603606,11.277834613857,5.34960373116053,10.7113321544356,10.1029541111782,7.41224168467053,9.74765199671523,10.3050851370785,11.7279558338076,9.87371311989956,10.2047614797847,9.86604548789435,7.7402380952381,9.72221823933551,9.83538961038961,5.99885671918139,10.3045918073048,9.2146476941485,7.97454300238614,9.75774088312412,9.63155203967738,9.63223241847081,6.62455532902934,8.86685828172715,9.19589464159308,6.90222222222222,6.29683653528726,9.78223904148171,9.3864455157637,10.8817011927181,9.48757888114595,10.2362047552975,10.3534592553053,11.075065913371,9.76781848706826,10.1907621082621,9.84487541239105,10.8019088319088,10.2215301318267,9.32761898089767,10.2577933993594,10.3145980079593,9.92818679537931,9.80280614666391,7.93077902151641,7.93944411490059,8.84377007829653,7.82149191897902,9.46225263808188,12.8764114273625,13.3398029761572,13.0437226884185,12.4051819949986,11.7832403262114,12.420487387962,12.8436945026791,13.1318613325649,11.5568368020345,12.4233210639628,10.1144205471639,12.8403648688476,5.71523907808738,11.3662880536154,11.098743664562,6.30819786503374,11.2191912054405,10.4409234137763,10.0585723614208,9.41794745484401,11.5759336442523,10.2481154110321,10.0309493797519,9.74949138853279,9.20805996457349,8.48309472249895,6.11159409772617,11.9759798147557,5.27225233101856,3.38262576396183,8.50559576495175,4.1327393431167,4.95557025220927,6.54923928184728,5.63258693361433,6.34970982855398,4.56580800325485],"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"show_secondary_x_label":null,"chart_type":"histogram","xax_format":"plain","x_label":"PM2.5 Emissions (??g/m3","markers":[{"pm25":12,"label":"national standard"}],"baselines":null,"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":null,"max_x":null,"min_y":null,"max_y":null,"bar_margin":2,"binned":false,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"pm25","y_accessor":"","multi_line":null,"geom":"hist","yax_units":"","legend":null,"legend_target":null,"y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-4d5b2684844e9f1782a43315b0f64c","full_height":true},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

The [U.S. Environmental Protection Agency (EPA)](http://www.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm) sets the national ambient air quality standards for outdoor air pollution. For fine particle pollution (PM2.5), the "annual mean, averaged over 3 years" cannot exceed $12~\mu g/m^3$. Based on the histogram above, most of the averaged recorded observation fall within the standard.    

<br>       
    
#### 6. Does more counties in the west exceed that national standard for fine particle pollution than counties in the east?       
 
<br>       
        

```r
show_plot <- function(plot_object, title) {             ### function to add title
  div(style="margin:auto;text-align:left",              ### align title to left margin 
      strong(title),                                    ### make title text bold
      br(),                                             ### add space between title and plot
      plot_object)                                      ### add plot 
}

pollution %>%
        mjs_plot(x=latitude,                            ### variable to plot on x-axis
                 y=pm25,                                ### variable to plot on y-axis
                 width=600,                             ### set width to 600 pixels
                 height=500,                            ### set height to 500 pixels
                 right = 0,                             ### set right margin to 0
                 top = 0) %>%                           ### set top margin to 0
        mjs_point(color_accessor=region,                ### plot color according to region
                  y_rug=TRUE,                           ### include rug
                  color_type="category") %>%            ### plot color according to variable
        mjs_labs(x="Latitude", y="PM25 Emissions (??g/m3") %>%  ### add x and y labels
        mjs_add_baseline(12, "National Standard") %>%   ### add horizontal line
        show_plot("East(blue) - West(red)")             ### add title
```

<!--html_preserve--><div style="margin:auto;text-align:left">
<strong>East(blue) - West(red)</strong>
<br/>
<div id="mjs-ce2818af3e1f78007714874980b722" class="metricsgraphics html-widget" style="width:600px;height:500px;"></div>
<div id="mjs-ce2818af3e1f78007714874980b722-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-ce2818af3e1f78007714874980b722">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"pm25":[9.77118522614686,9.99381725284814,10.6886181012839,11.3374236874237,12.1197644686119,10.8278048723489,11.5839280137523,11.2619958748527,9.41442269955754,11.3914937063423,12.3847949521764,10.6495003064202,11.3338213580728,12.3024361179754,11.0245082815735,6.05886019051495,11.1014667422525,7.30811257305026,7.14762626262626,6.92984404484405,6.132350718065,8.22833917280753,5.3284750021471,10.5028619597453,11.3264992137362,5.16541323932628,10.8355150496786,10.4362348272642,11.1147433188335,10.8231569069069,10.7455228065043,10.4503506375228,10.7239588859416,10.4417366946779,11.0976451597588,11.8400858533296,11.1050030345373,10.8870238095238,10.6965244667289,10.641452991453,9.46590188607592,9.84229717813051,6.76874278843292,6.94475890985325,8.54517291213449,16.1945239442507,7.19696623951355,9.41794677963536,6.43133065191889,15.803779721076,18.4407314017251,3.49435096561789,16.6618011295383,8.15131805731041,15.0157326718079,6.45565456155149,5.28099869664386,14.5062723406882,7.96918321142459,9.67839312107419,17.4290486592135,9.67934206826549,5.99577421686427,9.84362711860765,10.7410869231163,11.5600218772021,7.30846636864851,8.99963596301318,8.41596420305724,9.84144647290684,6.19679173840357,5.5605463980464,5.70241404638811,10.0994598549599,6.9254031864888,16.2519038272246,7.30965689062766,16.1835830784913,9.61713614709045,7.7050032488629,8.46951893407169,6.65466368191024,6.77176468914163,7.73387698622957,5.73200461553332,4.18609021246952,5.97189954174968,6.61487829803047,9.32877602411928,6.27593990755008,7.68074488100719,9.82177829367954,8.89481883497206,7.02987073611182,10.001609188939,8.82187485318614,10.4129542695584,11.5517555159747,10.8377180079334,11.0238225610986,7.50346095206785,6.87720081743389,6.9775362209526,7.37522901571828,8.3783776391644,8.96184160987206,8.3415452544009,6.74496639545312,9.79596697012138,5,7.28553506718511,6.34854026253636,7.73819636495411,7.67951903770358,7.58490910924539,6.8008151008151,7.50035481331534,7.21377345515277,11.9592084944023,10.8244700530908,11.2922785144695,12.9139027854494,12.018415914295,12.1454136960407,11.746439215797,11.8178209192191,9.79381248890527,12.1452780063074,11.1883344861037,11.4223252694182,9.70988046483951,12.2006601852966,10.9490592810391,12.392874647024,10.6727069308928,11.3584635917969,12.1213807083732,6.82441875383051,5.78351927988093,5.6939448645207,10.3294045074514,4.91714043782155,10.7924482408342,8.8466406534255,10.3763269924492,12.4378980220572,13.3469102904998,9.35373976746836,11.059005118607,11.8780076805531,10.9013088512241,11.2698378522063,10.336829004329,10.5814567968035,9.2564950627936,10.2752187901461,10.003862064924,10.4695875139353,11.6319264428935,12.702122831133,11.1160700016684,10.1047342756054,9.65526315789474,12.3310604774049,11.0390648425787,10.5051792723394,10.0347250809987,13.0931187500138,13.1446592093778,11.8553016640881,13.0239225555372,12.0461756061115,12.3671405767727,11.630028527498,11.4432521852433,11.6924524127122,11.8117812795938,12.7532869466665,10.6469459530144,12.0895111242388,13.8832168707687,12.1973541767198,13.4352543307883,12.224040041983,12.1950547177351,12.8288775395985,12.2609157118629,10.4736962770473,11.6990452738192,10.9172629816653,11.1236639236879,10.407355367073,9.28889224065695,12.679210751879,8.82850404312669,9.40201510835567,10.8313455499634,11.9607604301067,9.28110499880411,8.93896188478685,9.33779024592978,9.05711530713215,9.32216152841153,8.68183331819695,9.7411819651878,11.2818263607737,11.405536872264,12.6653247822665,11.8011875934401,9.68513234753605,11.3224653698792,12.0517527673095,12.3957936523464,11.1037138188609,11.7650292954172,11.8591950782035,13.0588135499759,11.9036446011229,11.6700302343159,10.3434330163497,11.5546621879169,10.0901497369687,11.5114626909954,10.8511742051786,8.87430973517136,9.97039679617448,9.76181836142642,9.07945329347656,9.79997038240766,9.70396147150449,8.89871776296726,12.1783537749805,9.13448640646916,8.52827622014538,11.8026775921897,7.79428610906411,6.16244323094984,8.18271314335201,4.50453934354474,7.33442566054635,8.25966374269006,7.38414669783752,5.18625013760234,11.4394020016885,11.0231924080553,11.6654863989306,9.52946522657514,10.6695080583002,10.9266248723521,10.9197430826349,11.3709750520062,9.19451914098973,8.28275446883394,7.94932478030371,9.24457581475404,8.03113665833102,8.55000722475601,9.78867233024303,8.83497903990617,8.93590525709103,8.40468536211813,9.20833768350815,14.6235004359233,9.14099752540553,9.25362380726576,10.071916144362,10.2299157315414,9.53532501124606,9.6692579869516,6.74509066901192,6.15330113532256,10.370515751246,9.09049954542503,10.0200564971751,9.99355289703415,9.88888637303393,10.1040336280696,10.8806689799788,9.56867589462954,9.64989309691582,9.59445850469261,10.2050152804098,6.26349779607528,9.42211912179202,8.55998200089996,10.2877507209013,10.7581823929192,10.6451528237764,11.9985754985755,9.76825280429092,8.99327614784088,11.4474117631613,9.70573684210526,12.1574041554997,11.497954956176,11.3042534581891,11.3759900746382,9.82397108745685,10.1992643383914,9.60990396323765,10.1352400106444,11.1735921402681,10.9352417209583,12.5235490845219,8.18520238962262,6.87545272286954,8.03003253664964,11.4640386259067,8.29427321917999,7.18724327002699,5.13591559259374,6.17056584886774,8.85858796296296,9.37695599122917,7.36736819076215,8.50389554904833,10.0064754815115,8.75971822341257,6.6724260979013,7.20333687724705,5.71197632058288,10.2082991657245,6.83499782024821,8.34972918709436,8.5159294969901,7.59825818049018,8.82701794307081,9.03590451416538,9.87622644263949,9.11774527637991,10.6562578539116,9.02415923073705,8.6325129421166,8.07352846617576,8.67711568456971,9.53897002479153,10.4323571790708,9.55134699454577,5.42580029507551,5.6890965386104,7.83828823219103,4.79364360267758,5.67873831775701,4.60140846243545,4.19568783609012,8.23348825302021,11.3671288501025,7.77127949484879,10.0348218426317,4.62527947083762,10.8843581622251,8.25159006795928,9.70476598677189,11.7849004678274,8.9042444268613,7.92652243117573,8.59196938859061,10.1146409158338,9.93635420143594,7.50027150782794,8.92497366203119,9.61133772773696,11.27216297368,9.31947705785482,10.383642317916,11.8062762938835,9.70731034235409,11.3768352028353,12.43392079794,9.75080353306394,10.954336282998,10.0627506645497,10.9714908974219,11.308122722154,11.0229603167885,11.0450660684255,9.44562298758968,9.80939098232848,11.0337415490157,9.44409520768716,11.3151363836954,10.1944771429818,10.5068090610659,9.97160810956816,10.7108377702256,11.6810608083505,10.1507817845627,10.7478311836223,9.43459239453357,11.0599438832772,4.46019342212702,7.05767640265159,8.59815859385905,6.12148745519713,9.71960606060606,13.4246728289138,12.77689765739,11.5753587266828,12.5936655468382,11.9092415807718,11.8757667688817,13.7709865393588,12.8078287596983,12.2284521854719,10.4150769529002,11.5563892135782,12.4347670067491,11.1490500162763,13.2179099035547,11.4944177911044,11.6850967823027,11.5947060815405,13.2246412927179,13.0829872749355,11.8646892655367,12.23285559637,8.9506436717737,10.7164075537989,10.5491344604625,9.6306288837866,9.46711323763955,10.2178741406663,10.2451206140351,11.1472156911725,4.978396874298,11.4225845410628,6.54402211698387,7.85746426250812,11.2011307767945,9.60610446840563,7.98116553828948,9.55933933933934,7.13897840264273,7.51253738783649,6.72289109682447,8.61749931072512,11.3551950960356,13.1360618372132,12.8972542216254,11.1321021621822,11.3428938232784,13.1956295726496,9.92346120659214,13.6544290469195,13.9194602707098,12.4209249399068,13.3081934177611,10.5110734476415,9.6772187240439,12.7020435686769,11.0205342125979,10.7740011336332,12.7091824512936,11.5009953445245,11.838172412336,13.2813176174198,12.4597419915924,6.61591751334222,8.69011815774355,9.20163304752858,10.2971142483007,10.7400240500241,10.5630495400263,11.5585938746887,11.4228027810029,8.60029074381825,11.2039298127196,8.31935611851578,8.13603942755946,8.63198170755892,4.32473577258088,4.17590077169482,9.10132321826058,6.10528517104277,11.7823916935195,10.8153386745778,10.1044988057919,11.4809949081829,12.1552691594563,9.04344598105775,12.445652173913,11.7211199914749,9.7214552545156,9.75586180958521,10.6075389666176,10.4591444106378,12.0353832018138,10.6580542566339,11.0539762954624,10.431050257732,8.9111255603606,11.277834613857,5.34960373116053,10.7113321544356,10.1029541111782,7.41224168467053,9.74765199671523,10.3050851370785,11.7279558338076,9.87371311989956,10.2047614797847,9.86604548789435,7.7402380952381,9.72221823933551,9.83538961038961,5.99885671918139,10.3045918073048,9.2146476941485,7.97454300238614,9.75774088312412,9.63155203967738,9.63223241847081,6.62455532902934,8.86685828172715,9.19589464159308,6.90222222222222,6.29683653528726,9.78223904148171,9.3864455157637,10.8817011927181,9.48757888114595,10.2362047552975,10.3534592553053,11.075065913371,9.76781848706826,10.1907621082621,9.84487541239105,10.8019088319088,10.2215301318267,9.32761898089767,10.2577933993594,10.3145980079593,9.92818679537931,9.80280614666391,7.93077902151641,7.93944411490059,8.84377007829653,7.82149191897902,9.46225263808188,12.8764114273625,13.3398029761572,13.0437226884185,12.4051819949986,11.7832403262114,12.420487387962,12.8436945026791,13.1318613325649,11.5568368020345,12.4233210639628,10.1144205471639,12.8403648688476,5.71523907808738,11.3662880536154,11.098743664562,6.30819786503374,11.2191912054405,10.4409234137763,10.0585723614208,9.41794745484401,11.5759336442523,10.2481154110321,10.0309493797519,9.74949138853279,9.20805996457349,8.48309472249895,6.11159409772617,11.9759798147557,5.27225233101856,3.38262576396183,8.50559576495175,4.1327393431167,4.95557025220927,6.54923928184728,5.63258693361433,6.34970982855398,4.56580800325485],"fips":["01003","01027","01033","01049","01055","01069","01073","01089","01097","01103","01113","01117","01121","01125","01127","02020","02090","02110","02170","04003","04005","04013","04019","04021","04023","04025","05001","05003","05035","05045","05051","05067","05107","05113","05115","05119","05131","05139","05143","05145","06001","06007","06009","06011","06013","06019","06023","06025","06027","06029","06031","06033","06037","06045","06047","06053","06057","06059","06061","06063","06065","06067","06069","06073","06075","06077","06079","06081","06083","06085","06087","06089","06093","06095","06097","06099","06101","06107","06111","06113","08001","08005","08013","08031","08035","08039","08041","08069","08077","08083","08123","09001","09003","09005","09009","09011","10001","10003","10005","11001","12001","12009","12011","12017","12031","12033","12057","12071","12073","12086","12095","12099","12103","12105","12111","12115","12117","12127","13021","13051","13059","13063","13067","13089","13095","13121","13127","13135","13139","13153","13185","13215","13223","13245","13295","13303","13319","15001","15003","15009","16001","16005","16009","16027","16041","16059","16079","17001","17019","17031","17043","17065","17083","17089","17097","17099","17111","17113","17115","17119","17143","17157","17161","17163","17167","17197","17201","18003","18019","18035","18037","18039","18043","18051","18065","18067","18083","18089","18091","18095","18097","18127","18141","18147","18157","18163","18167","19013","19045","19103","19111","19113","19137","19139","19147","19153","19155","19163","19177","20091","20107","20173","20177","20191","20209","21013","21019","21029","21037","21043","21047","21059","21067","21073","21093","21101","21111","21117","21145","21151","21183","21195","21227","22017","22019","22033","22047","22051","22055","22073","22079","22087","22105","22109","22121","23001","23003","23005","23009","23011","23017","23019","23021","24003","24005","24015","24025","24031","24033","24043","24510","25003","25005","25009","25013","25017","25023","25025","25027","26005","26017","26021","26033","26049","26065","26077","26081","26091","26099","26101","26113","26115","26121","26125","26139","26147","26161","26163","27037","27053","27109","27123","27137","27139","27145","28001","28011","28033","28035","28043","28047","28049","28059","28067","28075","28081","29021","29037","29039","29047","29077","29095","29099","29510","30029","30031","30049","30053","30063","30081","30083","30089","30093","31055","31079","31109","31153","31177","32003","32031","33001","33005","33009","33011","33013","33015","34001","34003","34007","34015","34017","34021","34023","34027","34029","34031","34039","34041","35001","35005","35013","35017","35025","35045","35049","36001","36005","36013","36029","36031","36047","36055","36059","36061","36063","36067","36071","36081","36085","36101","36103","36119","37001","37021","37033","37035","37037","37051","37057","37061","37063","37065","37067","37071","37081","37087","37099","37107","37111","37117","37119","37121","37123","37147","37155","37159","37173","37183","37189","37191","38007","38015","38017","38057","39009","39017","39023","39025","39035","39049","39057","39061","39081","39087","39093","39095","39099","39103","39113","39133","39135","39145","39151","39153","39165","40001","40015","40097","40101","40109","40115","40121","40135","40143","41017","41025","41029","41033","41035","41037","41039","41043","41051","41059","41061","41067","42001","42003","42007","42011","42017","42021","42027","42029","42041","42043","42045","42049","42069","42071","42085","42091","42095","42101","42125","42129","42133","44003","44007","45019","45025","45037","45041","45045","45063","45073","45079","46011","46013","46029","46033","46071","46099","46103","47009","47037","47045","47065","47093","47099","47105","47107","47113","47119","47125","47141","47145","47157","47163","47165","48029","48037","48043","48061","48113","48135","48139","48141","48201","48203","48215","48245","48303","48355","48361","48375","48439","48453","49003","49005","49011","49035","49045","49049","49057","50003","50007","50021","51003","51013","51036","51041","51059","51069","51087","51107","51139","51165","51520","51680","51710","51770","51775","51810","53011","53033","53053","53061","53077","54003","54009","54011","54029","54033","54039","54049","54051","54061","54069","54081","54107","55003","55009","55025","55041","55043","55059","55063","55071","55079","55087","55089","55109","55111","55119","55125","55133","56005","56009","56013","56021","56029","56033","56035","56037","56039"],"region":["east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","west","west","east","east","east","east","east","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","east","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","east","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","east","east","west","east","west","east","east","east","east","west","east","east","west","east","east","west","west","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","west","west","west","west","west","west","west","west","west"],"longitude":[-87.74826,-85.842858,-87.72596,-85.798919,-86.032125,-85.350387,-86.82805,-86.588226,-88.139667,-86.91892,-85.1011,-86.698665,-86.178278,-87.511691,-87.285406,-149.762097,-147.568384,-134.511579,-149.481089,-109.904319,-111.511062,-112.087906,-111.088624,-111.498113,-110.905734,-112.414707,-91.429413,-91.785346,-90.2728,-92.379944,-93.075894,-91.227582,-90.761973,-94.253631,-93.084446,-92.294471,-94.351769,-92.612793,-94.198684,-91.730562,-122.096151,-121.64631,-120.557245,-122.152389,-122.060886,-119.90347,-123.988265,-115.487593,-117.693329,-118.683344,-119.811272,-122.751791,-118.234216,-123.430217,-120.674118,-121.528953,-120.814268,-117.861663,-120.947618,-120.851195,-116.803605,-121.389266,-121.288843,-117.062993,-122.437392,-121.281307,-120.58746,-122.331932,-120.071425,-121.912818,-121.973761,-122.121202,-122.502816,-122.051826,-122.768624,-120.9588,-121.658159,-119.166093,-119.045326,-121.775709,-104.869954,-104.841455,-105.195154,-104.965486,-104.888716,-104.292156,-104.748828,-105.213007,-108.509096,-108.575842,-104.728213,-73.35482,-72.715449,-73.212688,-72.94032,-72.092949,-75.560273,-75.611707,-75.342268,-77.013222,-82.379953,-80.685189,-80.206098,-82.469163,-81.638873,-87.277355,-82.412079,-81.846262,-84.260888,-80.302264,-81.404159,-80.176395,-82.727766,-81.758303,-80.360875,-82.398881,-81.310831,-81.138947,-83.665205,-81.107165,-83.380111,-84.365597,-84.559283,-84.25768,-84.163206,-84.419327,-81.496294,-84.058446,-83.842959,-83.663234,-83.277179,-84.942179,-84.831116,-82.028396,-85.291825,-82.782607,-83.226599,-155.393159,-158.035861,-156.615839,-116.280069,-112.346267,-116.637643,-116.673633,-111.855585,-113.778243,-116.040486,-91.268051,-88.216752,-87.767817,-88.063587,-88.536242,-90.342138,-88.338441,-87.983801,-88.904285,-88.353772,-88.883582,-88.953227,-90.018837,-89.665063,-89.796877,-90.507532,-90.002067,-89.646499,-88.02984,-89.08163,-85.100068,-85.727465,-85.396077,-86.900551,-85.899404,-85.863288,-87.558364,-85.405985,-86.126407,-87.418937,-87.395253,-86.779261,-85.719201,-86.14181,-87.086655,-86.241933,-87.013205,-86.88088,-87.556964,-87.391268,-92.344731,-90.427404,-91.568871,-91.416607,-91.630559,-95.159253,-91.084801,-94.688715,-93.630942,-95.680399,-90.578862,-91.948808,-94.753767,-94.805322,-97.36347,-95.710259,-97.432563,-94.69276,-83.702245,-82.664583,-85.672052,-84.433303,-83.049318,-87.481989,-87.105097,-84.494642,-84.868393,-85.914926,-87.568076,-85.704021,-84.539347,-88.651111,-84.27224,-86.879363,-82.411115,-86.42455,-93.813906,-93.291757,-91.119654,-91.287188,-90.1514,-92.038879,-92.115857,-92.476589,-89.89026,-90.462949,-90.735917,-91.263053,-70.217663,-68.261663,-70.327978,-68.415711,-69.784554,-70.705175,-68.722469,-69.33369,-76.576891,-76.612627,-75.951459,-76.290245,-77.124386,-76.882176,-77.774436,-76.617016,-73.209889,-71.102131,-70.970827,-72.571312,-71.275566,-70.818958,-71.073493,-71.840209,-85.903867,-83.917406,-86.426818,-84.497987,-83.700504,-84.469828,-85.561317,-85.612696,-84.065929,-82.951762,-86.135402,-85.145565,-83.484125,-86.21617,-83.305598,-86.049749,-82.597855,-83.759473,-83.19795,-93.120132,-93.362357,-92.442548,-93.106593,-92.404547,-93.510829,-94.495886,-91.354348,-90.830139,-89.992068,-89.276207,-89.803446,-89.079536,-90.305374,-88.633143,-89.17378,-88.678186,-88.682514,-94.827011,-94.376663,-93.885396,-94.474033,-93.316087,-94.463242,-90.499266,-90.242806,-114.321279,-111.186786,-112.153933,-115.359348,-113.968607,-114.117236,-104.458252,-115.084463,-112.562536,-96.050944,-98.417732,-96.681392,-96.031099,-96.198876,-115.117901,-119.763634,-71.436077,-72.242077,-71.89463,-71.582737,-71.637253,-71.077622,-74.621566,-74.059037,-75.029263,-75.136197,-74.069,-74.711654,-74.383918,-74.500442,-74.210903,-74.216831,-74.301654,-75.030699,-106.612469,-104.444987,-106.78167,-108.246748,-103.327764,-108.30406,-106.007134,-73.849077,-73.873207,-79.345719,-78.796303,-73.737594,-73.952247,-77.630324,-73.602538,-73.973533,-78.848097,-76.179117,-74.27948,-73.820376,-74.140923,-77.363147,-73.026232,-73.794013,-79.413917,-82.531461,-79.320014,-81.247567,-79.282856,-78.907247,-80.197806,-77.988007,-78.900356,-77.640306,-80.244596,-81.166447,-79.846984,-82.960527,-83.183862,-77.630588,-82.038396,-77.123835,-80.830859,-82.142844,-79.903306,-77.391082,-79.106531,-80.515502,-83.446528,-78.665751,-81.700107,-77.995343,-103.359665,-100.641038,-97.084444,-101.686375,-82.075082,-84.513194,-83.826362,-84.177419,-81.663852,-82.996532,-83.949396,-84.493792,-80.72585,-82.547506,-82.135816,-83.608466,-80.706497,-81.872052,-84.21859,-81.253721,-84.637188,-82.943068,-81.383599,-81.520637,-84.221759,-94.640694,-98.344737,-95.211238,-95.367134,-97.496525,-94.839825,-95.7143,-94.788897,-95.938999,-121.337204,-119.039719,-122.785659,-123.432362,-121.651634,-120.57698,-123.080812,-122.731425,-122.613233,-118.817308,-118.031311,-122.915144,-77.182542,-79.959705,-80.312675,-75.914242,-75.027841,-78.789233,-77.834459,-75.683302,-77.133685,-76.804656,-75.350636,-80.056979,-75.632209,-76.281219,-80.313128,-75.317433,-75.322072,-75.144793,-80.13855,-79.561874,-76.742183,-71.479529,-71.456165,-79.991379,-80.15629,-81.904462,-79.740304,-82.353114,-81.232319,-83.02142,-80.974331,-96.798488,-98.381992,-97.157383,-103.51523,-101.669286,-96.742201,-103.105497,-83.969238,-86.765764,-89.358984,-85.2301,-83.955932,-87.375807,-84.29551,-84.595909,-88.827384,-87.064841,-87.370428,-85.495277,-84.526726,-89.926902,-82.383596,-86.487509,-98.508944,-94.250198,-103.402219,-97.557442,-96.788828,-102.43482,-96.798436,-106.351813,-95.363056,-94.353085,-98.159799,-94.061768,-101.852068,-97.458944,-93.842055,-101.842212,-97.26583,-97.769809,-112.480319,-111.842117,-111.940753,-111.915566,-112.690027,-111.73671,-111.972867,-73.107955,-73.12727,-73.05306,-78.535282,-77.10826,-77.071609,-77.545895,-77.249565,-78.244616,-77.476994,-77.568819,-78.488469,-78.84438,-82.176193,-79.170205,-76.2599,-79.955711,-80.055836,-76.087179,-122.547831,-122.196851,-122.383565,-122.094183,-120.512943,-77.983926,-80.590963,-82.323238,-80.575484,-80.341952,-81.605694,-80.197936,-80.712893,-79.994783,-80.67612,-81.228271,-81.5317,-90.721893,-88.032769,-89.393668,-88.770485,-90.667336,-87.952431,-91.189127,-87.75858,-87.960713,-88.410017,-87.944718,-92.506966,-89.90087,-90.491269,-89.531836,-88.255888,-105.496159,-105.502721,-108.681116,-104.762083,-108.999016,-106.96813,-109.991147,-109.168198,-110.673534],"latitude":[30.592781,33.26581,34.73148,34.459133,34.018597,31.189731,33.527872,34.73079,30.722256,34.507018,32.376002,33.26912,33.368498,33.2356,33.819888,61.1919,64.81859,58.351422,61.762742,31.750272,35.77144,33.494514,32.17841,32.965668,31.4819,34.650332,34.359997,33.18542,35.197701,35.119477,34.545307,35.613258,34.468372,34.48549,35.330478,34.766541,35.293916,33.207179,36.051379,35.250106,37.716662,39.648354,38.167573,39.187495,37.942423,36.638374,40.747403,32.963098,36.709037,35.296023,36.155141,39.023264,34.08851,39.363102,37.245783,36.450732,39.270775,33.731518,38.971576,40.020149,33.783307,38.561106,36.745753,32.904616,37.759881,37.945959,35.373909,37.531037,34.649384,37.306509,37.002349,40.688705,41.614943,38.235934,38.440089,37.613805,39.076193,36.234647,34.277048,38.634155,39.866716,39.641904,40.058094,39.726287,39.461171,39.293642,38.865444,40.534099,39.095228,37.353687,40.346681,41.212896,41.769967,41.754255,41.390764,41.446109,39.092714,39.695612,38.651424,38.913611,29.676436,28.220079,26.134788,28.894637,30.320873,30.502045,27.966349,26.602541,30.462933,25.756427,28.547129,26.637745,27.889647,27.992436,27.348246,27.16493,28.709909,29.049037,32.829689,32.047559,33.954747,33.566178,33.935535,33.790944,31.572874,33.779605,31.187633,33.967056,34.296799,32.558055,30.848527,32.490061,33.902776,33.429488,34.818692,32.949364,32.83589,19.683885,21.426126,20.901025,43.5603,42.777785,47.240039,43.61814,42.153211,44.948818,47.417879,39.965452,40.136824,41.837649,41.856029,38.096779,39.083608,41.918229,42.313322,41.332155,42.296401,40.495251,39.853136,38.812515,40.752492,38.079211,41.491433,38.532682,39.763854,41.527431,42.311119,41.090284,38.386482,40.211893,38.350091,41.626089,38.316931,38.3177,39.923532,40.475438,38.697416,41.529603,41.599217,40.14594,39.792792,41.52351,41.664783,38.024372,40.409485,37.989892,39.456887,42.487586,41.871169,41.674915,40.576831,42.029994,41.013101,41.472456,43.090301,41.627938,41.308529,41.572127,40.740217,38.932175,38.223827,37.681327,39.03915,37.26461,39.103711,36.691388,38.425361,38.005184,39.036524,38.307846,36.854445,37.750648,38.029632,38.203653,37.738924,37.802623,38.209237,39.026743,37.059705,37.699681,37.456506,37.447794,36.986914,32.527562,30.237442,30.480122,30.275168,29.935238,30.207388,32.509377,31.262083,29.922088,30.607405,29.541174,30.452085,44.135072,46.637362,43.784479,44.512741,44.399958,44.324518,45.17193,45.565184,39.05786,39.372206,39.592628,39.534674,39.072608,38.906334,39.614696,39.307956,42.396128,41.778329,42.635475,42.12756,42.459085,41.978877,42.334948,42.329642,42.592727,43.636656,41.971239,46.322274,43.011877,42.667752,42.259641,42.98864,41.917635,42.591138,44.323788,44.32747,41.919053,43.254681,42.588233,42.929975,42.916954,42.260331,42.337237,44.7588,44.971331,44.007477,44.990915,47.369145,44.696343,45.540863,31.535545,33.803284,34.904345,31.263019,33.775041,30.427896,32.294333,30.455709,31.652274,32.400078,34.276904,39.722544,38.689373,37.7305,39.253674,37.216298,39.024005,38.285842,38.627718,48.26788,45.663871,46.813873,48.558617,46.939971,46.210173,47.779342,47.633114,45.960929,41.264027,40.894156,40.796701,41.14287,41.516281,36.139215,39.704166,43.515202,42.911802,43.896067,42.895585,43.277704,42.96287,39.447721,40.930457,39.869213,39.752778,40.740351,40.252908,40.494044,40.867167,39.918818,40.946491,40.657752,40.803025,35.101046,33.355893,32.274123,32.708567,32.728441,36.577598,35.588826,42.662095,40.846761,42.2407,42.859908,44.162194,40.649812,43.159963,40.715949,40.769656,43.146089,43.048433,41.406117,40.714295,40.582197,42.283617,40.833314,41.057167,36.076036,35.59526,36.406412,35.695613,35.702312,35.056213,35.816809,34.924123,35.998343,35.916244,36.1142,35.284549,36.052635,35.523376,35.313469,35.250556,35.686938,35.83833,35.231792,35.977691,35.340096,35.589908,34.658374,35.617342,35.421822,35.796512,36.217932,35.364712,46.990106,46.890682,46.899583,47.284699,39.356909,39.427856,39.921309,39.059566,41.460301,39.990514,39.712555,39.179526,40.360701,38.530404,41.370274,41.649267,41.052558,41.11258,39.750258,41.172189,39.74386,38.78893,40.819408,41.095605,39.440152,35.896421,35.136539,36.314823,35.686587,35.509671,36.861373,34.939711,35.484348,36.124761,43.996058,43.461427,42.389833,42.362158,42.662031,42.713376,43.989252,44.544833,45.522473,45.637299,45.325011,45.496796,39.854379,40.440569,40.695415,40.377743,40.254936,40.435472,40.887275,39.988807,40.201203,40.324487,39.912978,42.052025,41.43348,40.06767,41.294427,40.170596,40.702861,39.998012,40.182615,40.326108,39.927299,41.704125,41.852849,32.809639,34.654172,33.771236,34.065068,34.861272,33.949223,34.715038,34.035404,44.34542,45.538665,44.939334,43.693106,43.76851,43.601442,44.045194,35.754277,36.156595,36.060464,35.095522,35.973115,35.205257,35.744899,35.41638,35.628652,35.616397,36.510616,36.157835,35.87976,35.133382,36.530363,36.436444,29.453231,33.43807,29.994131,26.082987,32.803579,31.867206,32.391428,31.770159,29.787777,32.548681,26.242291,29.98423,33.570085,27.747148,30.114604,35.257052,32.76383,30.321806,41.595787,41.751082,41.00435,40.655802,40.415422,40.236597,41.232183,43.029418,44.475682,43.595081,38.024179,38.880344,37.344868,37.419938,38.840845,39.192751,37.584747,39.064634,38.613462,38.466513,36.611116,37.403672,36.885747,37.276895,37.286895,36.834498,45.692187,47.548745,47.171571,47.976838,46.482454,39.462988,40.296424,38.412924,40.504722,39.297035,38.34893,39.499846,39.907446,39.634786,40.078772,37.771342,39.259427,46.337524,44.493492,43.071496,45.604373,42.876486,42.568669,43.859415,44.102318,43.034113,44.336535,43.329252,45.028469,43.444512,45.191826,46.024577,43.036352,44.085797,42.857379,43.098213,41.196199,44.568961,44.783629,42.750949,41.640708,43.612124]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"show_secondary_x_label":null,"chart_type":"point","xax_format":"plain","x_label":"Latitude","y_label":"PM25 Emissions (??g/m3","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":false,"title":null,"description":null,"left":80,"right":0,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":true,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":"region","color_type":"category","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":null,"max_x":null,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"latitude","y_accessor":"pm25","multi_line":null,"geom":"point","yax_units":"","legend":null,"legend_target":null,"y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-ce2818af3e1f78007714874980b722"},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->
  
<br>  
  
Based on the scatterplot above, it appears there are more counties from the east (blue dots) that exceed the horizontal line representing the national standard $12~\mu g/m^3$. 

However, the plot also shows that there are counties from the west that have average pm2.5 levels that are far above the rest of the other counties in both east and west. 

By utilizing the interactive feature of metricgraphics, we can identify the highest and lowest PM2.5 emission in the data and identify its latitude.

Let's take a look at the individual distributions of the eastern and western counties.  

<br>


```r
west <- subset(pollution, region == "west")             ### subset data region == west 
east <- subset(pollution, region == "east")            ### subset data region == east

east %>%
        mjs_plot(pm25,                                 ### variable to plot on x-axis
                 width="375px") %>%                    ### width of plot in pixels
        mjs_histogram(bar_margin=2) %>%                ### type of plot, space between bars
        mjs_labs(x_label="PM2.5 Emissions (??g/m3)")  %>%   ### x and y axis labels
        mjs_axis_y(min_y = 0,
                   max_y = 120) %>%                    ### set y-axis range
        mjs_add_marker(12, "national standard") %>%    ### add horizontal line
        mjs_add_legend(legend = "East") -> p2          ### add legend, assign as p2

west%>% 
        mjs_plot(pm25,                                  ### variable to plot on x-axis
                 width="375px") %>%                     ### width of plot in pixels
        mjs_histogram(bar_margin=2) %>%                 ### type of plot, space between bars
        mjs_labs(x_label="PM2.5")  %>%                  ### x axis labels
        mjs_axis_y(min_y = 0,
                   max_y = 120) %>%                     ### set y-axis range
        mjs_add_marker(12, "national standard") %>%     ### add horizontal line
        mjs_add_legend(legend = "West") -> p1           ### add legend, assign as p1

mjs_grid(p1, p2, ncol = 2, nrow = 1, widths = c(rep(1, 3)))
```

<!--html_preserve--><table style="width:100%" width="100%">
<tr width="100%" style="width:100%">
<td style="width:100.00%" width="100.00%">
<div id="mjs-f0a4f757cf98b4b77972eb78000a0e" class="metricsgraphics html-widget" style="width:375px;height:500px;"></div>
<div id="mjs-f0a4f757cf98b4b77972eb78000a0e-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-f0a4f757cf98b4b77972eb78000a0e">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":[6.05886019051495,11.1014667422525,7.30811257305026,7.14762626262626,6.92984404484405,6.132350718065,8.22833917280753,5.3284750021471,10.5028619597453,11.3264992137362,5.16541323932628,9.46590188607592,9.84229717813051,6.76874278843292,6.94475890985325,8.54517291213449,16.1945239442507,7.19696623951355,9.41794677963536,6.43133065191889,15.803779721076,18.4407314017251,3.49435096561789,16.6618011295383,8.15131805731041,15.0157326718079,6.45565456155149,5.28099869664386,14.5062723406882,7.96918321142459,9.67839312107419,17.4290486592135,9.67934206826549,5.99577421686427,9.84362711860765,10.7410869231163,11.5600218772021,7.30846636864851,8.99963596301318,8.41596420305724,9.84144647290684,6.19679173840357,5.5605463980464,5.70241404638811,10.0994598549599,6.9254031864888,16.2519038272246,7.30965689062766,16.1835830784913,9.61713614709045,7.7050032488629,8.46951893407169,6.65466368191024,6.77176468914163,7.73387698622957,5.73200461553332,4.18609021246952,5.97189954174968,6.61487829803047,9.32877602411928,6.27593990755008,7.68074488100719,6.82441875383051,5.78351927988093,5.6939448645207,10.3294045074514,4.91714043782155,10.7924482408342,8.8466406534255,10.3763269924492,12.4378980220572,13.3469102904998,8.18520238962262,6.87545272286954,8.03003253664964,11.4640386259067,8.29427321917999,7.18724327002699,5.13591559259374,6.17056584886774,8.85858796296296,6.6724260979013,7.20333687724705,5.42580029507551,5.6890965386104,7.83828823219103,4.79364360267758,5.67873831775701,4.60140846243545,4.19568783609012,4.46019342212702,7.05767640265159,6.12148745519713,4.978396874298,11.4225845410628,6.54402211698387,7.85746426250812,11.2011307767945,9.60610446840563,7.98116553828948,9.55933933933934,7.13897840264273,7.51253738783649,6.72289109682447,8.61749931072512,4.32473577258088,4.17590077169482,6.10528517104277,5.34960373116053,7.41224168467053,10.3050851370785,7.7402380952381,5.99885671918139,7.97454300238614,9.75774088312412,9.63155203967738,9.63223241847081,6.62455532902934,8.86685828172715,9.19589464159308,7.93077902151641,7.93944411490059,8.84377007829653,7.82149191897902,9.46225263808188,5.27225233101856,3.38262576396183,8.50559576495175,4.1327393431167,4.95557025220927,6.54923928184728,5.63258693361433,6.34970982855398,4.56580800325485],"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"show_secondary_x_label":null,"chart_type":"histogram","xax_format":"plain","x_label":"PM2.5","markers":[{"pm25":12,"label":"national standard"}],"baselines":null,"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":null,"max_x":null,"min_y":0,"max_y":120,"bar_margin":2,"binned":false,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"pm25","y_accessor":"","multi_line":null,"geom":"hist","yax_units":"","legend":"West","legend_target":"#mjs-f0a4f757cf98b4b77972eb78000a0e-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-f0a4f757cf98b4b77972eb78000a0e","full_height":true},"evals":[],"jsHooks":[]}</script>
</td>
<td style="width:100.00%" width="100.00%">
<div id="mjs-03af46137944300460e366be407c90" class="metricsgraphics html-widget" style="width:375px;height:500px;"></div>
<div id="mjs-03af46137944300460e366be407c90-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-03af46137944300460e366be407c90">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":[9.77118522614686,9.99381725284814,10.6886181012839,11.3374236874237,12.1197644686119,10.8278048723489,11.5839280137523,11.2619958748527,9.41442269955754,11.3914937063423,12.3847949521764,10.6495003064202,11.3338213580728,12.3024361179754,11.0245082815735,10.8355150496786,10.4362348272642,11.1147433188335,10.8231569069069,10.7455228065043,10.4503506375228,10.7239588859416,10.4417366946779,11.0976451597588,11.8400858533296,11.1050030345373,10.8870238095238,10.6965244667289,10.641452991453,9.82177829367954,8.89481883497206,7.02987073611182,10.001609188939,8.82187485318614,10.4129542695584,11.5517555159747,10.8377180079334,11.0238225610986,7.50346095206785,6.87720081743389,6.9775362209526,7.37522901571828,8.3783776391644,8.96184160987206,8.3415452544009,6.74496639545312,9.79596697012138,5,7.28553506718511,6.34854026253636,7.73819636495411,7.67951903770358,7.58490910924539,6.8008151008151,7.50035481331534,7.21377345515277,11.9592084944023,10.8244700530908,11.2922785144695,12.9139027854494,12.018415914295,12.1454136960407,11.746439215797,11.8178209192191,9.79381248890527,12.1452780063074,11.1883344861037,11.4223252694182,9.70988046483951,12.2006601852966,10.9490592810391,12.392874647024,10.6727069308928,11.3584635917969,12.1213807083732,9.35373976746836,11.059005118607,11.8780076805531,10.9013088512241,11.2698378522063,10.336829004329,10.5814567968035,9.2564950627936,10.2752187901461,10.003862064924,10.4695875139353,11.6319264428935,12.702122831133,11.1160700016684,10.1047342756054,9.65526315789474,12.3310604774049,11.0390648425787,10.5051792723394,10.0347250809987,13.0931187500138,13.1446592093778,11.8553016640881,13.0239225555372,12.0461756061115,12.3671405767727,11.630028527498,11.4432521852433,11.6924524127122,11.8117812795938,12.7532869466665,10.6469459530144,12.0895111242388,13.8832168707687,12.1973541767198,13.4352543307883,12.224040041983,12.1950547177351,12.8288775395985,12.2609157118629,10.4736962770473,11.6990452738192,10.9172629816653,11.1236639236879,10.407355367073,9.28889224065695,12.679210751879,8.82850404312669,9.40201510835567,10.8313455499634,11.9607604301067,9.28110499880411,8.93896188478685,9.33779024592978,9.05711530713215,9.32216152841153,8.68183331819695,9.7411819651878,11.2818263607737,11.405536872264,12.6653247822665,11.8011875934401,9.68513234753605,11.3224653698792,12.0517527673095,12.3957936523464,11.1037138188609,11.7650292954172,11.8591950782035,13.0588135499759,11.9036446011229,11.6700302343159,10.3434330163497,11.5546621879169,10.0901497369687,11.5114626909954,10.8511742051786,8.87430973517136,9.97039679617448,9.76181836142642,9.07945329347656,9.79997038240766,9.70396147150449,8.89871776296726,12.1783537749805,9.13448640646916,8.52827622014538,11.8026775921897,7.79428610906411,6.16244323094984,8.18271314335201,4.50453934354474,7.33442566054635,8.25966374269006,7.38414669783752,5.18625013760234,11.4394020016885,11.0231924080553,11.6654863989306,9.52946522657514,10.6695080583002,10.9266248723521,10.9197430826349,11.3709750520062,9.19451914098973,8.28275446883394,7.94932478030371,9.24457581475404,8.03113665833102,8.55000722475601,9.78867233024303,8.83497903990617,8.93590525709103,8.40468536211813,9.20833768350815,14.6235004359233,9.14099752540553,9.25362380726576,10.071916144362,10.2299157315414,9.53532501124606,9.6692579869516,6.74509066901192,6.15330113532256,10.370515751246,9.09049954542503,10.0200564971751,9.99355289703415,9.88888637303393,10.1040336280696,10.8806689799788,9.56867589462954,9.64989309691582,9.59445850469261,10.2050152804098,6.26349779607528,9.42211912179202,8.55998200089996,10.2877507209013,10.7581823929192,10.6451528237764,11.9985754985755,9.76825280429092,8.99327614784088,11.4474117631613,9.70573684210526,12.1574041554997,11.497954956176,11.3042534581891,11.3759900746382,9.82397108745685,10.1992643383914,9.60990396323765,10.1352400106444,11.1735921402681,10.9352417209583,12.5235490845219,9.37695599122917,7.36736819076215,8.50389554904833,10.0064754815115,8.75971822341257,5.71197632058288,10.2082991657245,6.83499782024821,8.34972918709436,8.5159294969901,7.59825818049018,8.82701794307081,9.03590451416538,9.87622644263949,9.11774527637991,10.6562578539116,9.02415923073705,8.6325129421166,8.07352846617576,8.67711568456971,9.53897002479153,10.4323571790708,9.55134699454577,8.23348825302021,11.3671288501025,7.77127949484879,10.0348218426317,4.62527947083762,10.8843581622251,8.25159006795928,9.70476598677189,11.7849004678274,8.9042444268613,7.92652243117573,8.59196938859061,10.1146409158338,9.93635420143594,7.50027150782794,8.92497366203119,9.61133772773696,11.27216297368,9.31947705785482,10.383642317916,11.8062762938835,9.70731034235409,11.3768352028353,12.43392079794,9.75080353306394,10.954336282998,10.0627506645497,10.9714908974219,11.308122722154,11.0229603167885,11.0450660684255,9.44562298758968,9.80939098232848,11.0337415490157,9.44409520768716,11.3151363836954,10.1944771429818,10.5068090610659,9.97160810956816,10.7108377702256,11.6810608083505,10.1507817845627,10.7478311836223,9.43459239453357,11.0599438832772,8.59815859385905,9.71960606060606,13.4246728289138,12.77689765739,11.5753587266828,12.5936655468382,11.9092415807718,11.8757667688817,13.7709865393588,12.8078287596983,12.2284521854719,10.4150769529002,11.5563892135782,12.4347670067491,11.1490500162763,13.2179099035547,11.4944177911044,11.6850967823027,11.5947060815405,13.2246412927179,13.0829872749355,11.8646892655367,12.23285559637,8.9506436717737,10.7164075537989,10.5491344604625,9.6306288837866,9.46711323763955,10.2178741406663,10.2451206140351,11.1472156911725,11.3551950960356,13.1360618372132,12.8972542216254,11.1321021621822,11.3428938232784,13.1956295726496,9.92346120659214,13.6544290469195,13.9194602707098,12.4209249399068,13.3081934177611,10.5110734476415,9.6772187240439,12.7020435686769,11.0205342125979,10.7740011336332,12.7091824512936,11.5009953445245,11.838172412336,13.2813176174198,12.4597419915924,6.61591751334222,8.69011815774355,9.20163304752858,10.2971142483007,10.7400240500241,10.5630495400263,11.5585938746887,11.4228027810029,8.60029074381825,11.2039298127196,8.31935611851578,8.13603942755946,8.63198170755892,9.10132321826058,11.7823916935195,10.8153386745778,10.1044988057919,11.4809949081829,12.1552691594563,9.04344598105775,12.445652173913,11.7211199914749,9.7214552545156,9.75586180958521,10.6075389666176,10.4591444106378,12.0353832018138,10.6580542566339,11.0539762954624,10.431050257732,8.9111255603606,11.277834613857,10.7113321544356,10.1029541111782,9.74765199671523,11.7279558338076,9.87371311989956,10.2047614797847,9.86604548789435,9.72221823933551,9.83538961038961,10.3045918073048,9.2146476941485,6.90222222222222,6.29683653528726,9.78223904148171,9.3864455157637,10.8817011927181,9.48757888114595,10.2362047552975,10.3534592553053,11.075065913371,9.76781848706826,10.1907621082621,9.84487541239105,10.8019088319088,10.2215301318267,9.32761898089767,10.2577933993594,10.3145980079593,9.92818679537931,9.80280614666391,12.8764114273625,13.3398029761572,13.0437226884185,12.4051819949986,11.7832403262114,12.420487387962,12.8436945026791,13.1318613325649,11.5568368020345,12.4233210639628,10.1144205471639,12.8403648688476,5.71523907808738,11.3662880536154,11.098743664562,6.30819786503374,11.2191912054405,10.4409234137763,10.0585723614208,9.41794745484401,11.5759336442523,10.2481154110321,10.0309493797519,9.74949138853279,9.20805996457349,8.48309472249895,6.11159409772617,11.9759798147557],"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"show_secondary_x_label":null,"chart_type":"histogram","xax_format":"plain","x_label":"PM2.5 Emissions (??g/m3)","markers":[{"pm25":12,"label":"national standard"}],"baselines":null,"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":null,"max_x":null,"min_y":0,"max_y":120,"bar_margin":2,"binned":false,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"pm25","y_accessor":"","multi_line":null,"geom":"hist","yax_units":"","legend":"East","legend_target":"#mjs-03af46137944300460e366be407c90-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-03af46137944300460e366be407c90","full_height":true},"evals":[],"jsHooks":[]}</script>
</td>
</tr>
</table><!--/html_preserve-->

<br>
  
By setting the range of the y-axis the same in both histograms, we can see indeed that there are more counties in the east (right histogram) that have average PM2.5 emissions that are greater than the national standards. However, while the maximum average PM2.5 emission for counties from the east reached only up to about $15~\mu g/m^3$, counties from the west exceeded $18~\mu g/m^3$.

Lets take a look at separate scatterplots of the eastern and western counties. 

<br>


```r
east %>%
        mjs_plot(x = latitude,                         ### variable to plot on x-axis 
                 y = pm25,                             ### variable to plot on y-axis
                 width = 450,                          ### width in pixels of the plot
                 height = 375) %>%                     ### height in pixels of the plot
        mjs_point(y_rug = TRUE) %>%                    ### type of plot, include rug
        mjs_labs(x = "Latitude",                       ### x axis label
                 y = "PM2.5 Emissions (??g/m3)") %>%   ### y axis 
        mjs_axis_y(min_y = 0, max_y = 20) %>%          ### set y-axis range
        mjs_add_baseline(12, "National Standard") %>%  ### add horizontal line
        mjs_add_legend("East") -> pl2                  ### add legend, assign as pl2

west %>%
        mjs_plot(x=latitude,                           ### variable to plot on x-axis
                 y=pm25,                               ### variable to plot on y-axis
                 width=450,                            ### width in pixels of the plot
                 height=375) %>%                       ### height in pixels of the plot
        mjs_point(y_rug=TRUE) %>%                      ### type of plot, include rug
        mjs_labs(x="Latitude",                         ### x axis labels
                 y="PM2.5 Emissions (??g/m3)") %>%     ### y axis labels
        mjs_axis_y(min_y = 0,
                   max_y = 20) %>%                     ### set y-axis range
        mjs_add_baseline(12, "National Standard") %>%  ### add horizontal line
        mjs_add_legend("West") -> pl1                  ### add legend, assign as pl1

mjs_grid(pl1, pl2, ncol = 2, nrow = 1, widths = c(rep(1, 3))) ### layout of plots
```

<!--html_preserve--><table style="width:100%" width="100%">
<tr width="100%" style="width:100%">
<td style="width:100.00%" width="100.00%">
<div id="mjs-9c72b1a8016f1074806c66d6ac6427" class="metricsgraphics html-widget" style="width:450px;height:375px;"></div>
<div id="mjs-9c72b1a8016f1074806c66d6ac6427-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-9c72b1a8016f1074806c66d6ac6427">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"pm25":[6.05886019051495,11.1014667422525,7.30811257305026,7.14762626262626,6.92984404484405,6.132350718065,8.22833917280753,5.3284750021471,10.5028619597453,11.3264992137362,5.16541323932628,9.46590188607592,9.84229717813051,6.76874278843292,6.94475890985325,8.54517291213449,16.1945239442507,7.19696623951355,9.41794677963536,6.43133065191889,15.803779721076,18.4407314017251,3.49435096561789,16.6618011295383,8.15131805731041,15.0157326718079,6.45565456155149,5.28099869664386,14.5062723406882,7.96918321142459,9.67839312107419,17.4290486592135,9.67934206826549,5.99577421686427,9.84362711860765,10.7410869231163,11.5600218772021,7.30846636864851,8.99963596301318,8.41596420305724,9.84144647290684,6.19679173840357,5.5605463980464,5.70241404638811,10.0994598549599,6.9254031864888,16.2519038272246,7.30965689062766,16.1835830784913,9.61713614709045,7.7050032488629,8.46951893407169,6.65466368191024,6.77176468914163,7.73387698622957,5.73200461553332,4.18609021246952,5.97189954174968,6.61487829803047,9.32877602411928,6.27593990755008,7.68074488100719,6.82441875383051,5.78351927988093,5.6939448645207,10.3294045074514,4.91714043782155,10.7924482408342,8.8466406534255,10.3763269924492,12.4378980220572,13.3469102904998,8.18520238962262,6.87545272286954,8.03003253664964,11.4640386259067,8.29427321917999,7.18724327002699,5.13591559259374,6.17056584886774,8.85858796296296,6.6724260979013,7.20333687724705,5.42580029507551,5.6890965386104,7.83828823219103,4.79364360267758,5.67873831775701,4.60140846243545,4.19568783609012,4.46019342212702,7.05767640265159,6.12148745519713,4.978396874298,11.4225845410628,6.54402211698387,7.85746426250812,11.2011307767945,9.60610446840563,7.98116553828948,9.55933933933934,7.13897840264273,7.51253738783649,6.72289109682447,8.61749931072512,4.32473577258088,4.17590077169482,6.10528517104277,5.34960373116053,7.41224168467053,10.3050851370785,7.7402380952381,5.99885671918139,7.97454300238614,9.75774088312412,9.63155203967738,9.63223241847081,6.62455532902934,8.86685828172715,9.19589464159308,7.93077902151641,7.93944411490059,8.84377007829653,7.82149191897902,9.46225263808188,5.27225233101856,3.38262576396183,8.50559576495175,4.1327393431167,4.95557025220927,6.54923928184728,5.63258693361433,6.34970982855398,4.56580800325485],"fips":["02020","02090","02110","02170","04003","04005","04013","04019","04021","04023","04025","06001","06007","06009","06011","06013","06019","06023","06025","06027","06029","06031","06033","06037","06045","06047","06053","06057","06059","06061","06063","06065","06067","06069","06073","06075","06077","06079","06081","06083","06085","06087","06089","06093","06095","06097","06099","06101","06107","06111","06113","08001","08005","08013","08031","08035","08039","08041","08069","08077","08083","08123","15001","15003","15009","16001","16005","16009","16027","16041","16059","16079","30029","30031","30049","30053","30063","30081","30083","30089","30093","32003","32031","35001","35005","35013","35017","35025","35045","35049","38007","38015","38057","41017","41025","41029","41033","41035","41037","41039","41043","41051","41059","41061","41067","46033","46071","46103","48043","48135","48141","48303","48375","49003","49005","49011","49035","49045","49049","49057","53011","53033","53053","53061","53077","56005","56009","56013","56021","56029","56033","56035","56037","56039"],"region":["west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west","west"],"longitude":[-149.762097,-147.568384,-134.511579,-149.481089,-109.904319,-111.511062,-112.087906,-111.088624,-111.498113,-110.905734,-112.414707,-122.096151,-121.64631,-120.557245,-122.152389,-122.060886,-119.90347,-123.988265,-115.487593,-117.693329,-118.683344,-119.811272,-122.751791,-118.234216,-123.430217,-120.674118,-121.528953,-120.814268,-117.861663,-120.947618,-120.851195,-116.803605,-121.389266,-121.288843,-117.062993,-122.437392,-121.281307,-120.58746,-122.331932,-120.071425,-121.912818,-121.973761,-122.121202,-122.502816,-122.051826,-122.768624,-120.9588,-121.658159,-119.166093,-119.045326,-121.775709,-104.869954,-104.841455,-105.195154,-104.965486,-104.888716,-104.292156,-104.748828,-105.213007,-108.509096,-108.575842,-104.728213,-155.393159,-158.035861,-156.615839,-116.280069,-112.346267,-116.637643,-116.673633,-111.855585,-113.778243,-116.040486,-114.321279,-111.186786,-112.153933,-115.359348,-113.968607,-114.117236,-104.458252,-115.084463,-112.562536,-115.117901,-119.763634,-106.612469,-104.444987,-106.78167,-108.246748,-103.327764,-108.30406,-106.007134,-103.359665,-100.641038,-101.686375,-121.337204,-119.039719,-122.785659,-123.432362,-121.651634,-120.57698,-123.080812,-122.731425,-122.613233,-118.817308,-118.031311,-122.915144,-103.51523,-101.669286,-103.105497,-103.402219,-102.43482,-106.351813,-101.852068,-101.842212,-112.480319,-111.842117,-111.940753,-111.915566,-112.690027,-111.73671,-111.972867,-122.547831,-122.196851,-122.383565,-122.094183,-120.512943,-105.496159,-105.502721,-108.681116,-104.762083,-108.999016,-106.96813,-109.991147,-109.168198,-110.673534],"latitude":[61.1919,64.81859,58.351422,61.762742,31.750272,35.77144,33.494514,32.17841,32.965668,31.4819,34.650332,37.716662,39.648354,38.167573,39.187495,37.942423,36.638374,40.747403,32.963098,36.709037,35.296023,36.155141,39.023264,34.08851,39.363102,37.245783,36.450732,39.270775,33.731518,38.971576,40.020149,33.783307,38.561106,36.745753,32.904616,37.759881,37.945959,35.373909,37.531037,34.649384,37.306509,37.002349,40.688705,41.614943,38.235934,38.440089,37.613805,39.076193,36.234647,34.277048,38.634155,39.866716,39.641904,40.058094,39.726287,39.461171,39.293642,38.865444,40.534099,39.095228,37.353687,40.346681,19.683885,21.426126,20.901025,43.5603,42.777785,47.240039,43.61814,42.153211,44.948818,47.417879,48.26788,45.663871,46.813873,48.558617,46.939971,46.210173,47.779342,47.633114,45.960929,36.139215,39.704166,35.101046,33.355893,32.274123,32.708567,32.728441,36.577598,35.588826,46.990106,46.890682,47.284699,43.996058,43.461427,42.389833,42.362158,42.662031,42.713376,43.989252,44.544833,45.522473,45.637299,45.325011,45.496796,43.693106,43.76851,44.045194,29.994131,31.867206,31.770159,33.570085,35.257052,41.595787,41.751082,41.00435,40.655802,40.415422,40.236597,41.232183,45.692187,47.548745,47.171571,47.976838,46.482454,44.085797,42.857379,43.098213,41.196199,44.568961,44.783629,42.750949,41.640708,43.612124]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"show_secondary_x_label":null,"chart_type":"point","xax_format":"plain","x_label":"Latitude","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":null,"max_x":null,"min_y":0,"max_y":20,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"latitude","y_accessor":"pm25","multi_line":null,"geom":"point","yax_units":"","legend":"West","legend_target":"#mjs-9c72b1a8016f1074806c66d6ac6427-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-9c72b1a8016f1074806c66d6ac6427"},"evals":[],"jsHooks":[]}</script>
</td>
<td style="width:100.00%" width="100.00%">
<div id="mjs-35e3927cae6ad9e2f5bd69922aec60" class="metricsgraphics html-widget" style="width:450px;height:375px;"></div>
<div id="mjs-35e3927cae6ad9e2f5bd69922aec60-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-35e3927cae6ad9e2f5bd69922aec60">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"pm25":[9.77118522614686,9.99381725284814,10.6886181012839,11.3374236874237,12.1197644686119,10.8278048723489,11.5839280137523,11.2619958748527,9.41442269955754,11.3914937063423,12.3847949521764,10.6495003064202,11.3338213580728,12.3024361179754,11.0245082815735,10.8355150496786,10.4362348272642,11.1147433188335,10.8231569069069,10.7455228065043,10.4503506375228,10.7239588859416,10.4417366946779,11.0976451597588,11.8400858533296,11.1050030345373,10.8870238095238,10.6965244667289,10.641452991453,9.82177829367954,8.89481883497206,7.02987073611182,10.001609188939,8.82187485318614,10.4129542695584,11.5517555159747,10.8377180079334,11.0238225610986,7.50346095206785,6.87720081743389,6.9775362209526,7.37522901571828,8.3783776391644,8.96184160987206,8.3415452544009,6.74496639545312,9.79596697012138,5,7.28553506718511,6.34854026253636,7.73819636495411,7.67951903770358,7.58490910924539,6.8008151008151,7.50035481331534,7.21377345515277,11.9592084944023,10.8244700530908,11.2922785144695,12.9139027854494,12.018415914295,12.1454136960407,11.746439215797,11.8178209192191,9.79381248890527,12.1452780063074,11.1883344861037,11.4223252694182,9.70988046483951,12.2006601852966,10.9490592810391,12.392874647024,10.6727069308928,11.3584635917969,12.1213807083732,9.35373976746836,11.059005118607,11.8780076805531,10.9013088512241,11.2698378522063,10.336829004329,10.5814567968035,9.2564950627936,10.2752187901461,10.003862064924,10.4695875139353,11.6319264428935,12.702122831133,11.1160700016684,10.1047342756054,9.65526315789474,12.3310604774049,11.0390648425787,10.5051792723394,10.0347250809987,13.0931187500138,13.1446592093778,11.8553016640881,13.0239225555372,12.0461756061115,12.3671405767727,11.630028527498,11.4432521852433,11.6924524127122,11.8117812795938,12.7532869466665,10.6469459530144,12.0895111242388,13.8832168707687,12.1973541767198,13.4352543307883,12.224040041983,12.1950547177351,12.8288775395985,12.2609157118629,10.4736962770473,11.6990452738192,10.9172629816653,11.1236639236879,10.407355367073,9.28889224065695,12.679210751879,8.82850404312669,9.40201510835567,10.8313455499634,11.9607604301067,9.28110499880411,8.93896188478685,9.33779024592978,9.05711530713215,9.32216152841153,8.68183331819695,9.7411819651878,11.2818263607737,11.405536872264,12.6653247822665,11.8011875934401,9.68513234753605,11.3224653698792,12.0517527673095,12.3957936523464,11.1037138188609,11.7650292954172,11.8591950782035,13.0588135499759,11.9036446011229,11.6700302343159,10.3434330163497,11.5546621879169,10.0901497369687,11.5114626909954,10.8511742051786,8.87430973517136,9.97039679617448,9.76181836142642,9.07945329347656,9.79997038240766,9.70396147150449,8.89871776296726,12.1783537749805,9.13448640646916,8.52827622014538,11.8026775921897,7.79428610906411,6.16244323094984,8.18271314335201,4.50453934354474,7.33442566054635,8.25966374269006,7.38414669783752,5.18625013760234,11.4394020016885,11.0231924080553,11.6654863989306,9.52946522657514,10.6695080583002,10.9266248723521,10.9197430826349,11.3709750520062,9.19451914098973,8.28275446883394,7.94932478030371,9.24457581475404,8.03113665833102,8.55000722475601,9.78867233024303,8.83497903990617,8.93590525709103,8.40468536211813,9.20833768350815,14.6235004359233,9.14099752540553,9.25362380726576,10.071916144362,10.2299157315414,9.53532501124606,9.6692579869516,6.74509066901192,6.15330113532256,10.370515751246,9.09049954542503,10.0200564971751,9.99355289703415,9.88888637303393,10.1040336280696,10.8806689799788,9.56867589462954,9.64989309691582,9.59445850469261,10.2050152804098,6.26349779607528,9.42211912179202,8.55998200089996,10.2877507209013,10.7581823929192,10.6451528237764,11.9985754985755,9.76825280429092,8.99327614784088,11.4474117631613,9.70573684210526,12.1574041554997,11.497954956176,11.3042534581891,11.3759900746382,9.82397108745685,10.1992643383914,9.60990396323765,10.1352400106444,11.1735921402681,10.9352417209583,12.5235490845219,9.37695599122917,7.36736819076215,8.50389554904833,10.0064754815115,8.75971822341257,5.71197632058288,10.2082991657245,6.83499782024821,8.34972918709436,8.5159294969901,7.59825818049018,8.82701794307081,9.03590451416538,9.87622644263949,9.11774527637991,10.6562578539116,9.02415923073705,8.6325129421166,8.07352846617576,8.67711568456971,9.53897002479153,10.4323571790708,9.55134699454577,8.23348825302021,11.3671288501025,7.77127949484879,10.0348218426317,4.62527947083762,10.8843581622251,8.25159006795928,9.70476598677189,11.7849004678274,8.9042444268613,7.92652243117573,8.59196938859061,10.1146409158338,9.93635420143594,7.50027150782794,8.92497366203119,9.61133772773696,11.27216297368,9.31947705785482,10.383642317916,11.8062762938835,9.70731034235409,11.3768352028353,12.43392079794,9.75080353306394,10.954336282998,10.0627506645497,10.9714908974219,11.308122722154,11.0229603167885,11.0450660684255,9.44562298758968,9.80939098232848,11.0337415490157,9.44409520768716,11.3151363836954,10.1944771429818,10.5068090610659,9.97160810956816,10.7108377702256,11.6810608083505,10.1507817845627,10.7478311836223,9.43459239453357,11.0599438832772,8.59815859385905,9.71960606060606,13.4246728289138,12.77689765739,11.5753587266828,12.5936655468382,11.9092415807718,11.8757667688817,13.7709865393588,12.8078287596983,12.2284521854719,10.4150769529002,11.5563892135782,12.4347670067491,11.1490500162763,13.2179099035547,11.4944177911044,11.6850967823027,11.5947060815405,13.2246412927179,13.0829872749355,11.8646892655367,12.23285559637,8.9506436717737,10.7164075537989,10.5491344604625,9.6306288837866,9.46711323763955,10.2178741406663,10.2451206140351,11.1472156911725,11.3551950960356,13.1360618372132,12.8972542216254,11.1321021621822,11.3428938232784,13.1956295726496,9.92346120659214,13.6544290469195,13.9194602707098,12.4209249399068,13.3081934177611,10.5110734476415,9.6772187240439,12.7020435686769,11.0205342125979,10.7740011336332,12.7091824512936,11.5009953445245,11.838172412336,13.2813176174198,12.4597419915924,6.61591751334222,8.69011815774355,9.20163304752858,10.2971142483007,10.7400240500241,10.5630495400263,11.5585938746887,11.4228027810029,8.60029074381825,11.2039298127196,8.31935611851578,8.13603942755946,8.63198170755892,9.10132321826058,11.7823916935195,10.8153386745778,10.1044988057919,11.4809949081829,12.1552691594563,9.04344598105775,12.445652173913,11.7211199914749,9.7214552545156,9.75586180958521,10.6075389666176,10.4591444106378,12.0353832018138,10.6580542566339,11.0539762954624,10.431050257732,8.9111255603606,11.277834613857,10.7113321544356,10.1029541111782,9.74765199671523,11.7279558338076,9.87371311989956,10.2047614797847,9.86604548789435,9.72221823933551,9.83538961038961,10.3045918073048,9.2146476941485,6.90222222222222,6.29683653528726,9.78223904148171,9.3864455157637,10.8817011927181,9.48757888114595,10.2362047552975,10.3534592553053,11.075065913371,9.76781848706826,10.1907621082621,9.84487541239105,10.8019088319088,10.2215301318267,9.32761898089767,10.2577933993594,10.3145980079593,9.92818679537931,9.80280614666391,12.8764114273625,13.3398029761572,13.0437226884185,12.4051819949986,11.7832403262114,12.420487387962,12.8436945026791,13.1318613325649,11.5568368020345,12.4233210639628,10.1144205471639,12.8403648688476,5.71523907808738,11.3662880536154,11.098743664562,6.30819786503374,11.2191912054405,10.4409234137763,10.0585723614208,9.41794745484401,11.5759336442523,10.2481154110321,10.0309493797519,9.74949138853279,9.20805996457349,8.48309472249895,6.11159409772617,11.9759798147557],"fips":["01003","01027","01033","01049","01055","01069","01073","01089","01097","01103","01113","01117","01121","01125","01127","05001","05003","05035","05045","05051","05067","05107","05113","05115","05119","05131","05139","05143","05145","09001","09003","09005","09009","09011","10001","10003","10005","11001","12001","12009","12011","12017","12031","12033","12057","12071","12073","12086","12095","12099","12103","12105","12111","12115","12117","12127","13021","13051","13059","13063","13067","13089","13095","13121","13127","13135","13139","13153","13185","13215","13223","13245","13295","13303","13319","17001","17019","17031","17043","17065","17083","17089","17097","17099","17111","17113","17115","17119","17143","17157","17161","17163","17167","17197","17201","18003","18019","18035","18037","18039","18043","18051","18065","18067","18083","18089","18091","18095","18097","18127","18141","18147","18157","18163","18167","19013","19045","19103","19111","19113","19137","19139","19147","19153","19155","19163","19177","20091","20107","20173","20177","20191","20209","21013","21019","21029","21037","21043","21047","21059","21067","21073","21093","21101","21111","21117","21145","21151","21183","21195","21227","22017","22019","22033","22047","22051","22055","22073","22079","22087","22105","22109","22121","23001","23003","23005","23009","23011","23017","23019","23021","24003","24005","24015","24025","24031","24033","24043","24510","25003","25005","25009","25013","25017","25023","25025","25027","26005","26017","26021","26033","26049","26065","26077","26081","26091","26099","26101","26113","26115","26121","26125","26139","26147","26161","26163","27037","27053","27109","27123","27137","27139","27145","28001","28011","28033","28035","28043","28047","28049","28059","28067","28075","28081","29021","29037","29039","29047","29077","29095","29099","29510","31055","31079","31109","31153","31177","33001","33005","33009","33011","33013","33015","34001","34003","34007","34015","34017","34021","34023","34027","34029","34031","34039","34041","36001","36005","36013","36029","36031","36047","36055","36059","36061","36063","36067","36071","36081","36085","36101","36103","36119","37001","37021","37033","37035","37037","37051","37057","37061","37063","37065","37067","37071","37081","37087","37099","37107","37111","37117","37119","37121","37123","37147","37155","37159","37173","37183","37189","37191","38017","39009","39017","39023","39025","39035","39049","39057","39061","39081","39087","39093","39095","39099","39103","39113","39133","39135","39145","39151","39153","39165","40001","40015","40097","40101","40109","40115","40121","40135","40143","42001","42003","42007","42011","42017","42021","42027","42029","42041","42043","42045","42049","42069","42071","42085","42091","42095","42101","42125","42129","42133","44003","44007","45019","45025","45037","45041","45045","45063","45073","45079","46011","46013","46029","46099","47009","47037","47045","47065","47093","47099","47105","47107","47113","47119","47125","47141","47145","47157","47163","47165","48029","48037","48061","48113","48139","48201","48203","48215","48245","48355","48361","48439","48453","50003","50007","50021","51003","51013","51036","51041","51059","51069","51087","51107","51139","51165","51520","51680","51710","51770","51775","51810","54003","54009","54011","54029","54033","54039","54049","54051","54061","54069","54081","54107","55003","55009","55025","55041","55043","55059","55063","55071","55079","55087","55089","55109","55111","55119","55125","55133"],"region":["east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east","east"],"longitude":[-87.74826,-85.842858,-87.72596,-85.798919,-86.032125,-85.350387,-86.82805,-86.588226,-88.139667,-86.91892,-85.1011,-86.698665,-86.178278,-87.511691,-87.285406,-91.429413,-91.785346,-90.2728,-92.379944,-93.075894,-91.227582,-90.761973,-94.253631,-93.084446,-92.294471,-94.351769,-92.612793,-94.198684,-91.730562,-73.35482,-72.715449,-73.212688,-72.94032,-72.092949,-75.560273,-75.611707,-75.342268,-77.013222,-82.379953,-80.685189,-80.206098,-82.469163,-81.638873,-87.277355,-82.412079,-81.846262,-84.260888,-80.302264,-81.404159,-80.176395,-82.727766,-81.758303,-80.360875,-82.398881,-81.310831,-81.138947,-83.665205,-81.107165,-83.380111,-84.365597,-84.559283,-84.25768,-84.163206,-84.419327,-81.496294,-84.058446,-83.842959,-83.663234,-83.277179,-84.942179,-84.831116,-82.028396,-85.291825,-82.782607,-83.226599,-91.268051,-88.216752,-87.767817,-88.063587,-88.536242,-90.342138,-88.338441,-87.983801,-88.904285,-88.353772,-88.883582,-88.953227,-90.018837,-89.665063,-89.796877,-90.507532,-90.002067,-89.646499,-88.02984,-89.08163,-85.100068,-85.727465,-85.396077,-86.900551,-85.899404,-85.863288,-87.558364,-85.405985,-86.126407,-87.418937,-87.395253,-86.779261,-85.719201,-86.14181,-87.086655,-86.241933,-87.013205,-86.88088,-87.556964,-87.391268,-92.344731,-90.427404,-91.568871,-91.416607,-91.630559,-95.159253,-91.084801,-94.688715,-93.630942,-95.680399,-90.578862,-91.948808,-94.753767,-94.805322,-97.36347,-95.710259,-97.432563,-94.69276,-83.702245,-82.664583,-85.672052,-84.433303,-83.049318,-87.481989,-87.105097,-84.494642,-84.868393,-85.914926,-87.568076,-85.704021,-84.539347,-88.651111,-84.27224,-86.879363,-82.411115,-86.42455,-93.813906,-93.291757,-91.119654,-91.287188,-90.1514,-92.038879,-92.115857,-92.476589,-89.89026,-90.462949,-90.735917,-91.263053,-70.217663,-68.261663,-70.327978,-68.415711,-69.784554,-70.705175,-68.722469,-69.33369,-76.576891,-76.612627,-75.951459,-76.290245,-77.124386,-76.882176,-77.774436,-76.617016,-73.209889,-71.102131,-70.970827,-72.571312,-71.275566,-70.818958,-71.073493,-71.840209,-85.903867,-83.917406,-86.426818,-84.497987,-83.700504,-84.469828,-85.561317,-85.612696,-84.065929,-82.951762,-86.135402,-85.145565,-83.484125,-86.21617,-83.305598,-86.049749,-82.597855,-83.759473,-83.19795,-93.120132,-93.362357,-92.442548,-93.106593,-92.404547,-93.510829,-94.495886,-91.354348,-90.830139,-89.992068,-89.276207,-89.803446,-89.079536,-90.305374,-88.633143,-89.17378,-88.678186,-88.682514,-94.827011,-94.376663,-93.885396,-94.474033,-93.316087,-94.463242,-90.499266,-90.242806,-96.050944,-98.417732,-96.681392,-96.031099,-96.198876,-71.436077,-72.242077,-71.89463,-71.582737,-71.637253,-71.077622,-74.621566,-74.059037,-75.029263,-75.136197,-74.069,-74.711654,-74.383918,-74.500442,-74.210903,-74.216831,-74.301654,-75.030699,-73.849077,-73.873207,-79.345719,-78.796303,-73.737594,-73.952247,-77.630324,-73.602538,-73.973533,-78.848097,-76.179117,-74.27948,-73.820376,-74.140923,-77.363147,-73.026232,-73.794013,-79.413917,-82.531461,-79.320014,-81.247567,-79.282856,-78.907247,-80.197806,-77.988007,-78.900356,-77.640306,-80.244596,-81.166447,-79.846984,-82.960527,-83.183862,-77.630588,-82.038396,-77.123835,-80.830859,-82.142844,-79.903306,-77.391082,-79.106531,-80.515502,-83.446528,-78.665751,-81.700107,-77.995343,-97.084444,-82.075082,-84.513194,-83.826362,-84.177419,-81.663852,-82.996532,-83.949396,-84.493792,-80.72585,-82.547506,-82.135816,-83.608466,-80.706497,-81.872052,-84.21859,-81.253721,-84.637188,-82.943068,-81.383599,-81.520637,-84.221759,-94.640694,-98.344737,-95.211238,-95.367134,-97.496525,-94.839825,-95.7143,-94.788897,-95.938999,-77.182542,-79.959705,-80.312675,-75.914242,-75.027841,-78.789233,-77.834459,-75.683302,-77.133685,-76.804656,-75.350636,-80.056979,-75.632209,-76.281219,-80.313128,-75.317433,-75.322072,-75.144793,-80.13855,-79.561874,-76.742183,-71.479529,-71.456165,-79.991379,-80.15629,-81.904462,-79.740304,-82.353114,-81.232319,-83.02142,-80.974331,-96.798488,-98.381992,-97.157383,-96.742201,-83.969238,-86.765764,-89.358984,-85.2301,-83.955932,-87.375807,-84.29551,-84.595909,-88.827384,-87.064841,-87.370428,-85.495277,-84.526726,-89.926902,-82.383596,-86.487509,-98.508944,-94.250198,-97.557442,-96.788828,-96.798436,-95.363056,-94.353085,-98.159799,-94.061768,-97.458944,-93.842055,-97.26583,-97.769809,-73.107955,-73.12727,-73.05306,-78.535282,-77.10826,-77.071609,-77.545895,-77.249565,-78.244616,-77.476994,-77.568819,-78.488469,-78.84438,-82.176193,-79.170205,-76.2599,-79.955711,-80.055836,-76.087179,-77.983926,-80.590963,-82.323238,-80.575484,-80.341952,-81.605694,-80.197936,-80.712893,-79.994783,-80.67612,-81.228271,-81.5317,-90.721893,-88.032769,-89.393668,-88.770485,-90.667336,-87.952431,-91.189127,-87.75858,-87.960713,-88.410017,-87.944718,-92.506966,-89.90087,-90.491269,-89.531836,-88.255888],"latitude":[30.592781,33.26581,34.73148,34.459133,34.018597,31.189731,33.527872,34.73079,30.722256,34.507018,32.376002,33.26912,33.368498,33.2356,33.819888,34.359997,33.18542,35.197701,35.119477,34.545307,35.613258,34.468372,34.48549,35.330478,34.766541,35.293916,33.207179,36.051379,35.250106,41.212896,41.769967,41.754255,41.390764,41.446109,39.092714,39.695612,38.651424,38.913611,29.676436,28.220079,26.134788,28.894637,30.320873,30.502045,27.966349,26.602541,30.462933,25.756427,28.547129,26.637745,27.889647,27.992436,27.348246,27.16493,28.709909,29.049037,32.829689,32.047559,33.954747,33.566178,33.935535,33.790944,31.572874,33.779605,31.187633,33.967056,34.296799,32.558055,30.848527,32.490061,33.902776,33.429488,34.818692,32.949364,32.83589,39.965452,40.136824,41.837649,41.856029,38.096779,39.083608,41.918229,42.313322,41.332155,42.296401,40.495251,39.853136,38.812515,40.752492,38.079211,41.491433,38.532682,39.763854,41.527431,42.311119,41.090284,38.386482,40.211893,38.350091,41.626089,38.316931,38.3177,39.923532,40.475438,38.697416,41.529603,41.599217,40.14594,39.792792,41.52351,41.664783,38.024372,40.409485,37.989892,39.456887,42.487586,41.871169,41.674915,40.576831,42.029994,41.013101,41.472456,43.090301,41.627938,41.308529,41.572127,40.740217,38.932175,38.223827,37.681327,39.03915,37.26461,39.103711,36.691388,38.425361,38.005184,39.036524,38.307846,36.854445,37.750648,38.029632,38.203653,37.738924,37.802623,38.209237,39.026743,37.059705,37.699681,37.456506,37.447794,36.986914,32.527562,30.237442,30.480122,30.275168,29.935238,30.207388,32.509377,31.262083,29.922088,30.607405,29.541174,30.452085,44.135072,46.637362,43.784479,44.512741,44.399958,44.324518,45.17193,45.565184,39.05786,39.372206,39.592628,39.534674,39.072608,38.906334,39.614696,39.307956,42.396128,41.778329,42.635475,42.12756,42.459085,41.978877,42.334948,42.329642,42.592727,43.636656,41.971239,46.322274,43.011877,42.667752,42.259641,42.98864,41.917635,42.591138,44.323788,44.32747,41.919053,43.254681,42.588233,42.929975,42.916954,42.260331,42.337237,44.7588,44.971331,44.007477,44.990915,47.369145,44.696343,45.540863,31.535545,33.803284,34.904345,31.263019,33.775041,30.427896,32.294333,30.455709,31.652274,32.400078,34.276904,39.722544,38.689373,37.7305,39.253674,37.216298,39.024005,38.285842,38.627718,41.264027,40.894156,40.796701,41.14287,41.516281,43.515202,42.911802,43.896067,42.895585,43.277704,42.96287,39.447721,40.930457,39.869213,39.752778,40.740351,40.252908,40.494044,40.867167,39.918818,40.946491,40.657752,40.803025,42.662095,40.846761,42.2407,42.859908,44.162194,40.649812,43.159963,40.715949,40.769656,43.146089,43.048433,41.406117,40.714295,40.582197,42.283617,40.833314,41.057167,36.076036,35.59526,36.406412,35.695613,35.702312,35.056213,35.816809,34.924123,35.998343,35.916244,36.1142,35.284549,36.052635,35.523376,35.313469,35.250556,35.686938,35.83833,35.231792,35.977691,35.340096,35.589908,34.658374,35.617342,35.421822,35.796512,36.217932,35.364712,46.899583,39.356909,39.427856,39.921309,39.059566,41.460301,39.990514,39.712555,39.179526,40.360701,38.530404,41.370274,41.649267,41.052558,41.11258,39.750258,41.172189,39.74386,38.78893,40.819408,41.095605,39.440152,35.896421,35.136539,36.314823,35.686587,35.509671,36.861373,34.939711,35.484348,36.124761,39.854379,40.440569,40.695415,40.377743,40.254936,40.435472,40.887275,39.988807,40.201203,40.324487,39.912978,42.052025,41.43348,40.06767,41.294427,40.170596,40.702861,39.998012,40.182615,40.326108,39.927299,41.704125,41.852849,32.809639,34.654172,33.771236,34.065068,34.861272,33.949223,34.715038,34.035404,44.34542,45.538665,44.939334,43.601442,35.754277,36.156595,36.060464,35.095522,35.973115,35.205257,35.744899,35.41638,35.628652,35.616397,36.510616,36.157835,35.87976,35.133382,36.530363,36.436444,29.453231,33.43807,26.082987,32.803579,32.391428,29.787777,32.548681,26.242291,29.98423,27.747148,30.114604,32.76383,30.321806,43.029418,44.475682,43.595081,38.024179,38.880344,37.344868,37.419938,38.840845,39.192751,37.584747,39.064634,38.613462,38.466513,36.611116,37.403672,36.885747,37.276895,37.286895,36.834498,39.462988,40.296424,38.412924,40.504722,39.297035,38.34893,39.499846,39.907446,39.634786,40.078772,37.771342,39.259427,46.337524,44.493492,43.071496,45.604373,42.876486,42.568669,43.859415,44.102318,43.034113,44.336535,43.329252,45.028469,43.444512,45.191826,46.024577,43.036352]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"show_secondary_x_label":null,"chart_type":"point","xax_format":"plain","x_label":"Latitude","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":false,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":6,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":null,"max_x":null,"min_y":0,"max_y":20,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"latitude","y_accessor":"pm25","multi_line":null,"geom":"point","yax_units":"","legend":"East","legend_target":"#mjs-35e3927cae6ad9e2f5bd69922aec60-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-35e3927cae6ad9e2f5bd69922aec60"},"evals":[],"jsHooks":[]}</script>
</td>
</tr>
</table><!--/html_preserve-->
  
<br>  
  
Viewing the separate scatterplots we can see that there were more counties in the east (right scatterplot) than in the west.

Utilizing the interactive functionality of metricgraphics we can determine that the highest ($18.4~\mu g/m^3$) and lowest ($3.8~\mu g/m^3$) average PM 2.5 emissions can be found in the east.

With a syntax that is easy to learn and economy in codes to produce the desired plots, metricgraphics with its interactive functionality, have a place in the process of exploring data. 

<br>

#### Which States were over the national standard in 1999 and how much have they improved by 2012

<br>

Again, we retrieve another jewel from the accidentally downloaded datascience repository and explore tha data for 1999 and 2012.  We will use metricgraphics once again to answer the question posed above.

<br>


```r
pm1999 <- read.table("DATA/RD_501_88101_1999-0.txt",     ### read the file
                     comment.char = "#",                 ### set # as comment
                     header = FALSE,                     ### don't include header or 1st line
                     sep = "|",                          ### set seperastor as |
                     na.strings = "")                    ### set NAs as blank spaces
cnames <- readLines("DATA/RD_501_88101_1999-0.txt", 1)   ### read 1st line which contain variable names

cnames <- strsplit(cnames, "|", fixed = TRUE)            ### seperate variable names from each other

names(pm1999) <- make.names(cnames[[1]])                 #### assign variable names to data

pm2012 <- read.table("DATA/RD_501_88101_2012-0.txt",     ### read the file
                     comment.char = "#",                 ### set # as comment
                     header = FALSE,                     ### don't include header or 1st line
                     sep = "|",                          ### set seperastor as |
                     na.strings = "")                    ### set NAs as blank spaces
names(pm2012) <- make.names(cnames[[1]])                 ### read 1st line which contain variable names
```

<br>

PM2.5 Emissions Data (RD_501_88101_1999-0.txt) and (RD_501_88101_2012-0.txt): This files contains a data frame of the average PM2.5 Emission levels for 1999 and 2012 across the USA respectively.

Please take note that the units for the PM 2.5 Emissions levels in the current datasets we are exploring, are in micrograms per meter cube ($\mu g/m^3$).

There are 28 variables in the data from 1999 and 2018 but we are only interested in the variables: 

- `State.Code` - a number representing the states in the USA
- `Sample.Value` - the observed PM2.5 level in $\mu g/m^3$

<br>



```r
mn1999 <- with(pm1999, tapply(Sample.Value,              ### take variable Sample.Value and
                              State.Code,                ### group by State.Code
                              mean,                      ### take the mean per State
                              na.rm = TRUE))             ### Don't include missing values

mn2012 <- with(pm2012, tapply(Sample.Value,              ### take variable Sample.Value and
                              State.Code,                ### group by State.Code
                              mean,                      ### take the mean per State
                              na.rm = TRUE))             ### Don't include missing values

df1999 <- data.frame(state = names(mn1999),              ### create dataframe with variable state and
                     mean = mn1999)                      ### mean 
df2012 <- data.frame(state = names(mn2012),              ### create dataframe with variable state and
                     mean = mn2012)                      ### mean

df1999 <- df1999[-53, ]                                  ### remove the 53rd state not in 2012 data

mrgdf <- merge(df1999, df2012, by = "state")             ### merge 2012 and 1999 data frame
mrgdf$mean.x <- as.integer(round(mrgdf$mean.x))          ### set mean.x as integer
mrgdf$mean.y <- as.integer(round(mrgdf$mean.y))          ### set mean.y as integer

names(mrgdf) <- c("state", "yr1999", "yr2012")           ### set variable names
```

<br>

We summarized the data to come up with a table of average PM2.5 levels for each state in 1999 and in 2012 but instead of showing the whole table we will use metricgraphics to compare the levels in 1999 and 2012 interactively. Please take note that the units for the PM 2.5 Emissions levels in this dataset are in micrograms per meter cube ($\mu g/m^3$).

<br>


```r
mrgdf %>%
        mjs_plot(x=state,                           ### assign the variable state to the x-axis
                 y=yr1999,                          ### assign the variable yr1999 to the y-axis
                 width=800,                         ### set the width of the plot to 800 pixels
                 height=250,                        ### set the height of the plot to 250 pixels
                 linked=TRUE) %>%                   ### link the two plots
        mjs_point() %>%                             ### create a line plot
        mjs_axis_x(xax_count = 56,                  ### create 56 ticks on the x-axis
                   min_x = 0,                       ### minimum tick value is 0
                   max_x = 56) %>%                  ### maximum tick value is 56
        mjs_labs(x="state",                         ### label x-axis as state
                 y="PM2.5 Emissions (??g/m3)") %>%  ### label y-axis as PM2.5
        mjs_add_baseline(12,                        ### add horizontal line  
                         "National Standard") %>%   ### label line as national standard at level 12
        mjs_add_legend(legend="X") -> mjs_brief_1   ### assign name to plot

mrgdf %>%
        mjs_plot(x=state,                           ### assign the variable state to the x-axis
                 y=yr2012,                          ### assign the variable yr1999 to the y-axis
                 width=800,                         ### set the width of the plot to 800 pixels
                 height=250,                        ### set the height of the plot to 250 pixels
                 linked=TRUE) %>%                   ### link the two plots
        mjs_point() %>%                             ### create a line plot
        mjs_axis_x(xax_count = 56,                  ### create 56 ticks on the x-axis
                   min_x = 0,                       ### minimum tick value is 0
                   max_x = 56) %>%                  ### maximum tick value is 56
        mjs_labs(x="state",                         ### label x-axis as state
                 y="PM2.5 Emissions (??g/m3)") %>%  ### label y-axis as PM2.5
        mjs_add_baseline(12,                        ### add horizontal line 
                         "National Standard") %>%   ### label line as national standard at level 12
        mjs_add_legend(legend="X") -> mjs_brief_2   ### assign name to plot

div(style="margin:auto;text-align:center",          ### align text to center
    strong("PM 2.5 levels, by State - 1999"), br(), mjs_brief_1,   ### set first text to bold
    strong("PM 2.5 levels, by State - 2012"), br(), mjs_brief_2)   ### set second text to bold
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>PM 2.5 levels, by State - 1999</strong>
<br/>
<div id="mjs-b656e62c9be34ec785c8e4ee3f74af" class="metricsgraphics html-widget" style="width:800px;height:250px;"></div>
<div id="mjs-b656e62c9be34ec785c8e4ee3f74af-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-b656e62c9be34ec785c8e4ee3f74af">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"state":["1","10","11","12","13","15","16","17","18","19","2","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","4","40","41","42","44","45","46","47","48","49","5","50","51","53","54","55","56","6","72","8","9"],"yr1999":[20,14,16,11,20,5,9,17,16,12,7,12,16,14,10,16,12,14,10,16,14,9,9,9,12,14,7,12,16,8,18,11,11,9,14,11,15,10,17,12,9,16,10,14,10,17,13,7,18,9,8,13],"yr2012":[10,11,12,8,11,9,9,11,11,10,5,8,11,12,7,10,9,9,8,11,10,7,9,7,6,8,8,9,10,7,12,9,11,7,11,7,9,6,12,11,6,11,7,9,6,10,8,4,9,6,4,8]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"point","xax_format":"plain","x_label":"state","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":56,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":0,"max_x":56,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"state","y_accessor":"yr1999","multi_line":null,"geom":"point","yax_units":"","legend":"X","legend_target":"#mjs-b656e62c9be34ec785c8e4ee3f74af-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-b656e62c9be34ec785c8e4ee3f74af"},"evals":[],"jsHooks":[]}</script>
<strong>PM 2.5 levels, by State - 2012</strong>
<br/>
<div id="mjs-cae05ae690bbac57454ca83757d0b1" class="metricsgraphics html-widget" style="width:800px;height:250px;"></div>
<div id="mjs-cae05ae690bbac57454ca83757d0b1-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-cae05ae690bbac57454ca83757d0b1">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"state":["1","10","11","12","13","15","16","17","18","19","2","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","4","40","41","42","44","45","46","47","48","49","5","50","51","53","54","55","56","6","72","8","9"],"yr1999":[20,14,16,11,20,5,9,17,16,12,7,12,16,14,10,16,12,14,10,16,14,9,9,9,12,14,7,12,16,8,18,11,11,9,14,11,15,10,17,12,9,16,10,14,10,17,13,7,18,9,8,13],"yr2012":[10,11,12,8,11,9,9,11,11,10,5,8,11,12,7,10,9,9,8,11,10,7,9,7,6,8,8,9,10,7,12,9,11,7,11,7,9,6,12,11,6,11,7,9,6,10,8,4,9,6,4,8]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"point","xax_format":"plain","x_label":"state","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":56,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":0,"max_x":56,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"state","y_accessor":"yr2012","multi_line":null,"geom":"point","yax_units":"","legend":"X","legend_target":"#mjs-cae05ae690bbac57454ca83757d0b1-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-cae05ae690bbac57454ca83757d0b1"},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

<br>

Metricgraphics provides an interactive comparison between 2 datapoints that are linked together. By hovering the mouse over state number 1 (Alabama), we can see that in 1999 it had one of the highest pm 2.5 levels, at 20 micrograms per meter cube. At the same time, we can see it's equivalent value of 10.1 in 2012. If we wanted to highlight the magnitude of the change in levels we can do something like this:

<br>


```r
mrgdf <- mrgdf %>%
        mutate(diff = yr2012 - yr1999) %>%
        mutate(diff2 = ifelse(diff < 0, "decreased",
                              ifelse(diff > 0, "increased",
                                     "no_change")))

mrgdf %>%
        mjs_plot(x=state,                           ### assign the variable state to the x-axis
                 y=yr1999,                          ### assign the variable yr1999 to the y-axis
                 width=800,                         ### set the width of the plot to 800 pixels
                 height=250,                        ### set the height of the plot to 250 pixels
                 linked=TRUE) %>%                   ### link the two plots
        mjs_point(point_size = 5) %>%                             ### create a line plot
        mjs_axis_x(xax_count = 56,                  ### create 56 ticks on the x-axis
                   min_x = 0,                       ### minimum tick value is 0
                   max_x = 56) %>%                  ### maximum tick value is 56
        mjs_labs(x="state",                         ### label x-axis as state
                 y="PM2.5 Emissions (??g/m3)") %>%  ### label y-axis as PM2.5
        mjs_add_baseline(12,                        ### add horizontal line  
                         "National Standard") %>%   ### label line as national standard at level 12
        mjs_add_legend(legend="X") -> mjs_brief_1   ### assign name to plot

mrgdf %>%
        mjs_plot(x=state,                           ### assign the variable state to the x-axis
                 y=yr2012,                          ### assign the variable yr1999 to the y-axis
                 width=800,                         ### set the width of the plot to 800 pixels
                 height=250,                        ### set the height of the plot to 250 pixels
                 linked=TRUE) %>%                   ### link the two plots
        mjs_point(color_accessor=diff2,             ### create a line plot, assign color to variable diff2
                  size_accessor=diff,               ### assign size to variable diff
                  size_range = c(1, 3),
                  color_type="category",            ### assign a discrete variable to color
                  color_range = c("blue",           ### assign color blue for a decrease in pm2.5 levels
                                  "red",            ### assign color red for an increase in pm2.5 levels
                                  "grey")) %>%      ### assign color grey when there's no change in pm2.5 levels
        mjs_axis_x(xax_count = 56,                  ### create 56 ticks on the x-axis
                   min_x = 0,                       ### minimum tick value is 0
                   max_x = 56) %>%                  ### maximum tick value is 56
        mjs_labs(x="state",                         ### label x-axis as state
                 y="PM2.5 Emissions (??g/m3)") %>%  ### label y-axis as PM2.5
        mjs_add_baseline(12,                        ### add horizontal line at 12
                        "National Standard") %>%    ### label line as national standard 
        mjs_add_legend(legend="X") -> mjs_brief_2   ### assign variable name to plot

div(style="margin:auto;text-align:center",          ### align text to center
    strong("PM 2.5 levels, by State - 1999"), br(), mjs_brief_1,   ### set first text to bold
    strong("PM 2.5 levels, by State - 2012"), br(), mjs_brief_2)   ### set second text to bold
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>PM 2.5 levels, by State - 1999</strong>
<br/>
<div id="mjs-2098d6a3413f60d2d1ba1b39119200" class="metricsgraphics html-widget" style="width:800px;height:250px;"></div>
<div id="mjs-2098d6a3413f60d2d1ba1b39119200-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-2098d6a3413f60d2d1ba1b39119200">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"state":["1","10","11","12","13","15","16","17","18","19","2","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","4","40","41","42","44","45","46","47","48","49","5","50","51","53","54","55","56","6","72","8","9"],"yr1999":[20,14,16,11,20,5,9,17,16,12,7,12,16,14,10,16,12,14,10,16,14,9,9,9,12,14,7,12,16,8,18,11,11,9,14,11,15,10,17,12,9,16,10,14,10,17,13,7,18,9,8,13],"yr2012":[10,11,12,8,11,9,9,11,11,10,5,8,11,12,7,10,9,9,8,11,10,7,9,7,6,8,8,9,10,7,12,9,11,7,11,7,9,6,12,11,6,11,7,9,6,10,8,4,9,6,4,8],"diff":[-10,-3,-4,-3,-9,4,0,-6,-5,-2,-2,-4,-5,-2,-3,-6,-3,-5,-2,-5,-4,-2,0,-2,-6,-6,1,-3,-6,-1,-6,-2,0,-2,-3,-4,-6,-4,-5,-1,-3,-5,-3,-5,-4,-7,-5,-3,-9,-3,-4,-5],"diff2":["decreased","decreased","decreased","decreased","decreased","increased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","increased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased"]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"point","xax_format":"plain","x_label":"state","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":56,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":0,"max_x":56,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"state","y_accessor":"yr1999","multi_line":null,"geom":"point","yax_units":"","legend":"X","legend_target":"#mjs-2098d6a3413f60d2d1ba1b39119200-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-2098d6a3413f60d2d1ba1b39119200"},"evals":[],"jsHooks":[]}</script>
<strong>PM 2.5 levels, by State - 2012</strong>
<br/>
<div id="mjs-db0358919f50ddb410e28af4a1b6eb" class="metricsgraphics html-widget" style="width:800px;height:250px;"></div>
<div id="mjs-db0358919f50ddb410e28af4a1b6eb-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-db0358919f50ddb410e28af4a1b6eb">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"state":["1","10","11","12","13","15","16","17","18","19","2","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","4","40","41","42","44","45","46","47","48","49","5","50","51","53","54","55","56","6","72","8","9"],"yr1999":[20,14,16,11,20,5,9,17,16,12,7,12,16,14,10,16,12,14,10,16,14,9,9,9,12,14,7,12,16,8,18,11,11,9,14,11,15,10,17,12,9,16,10,14,10,17,13,7,18,9,8,13],"yr2012":[10,11,12,8,11,9,9,11,11,10,5,8,11,12,7,10,9,9,8,11,10,7,9,7,6,8,8,9,10,7,12,9,11,7,11,7,9,6,12,11,6,11,7,9,6,10,8,4,9,6,4,8],"diff":[-10,-3,-4,-3,-9,4,0,-6,-5,-2,-2,-4,-5,-2,-3,-6,-3,-5,-2,-5,-4,-2,0,-2,-6,-6,1,-3,-6,-1,-6,-2,0,-2,-3,-4,-6,-4,-5,-1,-3,-5,-3,-5,-4,-7,-5,-3,-9,-3,-4,-5],"diff2":["decreased","decreased","decreased","decreased","decreased","increased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","increased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased"]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"point","xax_format":"plain","x_label":"state","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":5,"xax_count":56,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":"diff","color_accessor":"diff2","color_type":"category","color_range":["blue","red","grey"],"size_range":[1,3],"bar_height":20,"min_x":0,"max_x":56,"min_y":null,"max_y":null,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"state","y_accessor":"yr2012","multi_line":null,"geom":"point","yax_units":"","legend":"X","legend_target":"#mjs-db0358919f50ddb410e28af4a1b6eb-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-db0358919f50ddb410e28af4a1b6eb"},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

<br>

The size of the dot reflects the magnitude of the change in PM 2.5 levels while the color reflects whether there was a change in PM 2.5 levels. Red for increase, grey for no change, and blue for decrease 

<br>


```r
mrgdf <- mrgdf %>%
        mutate(diff = yr2012 - yr1999) %>%
        mutate(diff2 = ifelse(diff < 0, "decreased",
                              ifelse(diff > 0, "increased",
                                     "no_change")))

mrgdf %>%
        mjs_plot(x=state,                           ### assign the variable state to the x-axis
                 y=yr1999,                          ### assign the variable yr1999 to the y-axis
                 width=800,                         ### set the width of the plot to 800 pixels
                 height=250,                        ### set the height of the plot to 250 pixels
                 linked=TRUE) %>%                   ### link the two plots
        mjs_point(point_size = 5) %>%                             ### create a line plot
        mjs_axis_x(xax_count = 56,                  ### create 56 ticks on the x-axis
                   min_x = 0,                       ### minimum tick value is 0
                   max_x = 56) %>%                  ### maximum tick value is 56
        mjs_axis_y(min_y = 2,
                   max_y = 20,
                   yax_count = 10) %>%
        mjs_labs(x="state",                         ### label x-axis as state
                 y="PM2.5 Emissions (??g/m3)") %>%  ### label y-axis as PM2.5
        mjs_add_baseline(12,                        ### add horizontal line  
                         "National Standard") %>%   ### label line as national standard at level 12
        mjs_add_legend(legend="X") -> mjs_brief_1   ### assign name to plot

mrgdf %>%
        mjs_plot(x=state,                           ### assign the variable state to the x-axis
                 y=yr2012,                          ### assign the variable yr1999 to the y-axis
                 width=800,                         ### set the width of the plot to 800 pixels
                 height=250,                        ### set the height of the plot to 250 pixels
                 linked=TRUE) %>%                   ### link the two plots
        mjs_point(color_accessor=diff2,             ### create a line plot, assign color to variable diff2
                  size_accessor=diff,               ### assign size to variable diff
                  size_range = c(1, 3),
                  color_type="category",            ### assign a discrete variable to color
                  color_range = c("blue",           ### assign color blue for a decrease in pm2.5 levels
                                  "red",            ### assign color red for an increase in pm2.5 levels
                                  "grey")) %>%      ### assign color grey when there's no change in pm2.5 levels
        mjs_axis_x(xax_count = 56,                  ### create 56 ticks on the x-axis
                   min_x = 0,                       ### minimum tick value is 0
                   max_x = 56) %>%                  ### maximum tick value is 56
        mjs_axis_y(min_y = 2,
                   max_y = 20,
                   yax_count = 10) %>%
        mjs_labs(x="state",                         ### label x-axis as state
                 y="PM2.5 Emissions (??g/m3)") %>%  ### label y-axis as PM2.5
        mjs_add_baseline(12,                        ### add horizontal line at 12
                        "National Standard") %>%    ### label line as national standard 
        mjs_add_legend(legend="X") -> mjs_brief_2   ### assign variable name to plot

div(style="margin:auto;text-align:center",          ### align text to center
    strong("PM 2.5 levels, by State - 1999"), br(), mjs_brief_1,   ### set first text to bold
    strong("PM 2.5 levels, by State - 2012"), br(), mjs_brief_2)   ### set second text to bold
```

<!--html_preserve--><div style="margin:auto;text-align:center">
<strong>PM 2.5 levels, by State - 1999</strong>
<br/>
<div id="mjs-354f31582906d5332681caace3b073" class="metricsgraphics html-widget" style="width:800px;height:250px;"></div>
<div id="mjs-354f31582906d5332681caace3b073-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-354f31582906d5332681caace3b073">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"state":["1","10","11","12","13","15","16","17","18","19","2","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","4","40","41","42","44","45","46","47","48","49","5","50","51","53","54","55","56","6","72","8","9"],"yr1999":[20,14,16,11,20,5,9,17,16,12,7,12,16,14,10,16,12,14,10,16,14,9,9,9,12,14,7,12,16,8,18,11,11,9,14,11,15,10,17,12,9,16,10,14,10,17,13,7,18,9,8,13],"yr2012":[10,11,12,8,11,9,9,11,11,10,5,8,11,12,7,10,9,9,8,11,10,7,9,7,6,8,8,9,10,7,12,9,11,7,11,7,9,6,12,11,6,11,7,9,6,10,8,4,9,6,4,8],"diff":[-10,-3,-4,-3,-9,4,0,-6,-5,-2,-2,-4,-5,-2,-3,-6,-3,-5,-2,-5,-4,-2,0,-2,-6,-6,1,-3,-6,-1,-6,-2,0,-2,-3,-4,-6,-4,-5,-1,-3,-5,-3,-5,-4,-7,-5,-3,-9,-3,-4,-5],"diff2":["decreased","decreased","decreased","decreased","decreased","increased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","increased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased"]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"point","xax_format":"plain","x_label":"state","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":10,"xax_count":56,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":null,"color_accessor":null,"color_type":"number","color_range":["blue","red"],"size_range":[1,5],"bar_height":20,"min_x":0,"max_x":56,"min_y":2,"max_y":20,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"state","y_accessor":"yr1999","multi_line":null,"geom":"point","yax_units":"","legend":"X","legend_target":"#mjs-354f31582906d5332681caace3b073-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-354f31582906d5332681caace3b073"},"evals":[],"jsHooks":[]}</script>
<strong>PM 2.5 levels, by State - 2012</strong>
<br/>
<div id="mjs-b49d95c2031ebb34aaddc787f1946f" class="metricsgraphics html-widget" style="width:800px;height:250px;"></div>
<div id="mjs-b49d95c2031ebb34aaddc787f1946f-legend" class="metricsgraphics html-widget-legend"></div>
<script type="application/json" data-for="mjs-b49d95c2031ebb34aaddc787f1946f">{"x":{"forCSS":null,"regions":null,"orig_posix":false,"data":{"state":["1","10","11","12","13","15","16","17","18","19","2","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","4","40","41","42","44","45","46","47","48","49","5","50","51","53","54","55","56","6","72","8","9"],"yr1999":[20,14,16,11,20,5,9,17,16,12,7,12,16,14,10,16,12,14,10,16,14,9,9,9,12,14,7,12,16,8,18,11,11,9,14,11,15,10,17,12,9,16,10,14,10,17,13,7,18,9,8,13],"yr2012":[10,11,12,8,11,9,9,11,11,10,5,8,11,12,7,10,9,9,8,11,10,7,9,7,6,8,8,9,10,7,12,9,11,7,11,7,9,6,12,11,6,11,7,9,6,10,8,4,9,6,4,8],"diff":[-10,-3,-4,-3,-9,4,0,-6,-5,-2,-2,-4,-5,-2,-3,-6,-3,-5,-2,-5,-4,-2,0,-2,-6,-6,1,-3,-6,-1,-6,-2,0,-2,-3,-4,-6,-4,-5,-1,-3,-5,-3,-5,-4,-7,-5,-3,-9,-3,-4,-5],"diff2":["decreased","decreased","decreased","decreased","decreased","increased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","increased","decreased","decreased","decreased","decreased","decreased","no_change","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased","decreased"]},"x_axis":true,"y_axis":true,"baseline_accessor":null,"predictor_accessor":null,"show_confidence_band":null,"chart_type":"point","xax_format":"plain","x_label":"state","y_label":"PM2.5 Emissions (??g/m3)","markers":null,"baselines":[{"value":12,"label":"National Standard"}],"linked":true,"title":null,"description":null,"left":80,"right":10,"bottom":60,"buffer":8,"format":"count","y_scale_type":"linear","yax_count":10,"xax_count":56,"x_rug":false,"y_rug":false,"area":false,"missing_is_hidden":false,"size_accessor":"diff","color_accessor":"diff2","color_type":"category","color_range":["blue","red","grey"],"size_range":[1,3],"bar_height":20,"min_x":0,"max_x":56,"min_y":2,"max_y":20,"bar_margin":1,"binned":false,"bins":null,"least_squares":false,"interpolate":"cardinal","decimals":2,"show_rollover_text":true,"x_accessor":"state","y_accessor":"yr2012","multi_line":null,"geom":"point","yax_units":"","legend":"X","legend_target":"#mjs-b49d95c2031ebb34aaddc787f1946f-legend","y_extended_ticks":false,"x_extended_ticks":false,"target":"#mjs-b49d95c2031ebb34aaddc787f1946f"},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

The size of the dot reflects the magnitude of the change in PM 2.5 levels while the color reflects whether there was a change in PM 2.5 levels. Red for increase, grey for no change, and blue for decrease. The line provides a reference for the national standard equivalent to 12. 

| No. |State       | No. |State        | No. |State        | No. |State        |
|:----|:-----------|:----|:------------|:----|:------------|:----|:------------|
|`1`  |Alabama     |`17` |Illinois     |`30` |Montana      |`44` |Rhode island |
|`2`  |Alaska      |`18` |Indiana      |`31` |Nebraska     |`45` |S Carolina   |
|`4`  |Arizona     |`19` |Iowa         |`32` |Nevada       |`46` |South Dakota |
|`5`  |Arkansas    |`20` |Kansas       |`33` |New Hampshire|`47` |Tennessee    |
|`6`  |California  |`21` |Kentucky     |`34` |New jersey   |`48` |Texas        |
|`8`  |Colorado    |`22` |Louisiana    |`35` |New Mexico   |`49` |Utah         |
|`9`  |Connecticut |`23` |Maine        |`36` |New York     |`50` |Vermont      |
|`10` |Delaware    |`24` |Maryland     |`37` |N Carolina   |`51` |Virginia     |
|`11` |D Columbia  |`25` |Massachusetts|`38` |North Dakota |`53` |Washington   |
|`12` |Florida     |`26` |Michigan     |`39` |Ohio         |`54` |West virginia|
|`13` |Georgia     |`27` |Minnesota    |`40` |Oklahoma     |`55` |Wisconsin    |
|`15` |Hawaii      |`28` |Mississippi  |`41` |Oregon       |`56` |Wyoming      |
|`16` |Idaho       |`29` |Missouri     |`42` |Pennsylvania |     |             |

*NOTE*: There are no entries for the following numerical codes: 3, 7, 14, 43, and 52.


```r
library(knitr)
include_graphics("us-climate-regions_0.gif")
```

<img src="us-climate-regions_0.gif" style="display: block; margin: auto;" />

Image of the map of the USA was downloaded from the [U.S. Environmental Protection Agency](https://www.epa.gov/)

<br>

Thanks to Roger Peng, Bob Rudis, and Coursera for inspiring this project. I had a lot of fun and learning while doing it.

Many thank also to the [U.S. Environmental Protection Agency](https://www.epa.gov/) for providing the data to the public.

<br>

#### References

- [Introduction to metricsgraphics](http://cran.r-project.org/web/packages/metricsgraphics/vignettes/introductiontometricsgraphics.html)

Bob Rudis

- Exploratory Graphs
- Decreases in Fine Particle Air Pollution Between 1999 and 2012

Roger D. Peng, Associate Professor of Biostatistics
Johns Hopkins Bloomberg School of Public Health

- Exploratory Data Analysis Course from Coursera

 
