# Predicting Movement
DocOfi  
October 16, 2015  




### Synopsis
The predominant approach to preventing injuries currently is to provide athletes with feedback from a professional trainer during the execution of certain movement. The objective of this work is to classify errors during the execution of movement based on data obtained from motion traces recorded using on-body sensors.  We will be using regression models as our tool to specify correct or incorrect execution and the type of error committed.

### Introduction 
Six male participants aged between 20-28 years, were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl using a 1.25 dumbbell in ???ve di???erent fashions: exactly according to the speci???ed execution of the exercise (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E).  Mounted sensors in the users' glove, armband, lumbar belt and dumbbell collected data  on the Euler angles (roll, pitch and yaw), as well as the raw accelerometer, gyroscope and magnetometer readings.  More information is available from the website [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har).

### Data and information Source
The data for this project come from this source: [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har).

The training data for this project are available here: [https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv) 

The test data are available here:
[https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv)

##Data Processing

### Downloading the Data

```r
training_url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testing_url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(training_url, destfile = ".training.csv")
download.file(testing_url, destfile = ".testing.csv")
dateDownloaded <- date()
dateDownloaded
```

```
## [1] "Mon Mar 14 12:00:11 2016"
```

### Reading and Processing the data 

```r
library(caret)
library(ggplot2)
training <- read.csv(".training.csv", header = TRUE, na.strings = c("NA", "#DIV/0!", ""), stringsAsFactors = FALSE)
testing <- read.csv(".testing.csv", header = TRUE, na.strings = c("NA", "#DIV/0!", ""), stringsAsFactors = FALSE)
sumVar_index <- grepl("^min|^max|^kurtosis|^skewness|^avg|^var|^stddev|^amplitude|^total", names(training))
sumVar <- names(training)[sumVar_index]
my_df <- training[, c(sumVar, "classe")]
all_na_index <- sapply(my_df, function(x)sum(is.na(x)))
all_na <- which(all_na_index == 19622)
my_df2 <- my_df[, -all_na]
my_df3 <- my_df2[complete.cases(my_df2), ]
```





