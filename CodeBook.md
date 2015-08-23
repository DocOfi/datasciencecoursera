---
title       : CodeBook.md
subtitle    : 
author      : DocOfi [www.projectoralhealth.org](www.projectoralhealth.org)
job         : Project Oral Health for Juvenile Diabetics
            
output: 
  html_document: 
    keep_md: yes
    toc: yes
---


This CodeBook.md contains the processes taken from downloading the datasets up to final output of a tidied data for data processing. 

## Introduction
This programming assignment is part of the Coursera course Getting and Cleaning Data.  The goal of the assignment is to demonstrate the students ability to collect, work with, and clean a data set for later analysis. The datasets were obtained through the following link: 

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/) . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data used in this course represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

---

### zip file content
The following files were contained in the downloaded zip file:
```
> dateDownloaded
[1] "Thu Aug 06 22:15:21 2015"
```
* 'README.txt': shows description of the experiment and the different files in the zip file

* 'features_info.txt': Shows information about the variables used on the feature vector.

* 'features.txt': List of all features.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'train/X_train.txt': data from the Training set.

* 'train/y_train.txt': Training labels.

* 'test/X_test.txt': data from the Test set.

* 'test/y_test.txt': Test labels.

### Study Design

Abstract:
Human Activity Recognition database built from the recordings of 30 subjects performing basic activities and postural transitions while carrying a waist-mounted smartphone with embedded inertial sensors.
- Data Set Characteristics: Multivariate, Time-Series
- Number of Instances: 10929
- Number of Attributes: 561
- Number of Classes: 12
- Associated Tasks: Classification, Clustering
- Missing Values: None

Dataset Information:
The experiments was carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

---


### reading the data into R

The files were read into R Studio using read.table() with the default settings and the following files from the train datasets and test datasets were merged.

---

## Putting the data together

### subject participants - combined_subject
A total of 30 subjects participated in the experiment.  Their identifying IDs were encoded in this dataset. The variable name "subject" was assigned to this column of the data frame.
```
> subject_test <- read.table("test/subject_test.txt")

> subject_train <- read.table("train/subject_train.txt")

> combined_subject <- rbind(subject_train, subject_test)

> colnames(combined_subject) <- "subject"
```
### activity performed by the subject participants - combined_activity_labels
The action performed by the participants were referenced by an ID number from 1 to 6 and the variable name "activity" was assigned to the column in this data frame.
```
> y_test <- read.table("test/y_test.txt")

> y_train <- read.table("train/y_train.txt")
.
> combined_activity <- rbind(y_train, y_test)

> colnames(combined_activity) <- "activity"
```
### variables measured - rbind_df
The variables measured in this experiment were contained in these files.  There were 561 variables measured in this experiment with time and frequency domain variables(prefix 't' to denote time and 'f' to indicate frequency domain signals).

The variables measured for this database came from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.  the acceleration signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ)

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ

- tGravityAcc-XYZ

- tBodyAccJerk-XYZ

- tBodyGyro-XYZ

- tBodyGyroJerk-XYZ

- tBodyAccMag

- tGravityAccMag

- tBodyAccJerkMag

- tBodyGyroMag

- tBodyGyroJerkMag

- fBodyAcc-XYZ

- fBodyAccJerk-XYZ

- fBodyGyro-XYZ

- fBodyAccMag

- fBodyAccJerkMag

- fBodyGyroMag

- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean(): Mean value

- std(): Standard deviation

- mad(): Median absolute deviation

- max(): Largest value in array

- min(): Smallest value in array

- sma(): Signal magnitude area

- energy(): Energy measure. Sum of the squares divided by the number of values. 

- iqr(): Interquartile range

- entropy(): Signal entropy

- arCoeff(): Autorregresion coefficients with Burg order equal to 4

- correlation(): correlation coefficient between two signals

- maxInds(): index of the frequency component with largest magnitude

- meanFreq(): Weighted average of the frequency components to obtain a mean frequency

- skewness(): skewness of the frequency domain signal

- kurtosis(): kurtosis of the frequency domain signal

- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.

- angle(): Angle between two vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

```    
> x_train <- read.table("train/X_train.txt")   
    
> x_test <- read.table("test/X_test.txt")   

> combined_variables <- rbind(x_train, x_test)

> variable_names <- read.table("features.txt")

> colnames(combined_variables) <- as.character(variable_names$V2)
```
### decoding the activity ID numbers 
The activity ID numbers corresponded to the following actions and are contained in the activity_labels.txt file.

-      1 =  Walking
-      2 =  Walking upstairs
-      3 =  Walking downstairs
-      4 =  Sitting
-      5 =  Standing
-      6 =  Laying

The activity ID numbers in the combined_activity_labels data frame were replaced with their corresponding activity labels.

```
> combined_activity[,1] <-gsub("1", "walking", combined_activity[,1])

> combined_activity[,1] <-gsub("2", "walking_upstairs", combined_activity[,1])

> combined_activity[,1] <-gsub("3", "walking_downstairs", combined_activity[,1])

> combined_activity[,1] <-gsub("4", "sitting", combined_activity[,1])

> combined_activity[,1] <-gsub("5", "standing", combined_activity[,1])

> combined_activity[,1] <-gsub("6", "laying", combined_activity[,1])
```
A summary of the activity ID numbers and the activity labels before and after the replacement was performed to ensure no error occurred during the replacement.

```
> factor_combined_activity <- combined_activity[,1]
> factor_combined_activity <- as.factor(combined_activity[,1])
> summary(factor_combined_activity)
            laying            sitting           standing            walking 
              1944               1777               1906               1722 
walking_downstairs   walking_upstairs 
              1406               1544 
```

```
> former_combined_activity <- rbind(y_train, y_test)
> factor_former_combined_activity <- as.factor(former_combined_activity[,1])
> summary(factor_former_combined_activity)
   1    2    3    4    5    6 
1722 1544 1406 1777 1906 1944 
```
### merging the subject and activity variables with the rest of the variables of the experiment
```
> temp_df <- cbind(combined_activity, combined_variables)
> complete_df <- cbind(combined_subject, temp_df)
```

### selecting the mean and standard deviation variables we need 
Visual inspection of the column names and the use of the grep function delivered the mean and standard deviation variables that we need.  
```
> mean_sd_columns <- variable_names$V2[grep("mean\\(\\)|std\\(\\)", variable_names$V2)]
> selected_variables <- c("subject", "activity", as.character(mean_sd_columns))
> selected_df <- subset(complete_df, select = selected_variables)
```
### renaming the column names with descriptive variable names
```
"t" is replaced by "time"
> names(selected_df) <-gsub("^t", "time", names(selected_df))

"f" is teplaced by "frequency"
> names(selected_df) <-gsub("^f", "frequency", names(selected_df))

"BodyAcc" is replaced by "BodyAcceleration"
> names(selected_df) <-gsub("BodyAcc", "BodyAcceleration", names(selected_df))

"Mag" is replaced by "Magnitude"
> names(selected_df) <-gsub("Mag", "Magnitude", names(selected_df)) 

"Gyro" is replaced by "Gyroscope"
> names(selected_df) <-gsub("Gyro", "Gyroscope", names(selected_df))

"GravityAcc" is replaced by "GravityAcceleration"
> names(selected_df) <-gsub("GravityAcc", "GravityAcceleration", names(selected_df))
```
## The tidied data
selected_df

```
> dim(selected_df)
[1] 10299    68
> head(selected_df, n=3)
   subject activity timeBodyAcceleration-mean()-X timeBodyAcceleration-mean()-Y
1:       1 standing                     0.2885845                   -0.02029417
2:       1 standing                     0.2784188                   -0.01641057
3:       1 standing                     0.2796531                   -0.01946716
   timeBodyAcceleration-mean()-Z timeBodyAcceleration-std()-X timeBodyAcceleration-std()-Y
1:                    -0.1329051                   -0.9952786                   -0.9831106
2:                    -0.1235202                   -0.9982453                   -0.9753002
3:                    -0.1134617                   -0.9953796                   -0.9671870
   timeBodyAcceleration-std()-Z timeGravityAcceleration-mean()-X
1:                   -0.9135264                        0.9633961
2:                   -0.9603220                        0.9665611
3:                   -0.9789440                        0.9668781
   timeGravityAcceleration-mean()-Y timeGravityAcceleration-mean()-Z
1:                       -0.1408397                        0.1153749
2:                       -0.1415513                        0.1093788
3:                       -0.1420098                        0.1018839
   timeGravityAcceleration-std()-X timeGravityAcceleration-std()-Y
1:                      -0.9852497                      -0.9817084
2:                      -0.9974113                      -0.9894474
3:                      -0.9995740                      -0.9928658
   timeGravityAcceleration-std()-Z timeBodyAccelerationJerk-mean()-X
1:                      -0.8776250                        0.07799634
2:                      -0.9316387                        0.07400671
3:                      -0.9929172                        0.07363596
   timeBodyAccelerationJerk-mean()-Y timeBodyAccelerationJerk-mean()-Z
1:                       0.005000803                      -0.067830808
2:                       0.005771104                       0.029376633
3:                       0.003104037                      -0.009045631
   timeBodyAccelerationJerk-std()-X timeBodyAccelerationJerk-std()-Y
1:                       -0.9935191                       -0.9883600
2:                       -0.9955481                       -0.9810636
3:                       -0.9907428                       -0.9809556
   timeBodyAccelerationJerk-std()-Z timeBodyGyroscope-mean()-X timeBodyGyroscope-mean()-Y
1:                       -0.9935750               -0.006100849                -0.03136479
2:                       -0.9918457               -0.016111620                -0.08389378
3:                       -0.9896866               -0.031698294                -0.10233542
   timeBodyGyroscope-mean()-Z timeBodyGyroscope-std()-X timeBodyGyroscope-std()-Y
1:                 0.10772540                -0.9853103                -0.9766234
2:                 0.10058429                -0.9831200                -0.9890458
3:                 0.09612688                -0.9762921                -0.9935518
   timeBodyGyroscope-std()-Z timeBodyGyroscopeJerk-mean()-X timeBodyGyroscopeJerk-mean()-Y
1:                -0.9922053                     -0.0991674                    -0.05551737
2:                -0.9891212                     -0.1105028                    -0.04481873
3:                -0.9863787                     -0.1084857                    -0.04241031
   timeBodyGyroscopeJerk-mean()-Z timeBodyGyroscopeJerk-std()-X timeBodyGyroscopeJerk-std()-Y
1:                    -0.06198580                    -0.9921107                    -0.9925193
2:                    -0.05924282                    -0.9898726                    -0.9972926
3:                    -0.05582883                    -0.9884618                    -0.9956321
   timeBodyGyroscopeJerk-std()-Z timeBodyAccelerationMagnitude-mean()
1:                    -0.9920553                           -0.9594339
2:                    -0.9938510                           -0.9792892
3:                    -0.9915318                           -0.9837031
   timeBodyAccelerationMagnitude-std() timeGravityAccelerationMagnitude-mean()
1:                          -0.9505515                              -0.9594339
2:                          -0.9760571                              -0.9792892
3:                          -0.9880196                              -0.9837031
   timeGravityAccelerationMagnitude-std() timeBodyAccelerationJerkMagnitude-mean()
1:                             -0.9505515                               -0.9933059
2:                             -0.9760571                               -0.9912535
3:                             -0.9880196                               -0.9885313
   timeBodyAccelerationJerkMagnitude-std() timeBodyGyroscopeMagnitude-mean()
1:                              -0.9943364                        -0.9689591
2:                              -0.9916944                        -0.9806831
3:                              -0.9903969                        -0.9763171
   timeBodyGyroscopeMagnitude-std() timeBodyGyroscopeJerkMagnitude-mean()
1:                       -0.9643352                            -0.9942478
2:                       -0.9837542                            -0.9951232
3:                       -0.9860515                            -0.9934032
   timeBodyGyroscopeJerkMagnitude-std() frequencyBodyAcceleration-mean()-X
1:                           -0.9913676                         -0.9947832
2:                           -0.9961016                         -0.9974507
3:                           -0.9950910                         -0.9935941
   frequencyBodyAcceleration-mean()-Y frequencyBodyAcceleration-mean()-Z
1:                         -0.9829841                         -0.9392687
2:                         -0.9768517                         -0.9735227
3:                         -0.9725115                         -0.9833040
   frequencyBodyAcceleration-std()-X frequencyBodyAcceleration-std()-Y
1:                        -0.9954217                        -0.9831330
2:                        -0.9986803                        -0.9749298
3:                        -0.9963128                        -0.9655059
   frequencyBodyAcceleration-std()-Z frequencyBodyAccelerationJerk-mean()-X
1:                        -0.9061650                             -0.9923325
2:                        -0.9554381                             -0.9950322
3:                        -0.9770493                             -0.9909937
   frequencyBodyAccelerationJerk-mean()-Y frequencyBodyAccelerationJerk-mean()-Z
1:                             -0.9871699                             -0.9896961
2:                             -0.9813115                             -0.9897398
3:                             -0.9816423                             -0.9875663
   frequencyBodyAccelerationJerk-std()-X frequencyBodyAccelerationJerk-std()-Y
1:                            -0.9958207                            -0.9909363
2:                            -0.9966523                            -0.9820839
3:                            -0.9912488                            -0.9814148
   frequencyBodyAccelerationJerk-std()-Z frequencyBodyGyroscope-mean()-X
1:                            -0.9970517                      -0.9865744
2:                            -0.9926268                      -0.9773867
3:                            -0.9904159                      -0.9754332
   frequencyBodyGyroscope-mean()-Y frequencyBodyGyroscope-mean()-Z
1:                      -0.9817615                      -0.9895148
2:                      -0.9925300                      -0.9896058
3:                      -0.9937147                      -0.9867557
   frequencyBodyGyroscope-std()-X frequencyBodyGyroscope-std()-Y
1:                     -0.9850326                     -0.9738861
2:                     -0.9849043                     -0.9871681
3:                     -0.9766422                     -0.9933990
   frequencyBodyGyroscope-std()-Z frequencyBodyAccelerationMagnitude-mean()
1:                     -0.9940349                                -0.9521547
2:                     -0.9897847                                -0.9808566
3:                     -0.9873282                                -0.9877948
   frequencyBodyAccelerationMagnitude-std() frequencyBodyBodyAccelerationJerkMagnitude-mean()
1:                               -0.9561340                                        -0.9937257
2:                               -0.9758658                                        -0.9903355
3:                               -0.9890155                                        -0.9892801
   frequencyBodyBodyAccelerationJerkMagnitude-std() frequencyBodyBodyGyroscopeMagnitude-mean()
1:                                       -0.9937550                                 -0.9801349
2:                                       -0.9919603                                 -0.9882956
3:                                       -0.9908667                                 -0.9892548
   frequencyBodyBodyGyroscopeMagnitude-std() frequencyBodyBodyGyroscopeJerkMagnitude-mean()
1:                                -0.9613094                                     -0.9919904
2:                                -0.9833219                                     -0.9958539
3:                                -0.9860277                                     -0.9950305
   frequencyBodyBodyGyroscopeJerkMagnitude-std()
1:                                    -0.9906975
2:                                    -0.9963995
3:                                    -0.9951274
```

## Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

```

> tidy_data <- aggregate(.~subject - activity, selected_df, mean)
> dim(selected_df)
[1] 10299    68
> dim(tidy_data)
[1] 180  68

### creating the CodeBook.md

```r
library(knitr)
knit2html("CodeBook.md")

```
