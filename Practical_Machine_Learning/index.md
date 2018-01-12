# Predicting Errors in Execution of Physical Exercises
DocOfi  
October 16, 2015  




### Synopsis
The predominant approach to preventing injuries currently is to provide athletes with  a professional trainer who provides real time feedback while observing the execution of certain exercises. The objective of this work is to determine whether it will be possible to classify errors during the execution of movement based on data obtained from motion traces recorded using on-body sensors.  We used regression as our tool to create predictive models on the HAR weight lifting exercises dataset. We   classified errors and correct execution of lifting barbells with high accuracy, sensitivity and specificity. 

### Introduction 
Six male participants aged between 20-28 years, were asked to perform one set of 10 repetitions of Unilateral Dumbbell Biceps Curl using a 1.25 dumbbell in different fashions: *exactly according to the specified execution of the exercise* (**Class A**), *throwing the elbows to the front* (**Class B**), *lifting the dumbbell only halfway* (**Class C**), *lowering the dumbbell only halfway* (**Class D**) and *throwing the hips to the front* (**Class E**).  Mounted sensors in the users' glove, armband, lumbar belt and dumbbell collected data  on the Euler angles (roll, pitch and yaw), as well as the raw accelerometer, gyroscope and magnetometer readings.  More information is available from the website [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har).

### Downloading the Data
The data for this project come from this source: [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har).


```r
training_url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testing_url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(training_url, destfile = "training.csv")
download.file(testing_url, destfile = "testing.csv")
dateDownloaded <- date()
dateDownloaded
```

```
## [1] "Fri Mar 25 13:04:48 2016"
```

### Reading and Processing the data 

```r
library(caret)
library(ggplot2)
training <- read.csv("training.csv", header = TRUE, na.strings = c("NA", "#DIV/0!", ""), stringsAsFactors = FALSE)
testing <- read.csv("testing.csv", header = TRUE, na.strings = c("NA", "#DIV/0!", ""), stringsAsFactors = FALSE)
sumVar_index <- grepl("^min|^max|^kurtosis|^skewness|^avg|^var|^stddev|^amplitude", names(training))###identifying summary variables
sumVar <- names(training)[!sumVar_index]
my_df <- training[, sumVar]### removing summary variables
all_na_index <- sapply(my_df, function(x)sum(is.na(x)))
my_df2 <- my_df[, -c(1:7)]### removing housekeeping variables
```

The features of the data may be classified into **measurement, summary, and housekeeping variables**.  The **summary variables** (beginning with: *min, max, kurtosis, skewness, avg, stddev, and amplitude*) apply summary statisitics on the **measurement variables** (beginning with: *roll, pitch, yaw, total, gyros, magnet, and accel*). It would have been preferred to use the summary variables for our model as they immensely reduce the number of observations and processing time and yet contain the gist of the measurement variables. However, it was impossible to make predictions based on the summary variables on the testing dataset as this contain only missing values. We will be removing the **housekeeping variables** that contain the row numbers *(x)*, timestamps (*raw_timestamp_part_1, raw_timestamp_part_2, cvtd_timestamp*), and measurement intervals (*new_window and num_window*).

The downloaded  training dataset contains ``160`` variables and ``19622`` rows while the testing dataset contains ``160`` variables and ``160`` rows.

###Setting the variables to their correct class
We need to set the variables into its correct class to avoid errors.

```r
my_df2$total_accel_belt <- as.numeric(my_df2$total_accel_belt)
my_df2$accel_belt_x <- as.numeric(my_df2$ accel_belt_x)
my_df2$accel_belt_y <- as.numeric(my_df2$accel_belt_y)
my_df2$accel_belt_z <- as.numeric(my_df2$accel_belt_z)
my_df2$magnet_belt_x <- as.numeric(my_df2$magnet_belt_x)
my_df2$magnet_belt_y <- as.numeric(my_df2$magnet_belt_y)
my_df2$magnet_belt_z <- as.numeric(my_df2$magnet_belt_z)
my_df2$total_accel_arm <- as.numeric(my_df2$total_accel_arm)
my_df2$accel_arm_x <- as.numeric(my_df2$accel_arm_x)
my_df2$accel_arm_y <- as.numeric(my_df2$accel_arm_y)
my_df2$accel_arm_z <- as.numeric(my_df2$accel_arm_z)
my_df2$magnet_arm_x <- as.numeric(my_df2$magnet_arm_x)
my_df2$magnet_arm_y <- as.numeric(my_df2$magnet_arm_y)
my_df2$magnet_arm_z <- as.numeric(my_df2$magnet_arm_z)
my_df2$total_accel_dumbbell <- as.numeric(my_df2$total_accel_dumbbell)
my_df2$total_accel_dumbbell <- as.numeric(my_df2$total_accel_dumbbell)
my_df2$accel_dumbbell_x <- as.numeric(my_df2$ accel_dumbbell_x)
my_df2$accel_dumbbell_y <- as.numeric(my_df2$ accel_dumbbell_y)
my_df2$accel_dumbbell_z <- as.numeric(my_df2$ accel_dumbbell_z)
my_df2$magnet_dumbbell_x <- as.numeric(my_df2$ magnet_dumbbell_x)
my_df2$magnet_dumbbell_y <- as.numeric(my_df2$ magnet_dumbbell_y)
my_df2$total_accel_forearm <- as.numeric(my_df2$total_accel_forearm)
my_df2$accel_forearm_x <- as.numeric(my_df2$accel_forearm_x)
my_df2$accel_forearm_y <- as.numeric(my_df2$accel_forearm_y)
my_df2$accel_forearm_z <- as.numeric(my_df2$accel_forearm_z)
my_df2$magnet_forearm_x <- as.numeric(my_df2$magnet_forearm_x)
my_df2$classe <- as.factor(my_df2$classe)
###Checking for variables that contain only zeroes
all_zero_index <- sapply(my_df2[,-53], sum)
all_zero_vars <- which(all_zero_index == 0)
```

### Creating a Train set and a Validation set

We partition the data into a train set and two test sets with 60, 20, and 20 percent composition. A testing set was downloaded earlier as a final validation of the model's accuracy.

```r
library(caret)
set.seed(107)
intrain <- createDataPartition(y = my_df2$classe, p = 0.6, list = FALSE)
train_set <- my_df2[intrain, ]
validation_set <- my_df2[-intrain, ]
intrain2 <- createDataPartition(y = validation_set$classe, p = 0.75, list = FALSE)
test_set1 <- validation_set[intrain2, ]
test_set2 <- validation_set[-intrain2, ]
```

The final training dataset contains ``53`` variables and ``11776`` rows. The first test set has ``53`` variables and ``5886`` rows. The second test set has ``53`` variables and ``1960`` rows.

###Model Creation
We generate a random forest model on the training dataset using the caret and rf package. The variable classe will be our dependent variable. It contains the classification of whether the movement was performed correctly or not and what error was commited as discussed earlier.We included a 5-fold cross validation to improve our model repeated twice.


```r
ctrl <- trainControl(method="repeatedcv", number=5, repeats=2)
rfor_fitall = train(classe ~ ., data=train_set, method="rf", trControl=ctrl)
```

###Assessing Model Accuracy
We examine the model for its accuracy and we find it to be very accurate.

```r
library(knitr)
print(kable(rfor_fitall$results))
```



 mtry    Accuracy       Kappa   AccuracySD     KappaSD
-----  ----------  ----------  -----------  ----------
    2   0.9890880   0.9861952    0.0016867   0.0021348
   27   0.9891732   0.9863023    0.0034669   0.0043881
   52   0.9816579   0.9767923    0.0048224   0.0061066


```r
pred_Trainingset <- predict(rfor_fitall, newdata = train_set)
pred_Vset <- predict(rfor_fitall, newdata = test_set1)
In_SampleErr <- table(pred_Trainingset,train_set$classe)
out_of_SampleErr <- table(pred_Vset, test_set1$classe)
Model_accuracy <- confusionMatrix(pred_Vset, test_set1$classe)
```

The table below shows which predictions on the training dataset and the validation dataset were correct and which were not. The non-diagonal elements are the errors. We can see that our model was able to predict on the training dataset perfectly, which maybe a cause for worry with regard to overfitting.  


```r
print(kable(In_SampleErr))
```

         A      B      C      D      E
---  -----  -----  -----  -----  -----
A     3348      0      0      0      0
B        0   2279      0      0      0
C        0      0   2054      0      0
D        0      0      0   1930      0
E        0      0      0      0   2165

The prediction on the the first test dataset was 99% accurate. it misclassified only 40 out of a possible 5,886 entries for an overall misclassification rate of **0.68%**.


```r
print(kable(out_of_SampleErr))
```

         A      B      C     D      E
---  -----  -----  -----  ----  -----
A     1673      5      0     0      0
B        1   1130      7     0      0
C        0      4   1017     9      3
D        0      0      2   955      3
E        0      0      0     1   1076

The confusion matrix summarize the accuracy, sensitivity, specificity, and other parameters of our model.


```r
print(kable(Model_accuracy$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9994026     0.9988129        0.9970203        0.9997624    0.2844037        0.2842338              0.2850832           0.9991078
Class: B      0.9920983     0.9983147        0.9929701        0.9981045    0.1935100        0.1919810              0.1933401           0.9952065
Class: C      0.9912281     0.9967078        0.9845111        0.9981455    0.1743119        0.1727829              0.1755012           0.9939679
Class: D      0.9896373     0.9989839        0.9947917        0.9979700    0.1639484        0.1622494              0.1630989           0.9943106
Class: E      0.9944547     0.9997918        0.9990715        0.9987523    0.1838260        0.1828067              0.1829766           0.9971233

The plot below shows the relationship between the number of randomly selected predictors and the accuracy. Accuracy is highest when mtry, the number of variables available for splitting at each tree node is 27. mtry is the tuning parameter for the package rf in caret.



![](index_files/figure-html/Accplot-1.png)

###Reducing the Number of Features
We now check which features are important for our model to reduce the number of features in our model to improve the processing time of our model and improve scalability and interpretability.

```r
varImpPlot(rfor_fitall$finalModel, n.var = 27)
```

![](index_files/figure-html/ImpFeatplot-1.png)

We compare the more important features to those which are highly correlated and decide which features to keep.

###Identifying Variables with High Correlation

```r
cor_mat <- cor(train_set[,-53])
Cor_Sum <- summary(cor_mat[upper.tri(cor_mat)])
highcor <- findCorrelation(cor_mat, cutoff = .75)
highcor_Vars <-as.data.frame(names(train_set)[highcor])
names(highcor_Vars) <- "Hi_Corr_Vars"
print(kable(highcor_Vars))
```



Hi_Corr_Vars      
------------------
accel_belt_z      
roll_belt         
accel_belt_y      
accel_arm_y       
total_accel_belt  
accel_dumbbell_z  
accel_belt_x      
pitch_belt        
magnet_dumbbell_x 
accel_dumbbell_y  
magnet_dumbbell_y 
accel_dumbbell_x  
accel_arm_x       
accel_arm_z       
magnet_arm_y      
magnet_belt_z     
accel_forearm_y   
gyros_arm_x       

**Can  we do just as well with 20 features?**


```r
ctrl <- trainControl(method="repeatedcv", number=5, repeats=2)
rfor_fit20 = train(classe ~ yaw_belt + pitch_forearm + magnet_dumbbell_z + pitch_belt + magnet_belt_y + gyros_belt_z + magnet_belt_x + gyros_arm_y + gyros_dumbbell_y + yaw_arm + accel_belt_z + accel_dumbbell_z + accel_dumbbell_y + gyros_forearm_y + accel_forearm_x + gyros_belt_x + magnet_arm_z + gyros_dumbbell_z + magnet_belt_z + magnet_dumbbell_y, data=train_set, method="rf", trControl=ctrl)
```


```r
pred_Vset20 <- predict(rfor_fit20, newdata = test_set1)
Model_accuracy20 <- confusionMatrix(pred_Vset20, test_set1$classe)
```

**Model with all the variables as predictors**


```r
print(kable(Model_accuracy$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9994026     0.9988129        0.9970203        0.9997624    0.2844037        0.2842338              0.2850832           0.9991078
Class: B      0.9920983     0.9983147        0.9929701        0.9981045    0.1935100        0.1919810              0.1933401           0.9952065
Class: C      0.9912281     0.9967078        0.9845111        0.9981455    0.1743119        0.1727829              0.1755012           0.9939679
Class: D      0.9896373     0.9989839        0.9947917        0.9979700    0.1639484        0.1622494              0.1630989           0.9943106
Class: E      0.9944547     0.9997918        0.9990715        0.9987523    0.1838260        0.1828067              0.1829766           0.9971233

**Model with 20 variables**


```r
print(kable(Model_accuracy20$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9970131     0.9985755        0.9964179        0.9988126    0.2844037        0.2835542              0.2845736           0.9977943
Class: B      0.9903424     0.9972614        0.9886065        0.9976818    0.1935100        0.1916412              0.1938498           0.9938019
Class: C      0.9863548     0.9948560        0.9758920        0.9971128    0.1743119        0.1719334              0.1761808           0.9906054
Class: D      0.9813472     0.9987807        0.9937041        0.9963511    0.1639484        0.1608902              0.1619096           0.9900639
Class: E      0.9972274     0.9997918        0.9990741        0.9993758    0.1838260        0.1833163              0.1834862           0.9985096

**we achieved the same accuracy,sensitivity, and specificity with fewer features.  We probably can reduce it some more**.

**Let's try a model with 8 features**

```r
ctrl <- trainControl(method="repeatedcv", number=5, repeats=2)
rfor_fit8 = train(classe ~ yaw_belt + pitch_forearm + magnet_dumbbell_z + pitch_belt + magnet_dumbbell_y + gyros_belt_z + magnet_belt_x + yaw_arm, data=train_set, method="rf", trControl=ctrl)
```


```r
pred_testset8 <- predict(rfor_fit8, newdata = test_set1)
Model_accuracy8 <- confusionMatrix(pred_testset8, test_set1$classe)
print(kable(Model_accuracy8$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9940263     0.9964387        0.9910661        0.9976230    0.2844037        0.2827047              0.2852531           0.9952325
Class: B      0.9640035     0.9957868        0.9821109        0.9914010    0.1935100        0.1865443              0.1899422           0.9798952
Class: C      0.9853801     0.9921811        0.9637750        0.9968989    0.1743119        0.1717635              0.1782195           0.9887806
Class: D      0.9865285     0.9979679        0.9896050        0.9973599    0.1639484        0.1617397              0.1634387           0.9922482
Class: E      0.9907579     0.9987510        0.9944341        0.9979201    0.1838260        0.1821271              0.1831464           0.9947544

**The results were still impressive. If you recall the plot above, 2 randomly selected predictors was able to achieve a slightly lower accuracy compared to one with 20**.

**Let's try a model with 4 features**.

```r
rfor_fit4 = train(classe ~ yaw_belt + pitch_forearm + magnet_dumbbell_z + yaw_arm, data=train_set, method="rf", trControl=ctrl)
```


```r
pred_testset4 <- predict(rfor_fit4, newdata = test_set1)
Model_accuracy4 <- confusionMatrix(pred_testset4, test_set1$classe)
print(kable(Model_accuracy4$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9689367     0.9883666        0.9706762        0.9876631    0.2844037        0.2755691              0.2838940           0.9786516
Class: B      0.8858648     0.9772488        0.9033124        0.9727406    0.1935100        0.1714237              0.1897723           0.9315568
Class: C      0.8927875     0.9777778        0.8945312        0.9773756    0.1743119        0.1556235              0.1739721           0.9352827
Class: D      0.9316062     0.9784597        0.8945274        0.9864782    0.1639484        0.1527353              0.1707441           0.9550329
Class: E      0.9574861     0.9931307        0.9691300        0.9904505    0.1838260        0.1760109              0.1816174           0.9753084

**Sensitivity  dipped considerably but specificity is still up there. A model with 4 features has better interpretability, scalability and faster processing**.

###Predicting on the second Test Set
**we now compare the model with all the variables and the one with 4 only on the second test set.**

```r
pred_testsetall_2 <- predict(rfor_fitall, newdata = test_set2)
Model_accuracyall_2 <- confusionMatrix(pred_testsetall_2, test_set2$classe)
pred_testset4_2 <- predict(rfor_fit4, newdata = test_set2)
Model_accuracy4_2 <- confusionMatrix(pred_testset4_2, test_set2$classe)
```

**Model with all variables as predictors**


```r
print(kable(Model_accuracyall_2$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9964158     0.9985735        0.9964158        0.9985735    0.2846939        0.2836735              0.2846939           0.9974946
Class: B      0.9947230     0.9981025        0.9921053        0.9987342    0.1933673        0.1923469              0.1938776           0.9964127
Class: C      0.9853801     0.9950556        0.9768116        0.9969040    0.1744898        0.1719388              0.1760204           0.9902179
Class: D      0.9781931     0.9981696        0.9905363        0.9957395    0.1637755        0.1602041              0.1617347           0.9881814
Class: E      0.9972222     0.9993750        0.9972222        0.9993750    0.1836735        0.1831633              0.1836735           0.9982986

**Model with 4 predictors**


```r
print(kable(Model_accuracy4_2$byClass))
```

            Sensitivity   Specificity   Pos Pred Value   Neg Pred Value   Prevalence   Detection Rate   Detection Prevalence   Balanced Accuracy
---------  ------------  ------------  ---------------  ---------------  -----------  ---------------  ---------------------  ------------------
Class: A      0.9784946     0.9843081        0.9612676        0.9913793    0.2846939        0.2785714              0.2897959           0.9814014
Class: B      0.8786280     0.9784946        0.9073569        0.9711237    0.1933673        0.1698980              0.1872449           0.9285613
Class: C      0.8801170     0.9796044        0.9011976        0.9747847    0.1744898        0.1535714              0.1704082           0.9298607
Class: D      0.9314642     0.9823063        0.9115854        0.9865196    0.1637755        0.1525510              0.1673469           0.9568852
Class: E      0.9583333     0.9887500        0.9504132        0.9906074    0.1836735        0.1760204              0.1852041           0.9735417

**Sensitivity suffered a bit but Specificity is still up there. Removing some of the predictors increased bias, which reduced our capacity to predict accurately.**

###Conclusions
Predictive models on the HAR weight lifting exercises dataset   classified errors and correct execution of lifting barbells with high accuracy, sensitivity and specificity. It has to be pointed out however, that the errors in movement were performed purposefully.  Different results may be obtained when the errors are committed without intent to commit the error. 

###Misclassified points by the model with all variables on the 2nd test set

```r
correctall <- pred_testsetall_2 == test_set2$classe
qplot(pitch_forearm,magnet_dumbbell_z,colour=correctall,data=test_set2)
```

![](index_files/figure-html/correctplotall-1.png)

###Misclassified points by the model with 20 variables on the 2nd test set

```r
pred_testset20_2 <- predict(rfor_fit20, newdata = test_set2)
Model_accuracy20_2 <- confusionMatrix(pred_testset20_2, test_set2$classe)
correct20 <- pred_testset20_2 == test_set2$classe
qplot(pitch_forearm,magnet_dumbbell_z,colour=correct20,data=test_set2)
```

![](index_files/figure-html/correctplot20-1.png)

###Misclassified points by the model with 8 variables on the 2nd test set

```r
pred_testset8_2 <- predict(rfor_fit8, newdata = test_set2)
Model_accuracy8_2 <- confusionMatrix(pred_testset8_2, test_set2$classe)
correct8 <- pred_testset8_2 == test_set2$classe
qplot(pitch_forearm,magnet_dumbbell_z,colour=correct8,data=test_set2)
```

![](index_files/figure-html/correctplot8-1.png)

###Misclassified points by the model with 4 variables on the 2nd test set

```r
correct4 <- pred_testset4_2 == test_set2$classe
qplot(pitch_forearm,magnet_dumbbell_z,colour=correct4,data=test_set2)
```

![](index_files/figure-html/correctplot4-1.png)

###Predicting on the Test Set
We now use our different models to predict on the downloaded test set.  The results are the same for all models. 


```r
testing_proc <- testing[ , which(names(testing) %in% names(train_set))]
pred_Testset <- predict(rfor_fitall, newdata = testing)
print(pred_Testset)
```

 [1] B A B A A E D B A A B C B A E E A B B B
Levels: A B C D E

```r
pred_Testset20 <- predict(rfor_fit20, newdata = testing)
print(pred_Testset20)
```

 [1] B A B A A E D B A A B C B A E E A B B B
Levels: A B C D E

```r
pred_Testset8 <- predict(rfor_fit8, newdata = testing)
print(pred_Testset8)
```

 [1] B A B A A E D B A A B C B A E E A B B B
Levels: A B C D E

```r
pred_Testset4 <- predict(rfor_fit4, newdata = testing)
print(pred_Testset8)
```

 [1] B A B A A E D B A A B C B A E E A B B B
Levels: A B C D E


```r
sessionInfo()
```

```
## R version 3.2.4 (2016-03-10)
## Platform: i386-w64-mingw32/i386 (32-bit)
## Running under: Windows 10 (build 10586)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] randomForest_4.6-12 knitr_1.12.3        caret_6.0-64       
## [4] ggplot2_2.1.0       lattice_0.20-33    
## 
## loaded via a namespace (and not attached):
##  [1] codetools_0.2-14   digest_0.6.9       htmltools_0.3     
##  [4] minqa_1.2.4        splines_3.2.4      MatrixModels_0.4-1
##  [7] scales_0.3.0       grid_3.2.4         stringr_1.0.0     
## [10] e1071_1.6-7        lme4_1.1-11        munsell_0.4.3     
## [13] highr_0.5.1        nnet_7.3-12        labeling_0.3      
## [16] foreach_1.4.3      iterators_1.0.8    mgcv_1.8-12       
## [19] Matrix_1.2-4       MASS_7.3-45        plyr_1.8.3        
## [22] stats4_3.2.4       stringi_1.0-1      pbkrtest_0.4-6    
## [25] magrittr_1.5       car_2.1-1          reshape2_1.4.1    
## [28] rmarkdown_0.9.5    evaluate_0.8.3     gtable_0.2.0      
## [31] colorspace_1.2-6   yaml_2.1.13        tools_3.2.4       
## [34] parallel_3.2.4     nloptr_1.0.4       nlme_3.1-126      
## [37] quantreg_5.21      class_7.3-14       formatR_1.3       
## [40] Rcpp_0.12.3        SparseM_1.7
```
