# An experiment to determine the effects of different types and concentrations of ascorbic acid on the growth of odontoblast cells in guinea pigs
DocOfi  
November 10, 2015  




####Synopsis
There are no significant differences in the mean odontoblast cell length between the group of guinea pigs receiving orange juice and vitamin c in general and when the dose is 2 mg/day.  There are significant differences in the means between the groups when the dose is 0.5 (p = 0.01) (t.test = 3.17, 95% CI 1.72 to 8.78) and 1.0 mg/day (p = 0) (t.test = 4.03, 95% CI 2.8 to 9.06).

##### Overview of the experiment

For this analysis we will be using the dataset ToothGrowth, which is included with every standard installation of R.  It contains a subset of the results from experiments conducted in the 1940's by EW Crampton of the Department of Nutrition, Macdonald College, McGill University.

28 (+/-3) days, sex- matched, 250-400 gm weight guinea pigs were enrolled in this experiment and fed a diet supplemented with varying doses (0.25, 0.50, 1.0 mg/day) of ascorbic acid in the form of orange juice or aquaeous solutions of vitamin c. At the conclusion of a 42 day period, the animals were sacrificed and measurements of the length of the incisor's odontoblasts (tooth-forming cells) were made under 440 magnification by means of an ocular micrometer and the readings are subsequently converted to microns.

####Exploratory Data Analysis


```
## 'data.frame':	60 obs. of  3 variables:
##  $ len : num  4.2 11.5 7.3 5.8 6.4 10 11.2 11.2 5.2 7 ...
##  $ supp: Factor w/ 2 levels "OJ","VC": 2 2 2 2 2 2 2 2 2 2 ...
##  $ dose: Factor w/ 3 levels "0.5","1","2": 1 1 1 1 1 1 1 1 1 1 ...
```

```
## Source: local data frame [2 x 8]
## 
##   supp  n min  max median     mean      var       sd
## 1   OJ 30 8.2 30.9   22.7 20.66333 43.63344 6.605561
## 2   VC 30 4.2 33.9   16.5 16.96333 68.32723 8.266029
```

```
## Source: local data frame [6 x 9]
## Groups: dose
## 
##   dose supp  n  min  max median  mean       var       sd
## 1  0.5   OJ 10  8.2 21.5  12.25 13.23 19.889000 4.459709
## 2  0.5   VC 10  4.2 11.5   7.15  7.98  7.544000 2.746634
## 3    1   OJ 10 14.5 27.3  23.45 22.70 15.295556 3.910953
## 4    1   VC 10 13.6 22.5  16.50 16.77  6.326778 2.515309
## 5    2   OJ 10 22.4 30.9  25.95 26.06  7.049333 2.655058
## 6    2   VC 10 18.5 33.9  25.95 26.14 23.018222 4.797731
```

The dataset contained 60 rows of observations from 60 Guinea pigs. The animals were divided into 2 groups of 30 based on the type of supplement they received (orange juice = oj and vitamin c = vc) and further subdivided into three groups (10 each) according to doses received (0.5, 1.0, 2.0 mg/day). There are (0) missing values in our data.

##### Initial Inference about the data

![](Tooth_files/figure-html/loading_tthdata-1.png) 

- The  mean length of odontoblast cells increased as the dose increased, regardless of the type of supplement. However, the difference  seemed to have equalized in the highest dose (2 mg/day), suggesting a possible saturation point where an increase in concentration will not have the same increase in odontoblast length.

- The mean length of odontoblast cells from animals that were given orange juice were generally higher compared to those who received vitamin c, suggesting, greater bio-availablity of ascorbic acid from orange juice compared to synthetically produced vitamin c.

#### Testing our inference using confidence intervals and/or hypothesis tests 

We will now verify whether our initial inference about the data is true by using the t test to compare the means between the two types of supplement and between the different dose of each supplement. We chose to apply the t test on these means due to the significant overlap in the inter-quartile range of their values. Less overlap was obseved between the individual doses within the respective type of supplements.

Our null hypothesis (H0) 
- There are no significant differences in the mean length of odontoblast cells in guinea pigs given orange juice and vitamin c in general and varying doses of: 0.05, 1.0,and 2.0 mg/day orange juice and vitamin c in particular.
Alternative hypothesis (HA)
- There are significant differences in the mean length of odontoblast cells in guinea pigs given orange juice and vitamin c in general and varying doses of: 0.05, 1.0,and 2.0 mg/day orange juice and vitamin c in particular.

#####Assumptions

- We assume that the random sampling was perfomed during the selection of animals and that the animals were taken from identical populations but are independent of each other.  
- We assume that the diet fed to the animals and food consumption in the different groups are similar.
- We assume that the orange juice and vitamin c supplement contain the same amount of ascorbic acid.
- We assume that our data follows approximates a normal distribution.
- We expected near equal variance between the different groups as they were obtained from the same population and sex-matched (as growth and size are different for the female and male guinea pig) however, the computed variance reveal otherwise.
- Based on the above, we assume that the appropriate test to compare the means between the different groups is the students t-test, with arguments: var.equal=FALSE, paired=FALSE, and conf.level=0.95.

##### Effect of type of Supplement

Comparing mean odontoblast cell lengths between the group receiving orange juice and vitamin c regardless of dose.


```
##                 t deg.f p.val low.CI upp.CI OJ.mean Vit.C.mean
## OJ vs Vit C  1.92 55.31  0.06  -0.17   7.57   20.66      16.96
```

##### Effect of Dosage

Comparing mean odontoblast cell lengths between the group receiving orange juice and vitamin c at different doses.


```
##                    t deg.f p.val low.CI upp.CI OJ.mean Vit.C.mean
## OJ vs Vit C 0.5 3.17 14.97  0.01   1.72   8.78   13.23       7.98
```

```
##                    t deg.f p.val low.CI upp.CI OJ.mean Vit.C.mean
## OJ vs Vit C 1.0 4.03 15.36     0    2.8   9.06    22.7      16.77
```

```
##                     t deg.f p.val low.CI upp.CI OJ.mean Vit.C.mean
## OJ vs Vit C 2.0 -0.05 14.04  0.96   -3.8   3.64   26.06      26.14
```

#### Conclusions

Confidence intervals are set to 95% usually to give a low 5% probability that the result occured by chance. Confidence intervals that include the value of 0 indicated that there is no difference in the mean values, therefore prevents us from rejectinng the null hypothesis.  

Based on these criteria and the results of our analysis, we accept the null hypothesis when comparing the mean odontablast cell lengths between the group receiving  orange juice and vitamin c regardless of dose (p = 0.06) (t.test = 1.92, 95% CI -0.17 to 7.57) and when the dose is 2mg/day (p = 0.96) (t.test = -0.05, 95% CI -3.8 to 3.64).  We reject the null hypothesis when the comparing two groups at doses of 0.5 (p = 0.01)(t.test = 3.17, 95% CI 1.72 to 8.78) and 1.0 mg/day (p = 0)(t.test = 4.03, 95% CI 2.8 to 9.06).

In other words, there is no significant difference in the effect of vitamin c and orange juice on odontoblast cell length of guinea pigs in general. There is significant difference in the mean odontoblast length between the two groups when the dose is 0.5 and 1.0 mg/day but not when the dose is 2.0 mg/day.

Assuming that the same amount of ascorbic acid is present in both types of supplement, it is reasonable to expect that there won't be any difference in the effects of the two groups.  The observed greater effect of orange juice in lower doses suggest greater bio-availability of ascorbic acid in orange juice and the observed lack of diffference in the 2.0 mg/day dose suggest a saturation in the effect of ascorbic acid on odontoblast cell length.

#### Appendix

##### References

1. Crampton E.W., "THE GROWTH OF THE ODONTOBLASTS OF THE
INCISOR TOOTH AS A CRITERION OF THE VITAMIN C INTAKE OF THE GUINEA PIG", J. Nutr., 1947, 491-504.
2. Bliss C.I., "The Statistics of Bioassay". Academic Press Inc., 1952, 499-501.

##### Codes

Code for global setting

```r
knitr::opts_chunk$set(warning=FALSE, message=FALSE)
setwd("C:/Users/Ed/Desktop/UCI HAR Dataset")
```
code for exploratory analysis section

```r
ToothGrowth$supp <- as.factor(ToothGrowth$supp)
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
str(ToothGrowth)
library(dplyr)
sum_supp_only <- ToothGrowth %>% group_by(supp) %>% summarize(n=n(), min=min(len), max = max(len), median = median(len), mean=mean(len), var=var(len), sd=sd(len))
sum_supdos <- ToothGrowth %>% group_by(dose, supp) %>% summarize(n=n(), min=min(len), max = max(len), median = median(len), mean=mean(len), var=var(len), sd=sd(len))
print(sum_supp_only)
print(sum_supdos)
```
code for Initial Inference about the data section

```r
z <- c(1, 3.5, 6)
x <- c("0.5", "1", "2")
par(mfrow = c(1, 2), bg = "grey", cex.axis = .9, cex.lab = .9)
par(mar=c(4.1,4.1,1.1,2.1))
par(oma = c( 0, 0, 3, 0 ))
boxplot(len ~ supp*dose, data = ToothGrowth, xlab = "Dose", col = c("orange", "yellow", "orange", "yellow", "orange", "yellow"), boxwex = .8, ylab = "Length (microns)", xaxt="n", cex = .8)
axis(side = 1, at=z,labels=x, col.axis="black", las=0, cex.axis=1)
boxplot(len ~ supp, data = ToothGrowth, xlab = "Supplement", col = c("orange", "yellow"), boxwex = .6, cex = .8)
mtext("Comparing Odontoblast Cell Lengths\n by Dose and Type of Supplement", outer = TRUE, col = "Black", cex.axis = .6)
```
code for Effect of type of Supplement section

```r
testsupp <- t.test(len ~ supp, data= ToothGrowth, var.equal = FALSE, paired=FALSE ,conf.level = .95)
ojvsvc <- data.frame( "t"  = round(testsupp$statistic, 2), "deg f" = round(testsupp$parameter, 2), "p-val"  = round(testsupp$p.value, 2), "low CI" = round(testsupp$conf.int[1], 2), "upp CI" = round(testsupp$conf.int[2], 2), "OJ mean" = round(testsupp$estimate[1], 2), "Vit C mean" = round(testsupp$estimate[2], 2), row.names = "OJ vs Vit C ")
print(ojvsvc)
```
code for Effect of Dosage section

```r
conc_half <- ToothGrowth[ToothGrowth$dose ==0.5, ]
ttest_half <- t.test(len ~ supp, data= conc_half, var.equal = FALSE, paired=FALSE ,conf.level = .95)
halfmgconc <- data.frame( "t"  = round(ttest_half$statistic, 2), "deg f" = round(ttest_half$parameter, 2), "p-val"  = round(ttest_half$p.value, 2), "low CI" = round(ttest_half$conf.int[1], 2), "upp CI" = round(ttest_half$conf.int[2], 2), "OJ mean" = round(ttest_half$estimate[1], 2), "Vit C mean" = round(ttest_half$estimate[2], 2), row.names = "OJ vs Vit C 0.5")
print(halfmgconc)
conc1 <- ToothGrowth[ToothGrowth$dose == 1, ]
ttest_1 <- t.test(len ~ supp, data= conc1, var.equal = FALSE, paired=FALSE ,conf.level = .95)
onemgconc <- data.frame( "t"  = round(ttest_1$statistic, 2), "deg f" = round(ttest_1$parameter, 2), "p-val"  = round(ttest_1$p.value, 2), "low CI" = round(ttest_1$conf.int[1], 2), "upp CI" = round(ttest_1$conf.int[2], 2), "OJ mean" = round(ttest_1$estimate[1], 2), "Vit C mean" = round(ttest_1$estimate[2], 2), row.names = "OJ vs Vit C 1.0")
print(onemgconc)
conc2 <- ToothGrowth[ToothGrowth$dose == 2, ]
ttest_2 <- t.test(len ~ supp, data= conc2, var.equal = FALSE, paired=FALSE ,conf.level = .95)
twomgconc <- data.frame( "t"  = round(ttest_2$statistic, 2), "deg f" = round(ttest_2$parameter, 2), "p-val"  = round(ttest_2$p.value, 2), "low CI" = round(ttest_2$conf.int[1], 2), "upp CI" = round(ttest_2$conf.int[2], 2), "OJ mean" = round(ttest_2$estimate[1], 2), "Vit C mean" = round(ttest_2$estimate[2], 2), row.names = "OJ vs Vit C 2.0")
print(twomgconc)
```
##### Brief of summary of the original experiment

The principal findings of the experiment were:

1. 28 days on intakes of 0.25mg of ascorbic acid have shown frank scurvy including capillary hemorrhage in the hind
legs. No cases of clinical scurvy were seen on intakes of 0.5mg per day.

2. At the upper end of the range, no increased response with intakes of 4.0 or 8.0mg over that shown for 2.0 mg were observed.

3. The length of odntoblast cells in guniea pigs is apparently limited by the level of vitamin C intake, and ranges from about 30 microns with intakes of 0.5 mg of ascorbic acid daily, to a maximum of about 70 microns with intakes of
2 mg or over. Within this range of intake, the odontoblast length bears a logarithmic relation to the vitamin C fed.

**NOTE** Information about the experiment was obtained from a copy of the article "THE GROWTH OF THE ODONTOBLASTS OF THE INCISOR TOOTH AS A CRITERION OF THE VITAMIN C INTAKE OF THE GUINEA PIG" by EW Crampton (Downloaded from jn.nutrition.org on November 9, 2015)


```r
sessionInfo()
```

```
## R version 3.2.1 (2015-06-18)
## Platform: i386-w64-mingw32/i386 (32-bit)
## Running under: Windows 8 (build 9200)
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
## [1] dplyr_0.4.2
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.0     digest_0.6.8    assertthat_0.1  R6_2.1.0       
##  [5] DBI_0.3.1       formatR_1.2     magrittr_1.5    evaluate_0.7.2 
##  [9] stringi_0.5-5   lazyeval_0.1.10 rmarkdown_0.8.1 tools_3.2.1    
## [13] stringr_1.0.0   yaml_2.1.13     parallel_3.2.1  htmltools_0.2.6
## [17] knitr_1.11
```
