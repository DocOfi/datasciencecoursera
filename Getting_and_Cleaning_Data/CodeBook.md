# CodeBook.md
DocOfi [www.projectoralhealth.org](www.projectoralhealth.org)  


This CodeBook.md contains the processes taken from downloading the datasets up to final output of a tidied data for data processing. 

## Introduction
This programming assignment is part of the Coursera course Getting and Cleaning Data.  The goal of the assignment is to demonstrate the students ability to collect, work with, and clean a data set for later analysis. The datasets were obtained through the following link: 

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/) . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data used in this course represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

---

### zip file content
The following files were contained in the downloaded zip file:

```r
setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
fileUrl <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl,destfile="./UCI_HAR.zip")
datedownloaded <- date()
datedownloaded
```

```
## [1] "Wed Dec 23 01:38:12 2015"
```

```r
file <- "UCI_HAR.zip"
unzip(file)
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


```r
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
combined_subject <- rbind(subject_train, subject_test)
colnames(combined_subject) <- "Subject"
```

### activity performed by the subject participants - combined_activity_labels
The action performed by the participants were referenced by an ID number from 1 to 6 and the variable name "activity" was assigned to the column in this data frame.


```r
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
combined_activity <- rbind(y_train, y_test)
colnames(combined_activity) <- "Activity"
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


```r
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
combined_variables <- rbind(x_train, x_test)
variable_names <- read.table("UCI HAR Dataset/features.txt")
colnames(combined_variables) <- as.character(variable_names$V2)
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


```r
combined_activity[,1] <-gsub("1","walking", combined_activity[,1])
combined_activity[,1] <-gsub("2","walking_upstairs", combined_activity[,1])
combined_activity[,1] <-gsub("3", "walking_downstairs", combined_activity[,1])
combined_activity[,1] <-gsub("4","sitting", combined_activity[,1])
combined_activity[,1] <-gsub("5","standing", combined_activity[,1])
combined_activity[,1] <-gsub("6","laying", combined_activity[,1])
```

A summary of the activity ID numbers and the activity labels before and after the replacement was performed to ensure no error occurred during the replacement.


```r
walking <- length(which(rbind(y_train, y_test) == 1))
walking
```

```
## [1] 1722
```

```r
walking_upstairs <- length(which(rbind(y_train, y_test) == 2))
walking_upstairs
```

```
## [1] 1544
```

```r
walking_downstairs <- length(which(rbind(y_train, y_test) == 3))
walking_downstairs
```

```
## [1] 1406
```

```r
sitting <- length(which(rbind(y_train, y_test) == 4))
sitting
```

```
## [1] 1777
```

```r
standing <- length(which(rbind(y_train, y_test) == 5))
standing
```

```
## [1] 1906
```

```r
laying <- length(which(rbind(y_train, y_test) == 6))
laying
```

```
## [1] 1944
```

```r
summary(as.factor(combined_activity[,1]))
```

```
##             laying            sitting           standing 
##               1944               1777               1906 
##            walking walking_downstairs   walking_upstairs 
##               1722               1406               1544
```

### merging the subject and activity variables with the rest of the variables of the experiment


```r
temp_df <- cbind(combined_activity, combined_variables)
complete_df <- cbind(combined_subject, temp_df)
```

### selecting the mean and standard deviation variables we need 
Visual inspection of the column names and the use of the grep function delivered the mean and standard deviation variables that we need. 


```r
mean_std_columns <- variable_names$V2[grep("mean\\(\\)|std\\(\\)", variable_names$V2)]
variables_needed <- c("Subject", "Activity", as.character(mean_std_columns))
selected_df <- subset(complete_df, select = variables_needed)
```

### renaming the column names with descriptive variable names


```r
names(selected_df) <-gsub("^t", "time", names(selected_df))
names(selected_df) <-gsub("^f", "frequency", names(selected_df))
names(selected_df) <-gsub("BodyAcc", "BodyAcceleration", names(selected_df))
names(selected_df) <-gsub("Mag", "Magnitude", names(selected_df))
names(selected_df) <-gsub("Gyro", "Gyroscope", names(selected_df))
names(selected_df) <-gsub("GravityAcc", "GravityAcceleration", names(selected_df))
names(selected_df) <-gsub("\\(\\)", "", names(selected_df))
```

## The tidied data


```r
dim(selected_df)
```

```
## [1] 10299    68
```

```r
head(selected_df)
```

```
##   Subject Activity timeBodyAcceleration-mean-X timeBodyAcceleration-mean-Y
## 1       1 standing                   0.2885845                 -0.02029417
## 2       1 standing                   0.2784188                 -0.01641057
## 3       1 standing                   0.2796531                 -0.01946716
## 4       1 standing                   0.2791739                 -0.02620065
## 5       1 standing                   0.2766288                 -0.01656965
## 6       1 standing                   0.2771988                 -0.01009785
##   timeBodyAcceleration-mean-Z timeBodyAcceleration-std-X
## 1                  -0.1329051                 -0.9952786
## 2                  -0.1235202                 -0.9982453
## 3                  -0.1134617                 -0.9953796
## 4                  -0.1232826                 -0.9960915
## 5                  -0.1153619                 -0.9981386
## 6                  -0.1051373                 -0.9973350
##   timeBodyAcceleration-std-Y timeBodyAcceleration-std-Z
## 1                 -0.9831106                 -0.9135264
## 2                 -0.9753002                 -0.9603220
## 3                 -0.9671870                 -0.9789440
## 4                 -0.9834027                 -0.9906751
## 5                 -0.9808173                 -0.9904816
## 6                 -0.9904868                 -0.9954200
##   timeGravityAcceleration-mean-X timeGravityAcceleration-mean-Y
## 1                      0.9633961                     -0.1408397
## 2                      0.9665611                     -0.1415513
## 3                      0.9668781                     -0.1420098
## 4                      0.9676152                     -0.1439765
## 5                      0.9682244                     -0.1487502
## 6                      0.9679482                     -0.1482100
##   timeGravityAcceleration-mean-Z timeGravityAcceleration-std-X
## 1                     0.11537494                    -0.9852497
## 2                     0.10937881                    -0.9974113
## 3                     0.10188392                    -0.9995740
## 4                     0.09985014                    -0.9966456
## 5                     0.09448590                    -0.9984293
## 6                     0.09190972                    -0.9989793
##   timeGravityAcceleration-std-Y timeGravityAcceleration-std-Z
## 1                    -0.9817084                    -0.8776250
## 2                    -0.9894474                    -0.9316387
## 3                    -0.9928658                    -0.9929172
## 4                    -0.9813928                    -0.9784764
## 5                    -0.9880982                    -0.9787449
## 6                    -0.9867539                    -0.9973064
##   timeBodyAccelerationJerk-mean-X timeBodyAccelerationJerk-mean-Y
## 1                      0.07799634                     0.005000803
## 2                      0.07400671                     0.005771104
## 3                      0.07363596                     0.003104037
## 4                      0.07732061                     0.020057642
## 5                      0.07344436                     0.019121574
## 6                      0.07793244                     0.018684046
##   timeBodyAccelerationJerk-mean-Z timeBodyAccelerationJerk-std-X
## 1                    -0.067830808                     -0.9935191
## 2                     0.029376633                     -0.9955481
## 3                    -0.009045631                     -0.9907428
## 4                    -0.009864772                     -0.9926974
## 5                     0.016779979                     -0.9964202
## 6                     0.009344434                     -0.9948136
##   timeBodyAccelerationJerk-std-Y timeBodyAccelerationJerk-std-Z
## 1                     -0.9883600                     -0.9935750
## 2                     -0.9810636                     -0.9918457
## 3                     -0.9809556                     -0.9896866
## 4                     -0.9875527                     -0.9934976
## 5                     -0.9883587                     -0.9924549
## 6                     -0.9887145                     -0.9922663
##   timeBodyGyroscope-mean-X timeBodyGyroscope-mean-Y
## 1             -0.006100849              -0.03136479
## 2             -0.016111620              -0.08389378
## 3             -0.031698294              -0.10233542
## 4             -0.043409983              -0.09138618
## 5             -0.033960416              -0.07470803
## 6             -0.028775508              -0.07039311
##   timeBodyGyroscope-mean-Z timeBodyGyroscope-std-X timeBodyGyroscope-std-Y
## 1               0.10772540              -0.9853103              -0.9766234
## 2               0.10058429              -0.9831200              -0.9890458
## 3               0.09612688              -0.9762921              -0.9935518
## 4               0.08553770              -0.9913848              -0.9924073
## 5               0.07739203              -0.9851836              -0.9923781
## 6               0.07901214              -0.9851808              -0.9921175
##   timeBodyGyroscope-std-Z timeBodyGyroscopeJerk-mean-X
## 1              -0.9922053                  -0.09916740
## 2              -0.9891212                  -0.11050283
## 3              -0.9863787                  -0.10848567
## 4              -0.9875542                  -0.09116989
## 5              -0.9874019                  -0.09077010
## 6              -0.9830768                  -0.09424758
##   timeBodyGyroscopeJerk-mean-Y timeBodyGyroscopeJerk-mean-Z
## 1                  -0.05551737                  -0.06198580
## 2                  -0.04481873                  -0.05924282
## 3                  -0.04241031                  -0.05582883
## 4                  -0.03633262                  -0.06046466
## 5                  -0.03763253                  -0.05828932
## 6                  -0.04335526                  -0.04193600
##   timeBodyGyroscopeJerk-std-X timeBodyGyroscopeJerk-std-Y
## 1                  -0.9921107                  -0.9925193
## 2                  -0.9898726                  -0.9972926
## 3                  -0.9884618                  -0.9956321
## 4                  -0.9911194                  -0.9966410
## 5                  -0.9913545                  -0.9964730
## 6                  -0.9916216                  -0.9960147
##   timeBodyGyroscopeJerk-std-Z timeBodyAccelerationMagnitude-mean
## 1                  -0.9920553                         -0.9594339
## 2                  -0.9938510                         -0.9792892
## 3                  -0.9915318                         -0.9837031
## 4                  -0.9933289                         -0.9865418
## 5                  -0.9945110                         -0.9928271
## 6                  -0.9930906                         -0.9942950
##   timeBodyAccelerationMagnitude-std timeGravityAccelerationMagnitude-mean
## 1                        -0.9505515                            -0.9594339
## 2                        -0.9760571                            -0.9792892
## 3                        -0.9880196                            -0.9837031
## 4                        -0.9864213                            -0.9865418
## 5                        -0.9912754                            -0.9928271
## 6                        -0.9952490                            -0.9942950
##   timeGravityAccelerationMagnitude-std
## 1                           -0.9505515
## 2                           -0.9760571
## 3                           -0.9880196
## 4                           -0.9864213
## 5                           -0.9912754
## 6                           -0.9952490
##   timeBodyAccelerationJerkMagnitude-mean
## 1                             -0.9933059
## 2                             -0.9912535
## 3                             -0.9885313
## 4                             -0.9930780
## 5                             -0.9934800
## 6                             -0.9930177
##   timeBodyAccelerationJerkMagnitude-std timeBodyGyroscopeMagnitude-mean
## 1                            -0.9943364                      -0.9689591
## 2                            -0.9916944                      -0.9806831
## 3                            -0.9903969                      -0.9763171
## 4                            -0.9933808                      -0.9820599
## 5                            -0.9958537                      -0.9852037
## 6                            -0.9954243                      -0.9858944
##   timeBodyGyroscopeMagnitude-std timeBodyGyroscopeJerkMagnitude-mean
## 1                     -0.9643352                          -0.9942478
## 2                     -0.9837542                          -0.9951232
## 3                     -0.9860515                          -0.9934032
## 4                     -0.9873511                          -0.9955022
## 5                     -0.9890626                          -0.9958076
## 6                     -0.9864403                          -0.9952748
##   timeBodyGyroscopeJerkMagnitude-std frequencyBodyAcceleration-mean-X
## 1                         -0.9913676                       -0.9947832
## 2                         -0.9961016                       -0.9974507
## 3                         -0.9950910                       -0.9935941
## 4                         -0.9952666                       -0.9954906
## 5                         -0.9952580                       -0.9972859
## 6                         -0.9952050                       -0.9966567
##   frequencyBodyAcceleration-mean-Y frequencyBodyAcceleration-mean-Z
## 1                       -0.9829841                       -0.9392687
## 2                       -0.9768517                       -0.9735227
## 3                       -0.9725115                       -0.9833040
## 4                       -0.9835697                       -0.9910798
## 5                       -0.9823010                       -0.9883694
## 6                       -0.9869395                       -0.9927386
##   frequencyBodyAcceleration-std-X frequencyBodyAcceleration-std-Y
## 1                      -0.9954217                      -0.9831330
## 2                      -0.9986803                      -0.9749298
## 3                      -0.9963128                      -0.9655059
## 4                      -0.9963121                      -0.9832444
## 5                      -0.9986065                      -0.9801295
## 6                      -0.9976438                      -0.9922637
##   frequencyBodyAcceleration-std-Z frequencyBodyAccelerationJerk-mean-X
## 1                      -0.9061650                           -0.9923325
## 2                      -0.9554381                           -0.9950322
## 3                      -0.9770493                           -0.9909937
## 4                      -0.9902291                           -0.9944466
## 5                      -0.9919150                           -0.9962920
## 6                      -0.9970459                           -0.9948507
##   frequencyBodyAccelerationJerk-mean-Y
## 1                           -0.9871699
## 2                           -0.9813115
## 3                           -0.9816423
## 4                           -0.9887272
## 5                           -0.9887900
## 6                           -0.9882443
##   frequencyBodyAccelerationJerk-mean-Z frequencyBodyAccelerationJerk-std-X
## 1                           -0.9896961                          -0.9958207
## 2                           -0.9897398                          -0.9966523
## 3                           -0.9875663                          -0.9912488
## 4                           -0.9913542                          -0.9913783
## 5                           -0.9906244                          -0.9969025
## 6                           -0.9901575                          -0.9952180
##   frequencyBodyAccelerationJerk-std-Y frequencyBodyAccelerationJerk-std-Z
## 1                          -0.9909363                          -0.9970517
## 2                          -0.9820839                          -0.9926268
## 3                          -0.9814148                          -0.9904159
## 4                          -0.9869269                          -0.9943908
## 5                          -0.9886067                          -0.9929065
## 6                          -0.9901788                          -0.9930667
##   frequencyBodyGyroscope-mean-X frequencyBodyGyroscope-mean-Y
## 1                    -0.9865744                    -0.9817615
## 2                    -0.9773867                    -0.9925300
## 3                    -0.9754332                    -0.9937147
## 4                    -0.9871096                    -0.9936015
## 5                    -0.9824465                    -0.9929838
## 6                    -0.9848902                    -0.9927862
##   frequencyBodyGyroscope-mean-Z frequencyBodyGyroscope-std-X
## 1                    -0.9895148                   -0.9850326
## 2                    -0.9896058                   -0.9849043
## 3                    -0.9867557                   -0.9766422
## 4                    -0.9871913                   -0.9928104
## 5                    -0.9886664                   -0.9859818
## 6                    -0.9807784                   -0.9852871
##   frequencyBodyGyroscope-std-Y frequencyBodyGyroscope-std-Z
## 1                   -0.9738861                   -0.9940349
## 2                   -0.9871681                   -0.9897847
## 3                   -0.9933990                   -0.9873282
## 4                   -0.9916460                   -0.9886776
## 5                   -0.9919558                   -0.9879443
## 6                   -0.9916595                   -0.9853661
##   frequencyBodyAccelerationMagnitude-mean
## 1                              -0.9521547
## 2                              -0.9808566
## 3                              -0.9877948
## 4                              -0.9875187
## 5                              -0.9935909
## 6                              -0.9948360
##   frequencyBodyAccelerationMagnitude-std
## 1                             -0.9561340
## 2                             -0.9758658
## 3                             -0.9890155
## 4                             -0.9867420
## 5                             -0.9900635
## 6                             -0.9952833
##   frequencyBodyBodyAccelerationJerkMagnitude-mean
## 1                                      -0.9937257
## 2                                      -0.9903355
## 3                                      -0.9892801
## 4                                      -0.9927689
## 5                                      -0.9955228
## 6                                      -0.9947329
##   frequencyBodyBodyAccelerationJerkMagnitude-std
## 1                                     -0.9937550
## 2                                     -0.9919603
## 3                                     -0.9908667
## 4                                     -0.9916998
## 5                                     -0.9943890
## 6                                     -0.9951562
##   frequencyBodyBodyGyroscopeMagnitude-mean
## 1                               -0.9801349
## 2                               -0.9882956
## 3                               -0.9892548
## 4                               -0.9894128
## 5                               -0.9914330
## 6                               -0.9905000
##   frequencyBodyBodyGyroscopeMagnitude-std
## 1                              -0.9613094
## 2                              -0.9833219
## 3                              -0.9860277
## 4                              -0.9878358
## 5                              -0.9890594
## 6                              -0.9858609
##   frequencyBodyBodyGyroscopeJerkMagnitude-mean
## 1                                   -0.9919904
## 2                                   -0.9958539
## 3                                   -0.9950305
## 4                                   -0.9952207
## 5                                   -0.9950928
## 6                                   -0.9951433
##   frequencyBodyBodyGyroscopeJerkMagnitude-std
## 1                                  -0.9906975
## 2                                  -0.9963995
## 3                                  -0.9951274
## 4                                  -0.9952369
## 5                                  -0.9954648
## 6                                  -0.9952387
```

## Creating a second, independent tidy data set with the average of each variable for each activity and each subject.


```r
tidy_data <- aggregate(.~Subject - Activity, selected_df, mean)
head(tidy_data)
```

```
##   Subject Activity timeBodyAcceleration-mean-X timeBodyAcceleration-mean-Y
## 1       1   laying                   0.2215982                 -0.04051395
## 2       2   laying                   0.2813734                 -0.01815874
## 3       3   laying                   0.2755169                 -0.01895568
## 4       4   laying                   0.2635592                 -0.01500318
## 5       5   laying                   0.2783343                 -0.01830421
## 6       6   laying                   0.2486565                 -0.01025292
##   timeBodyAcceleration-mean-Z timeBodyAcceleration-std-X
## 1                  -0.1132036                 -0.9280565
## 2                  -0.1072456                 -0.9740595
## 3                  -0.1013005                 -0.9827766
## 4                  -0.1106882                 -0.9541937
## 5                  -0.1079376                 -0.9659345
## 6                  -0.1331196                 -0.9340494
##   timeBodyAcceleration-std-Y timeBodyAcceleration-std-Z
## 1                 -0.8368274                 -0.8260614
## 2                 -0.9802774                 -0.9842333
## 3                 -0.9620575                 -0.9636910
## 4                 -0.9417140                 -0.9626673
## 5                 -0.9692956                 -0.9685625
## 6                 -0.9246448                 -0.9252161
##   timeGravityAcceleration-mean-X timeGravityAcceleration-mean-Y
## 1                     -0.2488818                      0.7055498
## 2                     -0.5097542                      0.7525366
## 3                     -0.2417585                      0.8370321
## 4                     -0.4206647                      0.9151651
## 5                     -0.4834706                      0.9548903
## 6                     -0.4767099                      0.9565938
##   timeGravityAcceleration-mean-Z timeGravityAcceleration-std-X
## 1                      0.4458177                    -0.8968300
## 2                      0.6468349                    -0.9590144
## 3                      0.4887032                    -0.9825122
## 4                      0.3415313                    -0.9212000
## 5                      0.2636447                    -0.9456953
## 6                      0.1758677                    -0.8877463
##   timeGravityAcceleration-std-Y timeGravityAcceleration-std-Z
## 1                    -0.9077200                    -0.8523663
## 2                    -0.9882119                    -0.9842304
## 3                    -0.9812027                    -0.9648075
## 4                    -0.9698166                    -0.9761766
## 5                    -0.9859641                    -0.9770766
## 6                    -0.9591620                    -0.9281307
##   timeBodyAccelerationJerk-mean-X timeBodyAccelerationJerk-mean-Y
## 1                      0.08108653                     0.003838204
## 2                      0.08259725                     0.012254788
## 3                      0.07698111                     0.013804101
## 4                      0.09344942                     0.006933132
## 5                      0.08481648                     0.007474608
## 6                      0.09634820                    -0.001145292
##   timeBodyAccelerationJerk-mean-Z timeBodyAccelerationJerk-std-X
## 1                     0.010834236                     -0.9584821
## 2                    -0.001802649                     -0.9858722
## 3                    -0.004356259                     -0.9808793
## 4                    -0.006410543                     -0.9783028
## 5                    -0.003040672                     -0.9833079
## 6                     0.003288173                     -0.9663411
##   timeBodyAccelerationJerk-std-Y timeBodyAccelerationJerk-std-Z
## 1                     -0.9241493                     -0.9548551
## 2                     -0.9831725                     -0.9884420
## 3                     -0.9687107                     -0.9820932
## 4                     -0.9422095                     -0.9785120
## 5                     -0.9645604                     -0.9854194
## 6                     -0.9336745                     -0.9596461
##   timeBodyGyroscope-mean-X timeBodyGyroscope-mean-Y
## 1             -0.016553094              -0.06448612
## 2             -0.018476607              -0.11180082
## 3             -0.020817054              -0.07185072
## 4             -0.009231563              -0.09301282
## 5             -0.021893501              -0.07987096
## 6             -0.007960503              -0.10721832
##   timeBodyGyroscope-mean-Z timeBodyGyroscope-std-X timeBodyGyroscope-std-Y
## 1                0.1486894              -0.8735439              -0.9510904
## 2                0.1448828              -0.9882752              -0.9822916
## 3                0.1379996              -0.9745458              -0.9772727
## 4                0.1697204              -0.9731024              -0.9611093
## 5                0.1598944              -0.9794987              -0.9774274
## 6                0.1791021              -0.9553782              -0.9436349
##   timeBodyGyroscope-std-Z timeBodyGyroscopeJerk-mean-X
## 1              -0.9082847                   -0.1072709
## 2              -0.9603066                   -0.1019741
## 3              -0.9635056                   -0.1000445
## 4              -0.9620738                   -0.1050199
## 5              -0.9605838                   -0.1021141
## 6              -0.9391419                   -0.1112673
##   timeBodyGyroscopeJerk-mean-Y timeBodyGyroscopeJerk-mean-Z
## 1                  -0.04151729                  -0.07405012
## 2                  -0.03585902                  -0.07017830
## 3                  -0.03897718                  -0.06873387
## 4                  -0.03812304                  -0.07121563
## 5                  -0.04044469                  -0.07083097
## 6                  -0.04241043                  -0.07177747
##   timeBodyGyroscopeJerk-std-X timeBodyGyroscopeJerk-std-Y
## 1                  -0.9186085                  -0.9679072
## 2                  -0.9932358                  -0.9895675
## 3                  -0.9803286                  -0.9867627
## 4                  -0.9751032                  -0.9868556
## 5                  -0.9834223                  -0.9837595
## 6                  -0.9396116                  -0.9586288
##   timeBodyGyroscopeJerk-std-Z timeBodyAccelerationMagnitude-mean
## 1                  -0.9577902                         -0.8419292
## 2                  -0.9880358                         -0.9774355
## 3                  -0.9833383                         -0.9727913
## 4                  -0.9839654                         -0.9545576
## 5                  -0.9896796                         -0.9667779
## 6                  -0.9595791                         -0.9188789
##   timeBodyAccelerationMagnitude-std timeGravityAccelerationMagnitude-mean
## 1                        -0.7951449                            -0.8419292
## 2                        -0.9728739                            -0.9774355
## 3                        -0.9642182                            -0.9727913
## 4                        -0.9312922                            -0.9545576
## 5                        -0.9586128                            -0.9667779
## 6                        -0.8973262                            -0.9188789
##   timeGravityAccelerationMagnitude-std
## 1                           -0.7951449
## 2                           -0.9728739
## 3                           -0.9642182
## 4                           -0.9312922
## 5                           -0.9586128
## 6                           -0.8973262
##   timeBodyAccelerationJerkMagnitude-mean
## 1                             -0.9543963
## 2                             -0.9877417
## 3                             -0.9794846
## 4                             -0.9700958
## 5                             -0.9801413
## 6                             -0.9547505
##   timeBodyAccelerationJerkMagnitude-std timeBodyGyroscopeMagnitude-mean
## 1                            -0.9282456                      -0.8747595
## 2                            -0.9855181                      -0.9500116
## 3                            -0.9761213                      -0.9515648
## 4                            -0.9607864                      -0.9302365
## 5                            -0.9774771                      -0.9469383
## 6                            -0.9503419                      -0.9089802
##   timeBodyGyroscopeMagnitude-std timeBodyGyroscopeJerkMagnitude-mean
## 1                     -0.8190102                          -0.9634610
## 2                     -0.9611641                          -0.9917671
## 3                     -0.9542751                          -0.9867136
## 4                     -0.9470318                          -0.9850685
## 5                     -0.9582879                          -0.9864194
## 6                     -0.9209145                          -0.9556457
##   timeBodyGyroscopeJerkMagnitude-std frequencyBodyAcceleration-mean-X
## 1                         -0.9358410                       -0.9390991
## 2                         -0.9897181                       -0.9767251
## 3                         -0.9831393                       -0.9806656
## 4                         -0.9826982                       -0.9588021
## 5                         -0.9837714                       -0.9687417
## 6                         -0.9531570                       -0.9391143
##   frequencyBodyAcceleration-mean-Y frequencyBodyAcceleration-mean-Z
## 1                       -0.8670652                       -0.8826669
## 2                       -0.9798009                       -0.9843810
## 3                       -0.9611700                       -0.9683321
## 4                       -0.9388834                       -0.9675043
## 5                       -0.9654195                       -0.9770077
## 6                       -0.9237068                       -0.9380449
##   frequencyBodyAcceleration-std-X frequencyBodyAcceleration-std-Y
## 1                      -0.9244374                      -0.8336256
## 2                      -0.9732465                      -0.9810251
## 3                      -0.9836911                      -0.9640946
## 4                      -0.9524649                      -0.9463810
## 5                      -0.9649539                      -0.9729092
## 6                      -0.9324629                      -0.9297112
##   frequencyBodyAcceleration-std-Z frequencyBodyAccelerationJerk-mean-X
## 1                      -0.8128916                           -0.9570739
## 2                      -0.9847922                           -0.9858136
## 3                      -0.9632791                           -0.9805132
## 4                      -0.9621545                           -0.9785425
## 5                      -0.9658822                           -0.9826897
## 6                      -0.9240047                           -0.9670724
##   frequencyBodyAccelerationJerk-mean-Y
## 1                           -0.9224626
## 2                           -0.9827683
## 3                           -0.9687521
## 4                           -0.9439700
## 5                           -0.9653286
## 6                           -0.9360434
##   frequencyBodyAccelerationJerk-mean-Z frequencyBodyAccelerationJerk-std-X
## 1                           -0.9480609                          -0.9641607
## 2                           -0.9861971                          -0.9872503
## 3                           -0.9791223                          -0.9831226
## 4                           -0.9753833                          -0.9800793
## 5                           -0.9832503                          -0.9856253
## 6                           -0.9544258                          -0.9686192
##   frequencyBodyAccelerationJerk-std-Y frequencyBodyAccelerationJerk-std-Z
## 1                          -0.9322179                          -0.9605870
## 2                          -0.9849874                          -0.9893454
## 3                          -0.9710440                          -0.9837119
## 4                          -0.9443669                          -0.9802612
## 5                          -0.9662426                          -0.9861356
## 6                          -0.9357175                          -0.9635675
##   frequencyBodyGyroscope-mean-X frequencyBodyGyroscope-mean-Y
## 1                    -0.8502492                    -0.9521915
## 2                    -0.9864311                    -0.9833216
## 3                    -0.9701673                    -0.9780997
## 4                    -0.9672037                    -0.9721878
## 5                    -0.9757975                    -0.9782496
## 6                    -0.9354398                    -0.9417715
##   frequencyBodyGyroscope-mean-Z frequencyBodyGyroscope-std-X
## 1                    -0.9093027                   -0.8822965
## 2                    -0.9626719                   -0.9888607
## 3                    -0.9623420                   -0.9759864
## 4                    -0.9614793                   -0.9750947
## 5                    -0.9632029                   -0.9807058
## 6                    -0.9326366                   -0.9621650
##   frequencyBodyGyroscope-std-Y frequencyBodyGyroscope-std-Z
## 1                   -0.9512320                   -0.9165825
## 2                   -0.9819106                   -0.9631742
## 3                   -0.9770325                   -0.9672569
## 4                   -0.9561825                   -0.9658075
## 5                   -0.9772578                   -0.9633057
## 6                   -0.9453651                   -0.9471368
##   frequencyBodyAccelerationMagnitude-mean
## 1                              -0.8617676
## 2                              -0.9751102
## 3                              -0.9655243
## 4                              -0.9393897
## 5                              -0.9622350
## 6                              -0.9123517
##   frequencyBodyAccelerationMagnitude-std
## 1                             -0.7983009
## 2                             -0.9751214
## 3                             -0.9683502
## 4                             -0.9371880
## 5                             -0.9625254
## 6                             -0.9053740
##   frequencyBodyBodyAccelerationJerkMagnitude-mean
## 1                                      -0.9333004
## 2                                      -0.9853741
## 3                                      -0.9759496
## 4                                      -0.9622871
## 5                                      -0.9773564
## 6                                      -0.9486555
##   frequencyBodyBodyAccelerationJerkMagnitude-std
## 1                                     -0.9218040
## 2                                     -0.9845685
## 3                                     -0.9753054
## 4                                     -0.9580371
## 5                                     -0.9763819
## 6                                     -0.9515527
##   frequencyBodyBodyGyroscopeMagnitude-mean
## 1                               -0.8621902
## 2                               -0.9721130
## 3                               -0.9645867
## 4                               -0.9615567
## 5                               -0.9682571
## 6                               -0.9301536
##   frequencyBodyBodyGyroscopeMagnitude-std
## 1                              -0.8243194
## 2                              -0.9610984
## 3                              -0.9554419
## 4                              -0.9471003
## 5                              -0.9592631
## 6                              -0.9286949
##   frequencyBodyBodyGyroscopeJerkMagnitude-mean
## 1                                   -0.9423669
## 2                                   -0.9902487
## 3                                   -0.9842783
## 4                                   -0.9836091
## 5                                   -0.9846180
## 6                                   -0.9536960
##   frequencyBodyBodyGyroscopeJerkMagnitude-std
## 1                                  -0.9326607
## 2                                  -0.9894927
## 3                                  -0.9825682
## 4                                  -0.9825436
## 5                                  -0.9834345
## 6                                  -0.9555047
```

### creating the tidy_data.txt


```r
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
```

### creating the CodeBook.md

```r
library(knitr)
knit2html("CodeBook.md")

```





