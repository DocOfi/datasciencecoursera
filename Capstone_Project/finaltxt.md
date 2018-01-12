# final corpus
DocOfi  
July 3, 2016  



## Synopsis
It is quite often we hear people complain that we read the same stories in the news everyday.  I decided for my project i will create an app where individuals can pit their ability to predict the news by predicting the next word in a sequence of words from a corpus, data consisting of sentences gathered from news sources.  This decision has the advantage of avoiding many mispelled words, incorrect sentence construction, and colloquial words common to a corpus obtained from sources such as Tweets from twitter. It also has the further advantage that the user of the app will be trying to match what the app will be trying to predict instead of the other way around.

I will be using 10% of the news database obtained from HC Corpora [www.corpora.heliohost.org](http://www.corpora.heliohost.org/aboutcorpus.html). Details about the corpora may be obtained from [http://www.corpora.heliohost.org/aboutcorpus.html](http://www.corpora.heliohost.org/aboutcorpus.html).

A few lines of text from the blog and twitter database were selectively added based on their helpfulness in answering the quizzes correctly. I will be creating a sequence of single words (Unigrams) up to a sequence of five words (5grams) from the sample text data. a longer sequence of words provides a better context when predicting the next word in sequence. However, contraints regarding file size and processing time will be reckoned later.  The size of our look up tables from the() ngrams will be trimmed accordingly to meet this requirements.

###Predicting the Next Word
When humans try to predict a conversation or the next word in a conversation, many contextual clues are taken into account, Much of these, like facial expression, vocal intonations, and many others are registered unconscioulsy. Humans by far are better at this task, however any one who has used google to search the web or sent a text using a cellphone cannot be amazed how far technology has advanced to mimic human faculties.

The task in this project fall under the umbrella of Natural Language Programming, [Natural language processing (NLP) is a field of computer science, artificial intelligence, and computational linguistics concerned with the interactions between computers and human (natural) languages](https://en.wikipedia.org/wiki/Natural_language_processing). Computers prediction of the next word is based on probabilities attached to a sequence of words.  A sequence of two words is called a bigram; three words, a trigram and so on. 

As much as i tried to understand and implement the strategies described in the lectures in order to improve the models accuracy in predicting the next word, the only reliable strategy that afforded me some success is to use a longer sequence of words, particularly a 5 gram and ovefitting the model by including text that replicate the quiz phrases. However, this strategy has the disadvantage of requiring a lot of memory and a slow processinng time.


```r
library(doParallel) 
registerDoParallel(cores=2)
getDoParWorkers()
```

```
## [1] 2
```

```r
attach("newsamp.RData")
library(stringi)
newsdf <- data.frame(Type = "news",
            Lines = length(news_samp),
            MeanWordsperLine = mean(stri_count_words(news_samp)),
            MeanSentperLine = mean(stri_count_boundaries(news_samp, type = "sentence")),
            MeanCharperLine = mean(stri_count_boundaries(news_samp, type = "character")))
print(newsdf)
```

```
##   Type  Lines MeanWordsperLine MeanSentperLine MeanCharperLine
## 1 news 101548         34.49086        2.004284        201.6564
```

```r
news_samp <- iconv(news_samp, "UTF-8", "ascii", sub = " ") ### removing UTF codes that are not displayed properly
```

It seems that there are more than 1 sentence per line in our corpus. We need to split these sentences and appropriate single rows for them.  Otherwise, the end of one sentence will be connected to the succeeding sentence and we'll end up having group of words that may not make sense. 


```r
split_samp <- stri_split_boundaries(news_samp, type="sentence", skip_sentence_sep=TRUE)
split_samp <- unlist(split_samp)
splitdf <- data.frame(Type = "news",
            Lines = length(split_samp),
            MeanWordsperLine = mean(stri_count_words(split_samp)),
            MeanSentperLine = mean(stri_count_boundaries(split_samp, type = "sentence")),
            MeanCharperLine = mean(stri_count_boundaries(split_samp, type = "character")))
rm(news_samp)
print(splitdf)
```

```
##   Type  Lines MeanWordsperLine MeanSentperLine MeanCharperLine
## 1 news 193739         17.76347               1        103.8307
```

###A few more cleaning to remove dollar signs and apostrophes


```r
split_samp <- gsub("'", "", split_samp) ###removes apostropes and avoid tokenizing s as a word
split_samp <- gsub("[^[:alnum:][:space:]]", "", split_samp) ###removes everything except spaces and letters 
```


###Removing swear words

```r
tbcsv <- read.csv("Terms-to-Block.csv", header = FALSE, sep = ",", skip = 4, stringsAsFactors = FALSE)
profanity <- tbcsv$V2
profanity <- gsub(",", "", profanity )
head(profanity)
```

```
## [1] "a55"       "a55hole"   "aeolus"    "ahole"     "anal"      "analprobe"
```

```r
detach("file:newsamp.RData")
rm(tbcsv, newsdf, splitdf)
```

There is chance that swear words are present in our corpus. A list of swear words are obtained from [http://www.frontgatemedia.com/a-list-of-723-bad-words-to-blacklist-and-how-to-use-facebooks-moderation-tool](http://www.frontgatemedia.com/a-list-of-723-bad-words-to-blacklist-and-how-to-use-facebooks-moderation-tool) which we will use to filter swear words in our corpus.

###Creating sequence of words of varying lengths from our Corpus
First, we split the lines of text in the corpus into individual words and we count how many times this particular word appears in the corpus. A sort of dictionary of words but instead of definitions, the words are accompanied by it's frequency in the corpus. Here we present the most frequent 15 words from the corpus. We also drop words that appear less than 3 times in the corpus.  This offers the advantage of removing mispelled words and less often occuring words, particularly those that are newly coined and has not yet been accepted as part of the English Language.  However, it also has the disadvantage of losing bonefide English words that are rarely used. 


```r
library(quanteda)
library(ggplot2)
singleWords <- dfm(split_samp, ngrams = 1, verbose = TRUE, toLower = TRUE, removeNumbers = TRUE, removePunct = TRUE, removeSeperators = TRUE, removeTwitter = TRUE, stem = FALSE, what = "fasterword", removeHyphens = TRUE, removeURL = TRUE, concatenator = " ", stopwords=FALSE, ignoredFeatures = profanity)
```

```
## 
##    ... lowercasing
##    ... tokenizing
##    ... indexing documents: 193,739 documents
##    ... indexing features: 99,204 feature types
##    ... removed 240 features, from 717 supplied (glob) feature types
##    ... created a 193739 x 98965 sparse dfm
##    ... complete. 
## Elapsed time: 17.09 seconds.
```

```r
singleWords <- trim(singleWords, minCount = 3, minDoc = 2)
```

```
## Removing features occurring fewer than 3 times: 60633
## Removing features occurring in fewer than 2 documents: 47592
```

```r
mydf1wS <- sort(docfreq(singleWords), decreasing=TRUE)
n1g_freqt <- data.frame(Words=names(mydf1wS), Frequency = mydf1wS, row.names = NULL, stringsAsFactors = FALSE)
unigram <- ggplot(within(n1g_freqt[1:15, ], Words <- factor(Words, levels=Words)), aes(Words, Frequency))
unigram <- unigram + geom_bar(stat="identity", fill="steelblue") + ggtitle("Top 15 Unigrams")
unigram <- unigram + theme(axis.text.x=element_text(angle=45, hjust=1))
unigram
```

<div class="figure">
<img src="finaltxt_files/figure-html/wordfreq1-1.png" alt="fig.1. Frequency of the top 15 individual words or unigrams in the corpus"  />
<p class="caption">fig.1. Frequency of the top 15 individual words or unigrams in the corpus</p>
</div>


```r
rm(singleWords, mydf1wS, unigram)
n1g_freqt$Words <- as.character(n1g_freqt$Words)
n1g_freqt$Frequency <- as.numeric(n1g_freqt$Frequency)
rm(n1g_freqt)
```

###A List of Paired Words in the Corpus
Second, we split the lines of text again into pairs of words based on their sequence in the sentence. These pair words are better known as bigrams. We will be dropping less frequent bigrams as well.


```r
biWords <- dfm(split_samp, ngrams = 2, verbose = TRUE, toLower = TRUE, removeNumbers = TRUE, removePunct = TRUE, removeSeperators = TRUE, removeTwitter = TRUE, stem = FALSE, what = "fasterword", removeHyphens = TRUE, removeURL = TRUE, concatenator = " ", stopwords=FALSE, ignoredFeatures = profanity)
```

```
## 
##    ... lowercasing
##    ... tokenizing
##    ... indexing documents: 193,739 documents
##    ... indexing features: 1,095,556 feature types
##    ... removed 4,311 features, from 717 supplied (glob) feature types
##    ... created a 193739 x 1091246 sparse dfm
##    ... complete. 
## Elapsed time: 126.57 seconds.
```

```r
biWords <- trim(biWords, minCount = 3, minDoc = 2)
```

```
## Removing features occurring fewer than 3 times: 939192
## Removing features occurring in fewer than 2 documents: 822870
```

```r
mydf2wS <- sort(docfreq(biWords), decreasing=TRUE)
n2g_freqt <- data.frame(Words=names(mydf2wS), Frequency = mydf2wS, row.names = NULL, stringsAsFactors = FALSE)
bigram <- ggplot(within(n2g_freqt[1:15, ], Words <- factor(Words, levels=Words)), aes(Words, Frequency))
bigram <- bigram + geom_bar(stat="identity", fill="steelblue2") + ggtitle("Top 15 Bigrams")
bigram <- bigram + theme(axis.text.x=element_text(angle=45, hjust=1))
bigram
```

<div class="figure">
<img src="finaltxt_files/figure-html/wordfreq2-1.png" alt="fig.3. Frequency of the top 15 sequence of 2 words or bigrams in the corpus"  />
<p class="caption">fig.3. Frequency of the top 15 sequence of 2 words or bigrams in the corpus</p>
</div>


```r
rm(biWords, mydf2wS, bigram)
n2g_freqt$Words <- as.character(n2g_freqt$Words)
n2g_freqt$Frequency <- as.numeric(n2g_freqt$Frequency)
rm(n2g_freqt)
```

###A List of 3 Word sequences in the Corpus
Again we split the lines of text in the corpus, this time  into a 3 word sequence or trigrams.  Below we present the most frequent 15 trigrams from the corpus. unigrams, bigrams, trigrams, and higher number of sequence of words are collectively called n-grams. The frequency that a particular n-gram appear in the corpus and the frequency that certain words occur together forms the basis for most prediction models.


```r
triWords <- dfm(split_samp, ngrams = 3, verbose = TRUE, toLower = TRUE, removeNumbers = TRUE, removePunct = TRUE, removeSeperators = TRUE, removeTwitter = TRUE, stem = FALSE, what = "fasterword", removeHyphens = TRUE, removeURL = TRUE, concatenator = " ", stopwords=FALSE, ignoredFeatures = profanity)
```

```
## 
##    ... lowercasing
##    ... tokenizing
##    ... indexing documents: 193,739 documents
##    ... indexing features: 2,217,680 feature types
##    ... removed 9,457 features, from 717 supplied (glob) feature types
##    ... created a 193739 x 2208224 sparse dfm
##    ... complete. 
## Elapsed time: 206.84 seconds.
```

```r
triWords <- trim(triWords, minCount = 3, minDoc = 2)
```

```
## Removing features occurring fewer than 3 times: 2108028
## Removing features occurring in fewer than 2 documents: 1978073
```


```r
mydf3wS <- sort(docfreq(triWords), decreasing=TRUE)
```


```r
rm(triWords)
```


```r
n3g_freqt <- data.frame(Words=names(mydf3wS), Frequency = mydf3wS, row.names = NULL, stringsAsFactors = FALSE)
```


```r
rm(mydf3wS)
```


```r
trigram <- ggplot(within(n3g_freqt[1:15, ], Words <- factor(Words, levels=Words)), aes(Words, Frequency))
trigram <- trigram + geom_bar(stat="identity", fill="steelblue2") + ggtitle("Top 15 Bigrams")
trigram <- trigram + theme(axis.text.x=element_text(angle=45, hjust=1))
trigram
```

<div class="figure">
<img src="finaltxt_files/figure-html/wordfreq3d-1.png" alt="fig.3. Frequency of the sequence of 3 words or trigrams in the corpus"  />
<p class="caption">fig.3. Frequency of the sequence of 3 words or trigrams in the corpus</p>
</div>


```r
rm(trigram)
n3g_freqt$Words <- as.character(n3g_freqt$Words)
n3g_freqt$Frequency <- as.numeric(n3g_freqt$Frequency)
rm(n3g_freqt)
```

###A List of 4 Word sequences in the Corpus
Again we split the lines of text in the corpus, this time  into a 4 word sequences or 4-grams. A longer sequence of n-grams provide better context for a more accurate precision.


```r
fourWords <- dfm(split_samp, ngrams = 4, verbose = TRUE, toLower = TRUE, removeNumbers = TRUE, removePunct = TRUE, removeSeperators = TRUE, removeTwitter = TRUE, stem = FALSE, what = "fasterword", removeHyphens = TRUE, removeURL = TRUE, concatenator = " ", stopwords=FALSE, ignoredFeatures = profanity)
```

```
## 
##    ... lowercasing
##    ... tokenizing
##    ... indexing documents: 193,739 documents
##    ... indexing features: 2,580,676 feature types
##    ... removed 12,917 features, from 717 supplied (glob) feature types
##    ... created a 193739 x 2567760 sparse dfm
##    ... complete. 
## Elapsed time: 285.77 seconds.
```

```r
fourWords <- trim(fourWords, minCount = 3, minDoc = 2)
```

```
## Removing features occurring fewer than 3 times: 2540438
## Removing features occurring in fewer than 2 documents: 2478570
```


```r
mydf4wS <- sort(docfreq(fourWords), decreasing=TRUE)
```


```r
n4g_freqt <- data.frame(Words=names(mydf4wS), Frequency = mydf4wS, row.names = NULL, stringsAsFactors = FALSE)
```


```r
rm(mydf4wS)
n4g_freqt$Words <- as.character(n4g_freqt$Words)
n4g_freqt$Frequency <- as.numeric(n4g_freqt$Frequency)
rm(n4g_freqt)
```

###A List of 5 Word sequences in the Corpus
Again we split the lines of text in the corpus, this time  into a 5 word sequences or 5-grams.  Here we present the most frequent 4-grams and 5-grams from the corpus in a word cloud.  The bigger the font of the sequence, the greater the number of times it occured in the corpus.


```r
fiveWords <- dfm(split_samp, ngrams = 5, verbose = TRUE, toLower = TRUE, removeNumbers = TRUE, removePunct = TRUE, removeSeperators = TRUE, removeTwitter = TRUE, stem = FALSE, what = "fasterword", removeHyphens = TRUE, removeURL = TRUE, concatenator = " ", stopwords=FALSE, ignoredFeatures = profanity)
```

```
## 
##    ... lowercasing
##    ... tokenizing
##    ... indexing documents: 193,739 documents
##    ... indexing features: 2,532,666 feature types
##    ... removed 15,409 features, from 717 supplied (glob) feature types
##    ... created a 193739 x 2517258 sparse dfm
##    ... complete. 
## Elapsed time: 262.13 seconds.
```


```r
library(RColorBrewer)
par(mfrow = c(1, 2))
plot(fourWords, min.freq = 2, max.words = 100, colors = brewer.pal(8, "Set1"), scale = c(8, .5), random.order = FALSE)
plot(fiveWords, min.freq = 2, max.words = 100, colors = brewer.pal(8, "Set1"), scale = c(8, .5), random.order = FALSE)
```

<div class="figure">
<img src="finaltxt_files/figure-html/wordcld1-1.png" alt="fig.4. Frequency of the top 65 sequence of 4grams and 5grams in the corpus expressed as a word cloud"  />
<p class="caption">fig.4. Frequency of the top 65 sequence of 4grams and 5grams in the corpus expressed as a word cloud</p>
</div>


```r
rm(fourWords)
```


```r
mydf5wS <- sort(docfreq(fiveWords), decreasing=TRUE)
```


```r
rm(fiveWords)
```


```r
n5g_freqt <- data.frame(Words=names(mydf5wS), Frequency = mydf5wS, row.names = NULL, stringsAsFactors = FALSE)
```


```r
rm(mydf5wS)
```


```r
n5g_freqt$Words <- as.character(n5g_freqt$Words)
n5g_freqt$Frequency <- as.numeric(n5g_freqt$Frequency)
rm(split_samp)
```

###Memory Saving Strategies
If you noticed our code from above, I did not remove the less frequent 5-grams. I will be using only the 5-gram table to predict the next word in my project to reduce the file size requirement.  The sequence of four-words, three-words, two-words, and single words can be found within the 5-gram frequency table with a little bit of igenuity.  This will form the basis for my prediction.    

First, i will seperate the 5-grams that occur more than once.  We will be using this as our look up table.  However, the number of rows of these 5-gram is few.  I will augment it by sampling the 5 grams that occur only once.  To maximize the likelihood that we will get the maximum number of matches with a 4-gram, 3-gram, 2-gram or unigram sequence of words we will sample evey fifth row.  


```r
above1 <- n5g_freqt[which(n5g_freqt$Frequency > 1), ]
ones <- n5g_freqt[which(n5g_freqt$Frequency == 1), ]
rm(n5g_freqt)
alt <- seq(1, length(ones$Words), by = 2)
ones <- ones[alt, ]
n5g_freqt <- rbind(above1, ones)
rm(above1, ones, alt)
```

Second, i have to split the 5-gram into seperate words and arrange them along the same row in a data frame, with one 5-gram sequence per row.


```r
split5g <- strsplit(n5g_freqt[,1], " ")
rm(n5g_freqt)
firstw <- as.data.frame(unlist(lapply(split5g, function(a) a[[1]])), stringsAsFactors = FALSE)
names(firstw) <- "w1"
```


```r
secondw <- as.data.frame(unlist(lapply(split5g, function(a) a[[2]])), stringsAsFactors = FALSE)
names(secondw) <- "w2"
```


```r
thirdw <- as.data.frame(unlist(lapply(split5g, function(a) a[[3]])), stringsAsFactors = FALSE)
names(thirdw) <- "w3"
```


```r
fourthw <- as.data.frame(unlist(lapply(split5g, function(a) a[[4]])), stringsAsFactors = FALSE)
names(fourthw) <- "w4"
```


```r
fifthw <- as.data.frame(unlist(lapply(split5g, function(a) a[[5]])), stringsAsFactors = FALSE)
names(fifthw) <- "w5"
```

###Look-up table
This data frame below will serve as our look-up table.As you can see information regarding the frequency of our n-grams will not be available.


```r
mydf <- cbind(firstw, secondw, thirdw, fourthw, fifthw)
rm(firstw, secondw, thirdw, fourthw, fifthw)
head(mydf)
```

```
##    w1  w2     w3   w4    w5
## 1  at the    end   of   the
## 2  in the middle   of   the
## 3 for the  first time since
## 4 for the  first time    in
## 5 the end     of  the   day
## 6 the end     of  the  year
```

```r
sapply(mydf, class)
```

```
##          w1          w2          w3          w4          w5 
## "character" "character" "character" "character" "character"
```

```r
dim(mydf)
```

```
## [1] 1273006       5
```

```r
saveRDS(mydf, file = "final5gdf.rds") ### we save the file in RDS format for use in shiny
```


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
## [1] parallel  stats     graphics  grDevices utils     datasets  methods  
## [8] base     
## 
## other attached packages:
## [1] RColorBrewer_1.1-2 ggplot2_2.1.0      quanteda_0.9.6-9  
## [4] stringi_1.1.1      doParallel_1.0.10  iterators_1.0.8   
## [7] foreach_1.4.3     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.5      ca_0.64          knitr_1.12.3     magrittr_1.5    
##  [5] wordcloud_2.5    munsell_0.4.3    colorspace_1.2-6 lattice_0.20-33 
##  [9] stringr_1.0.0    plyr_1.8.3       tools_3.2.4      grid_3.2.4      
## [13] data.table_1.9.6 gtable_0.2.0     htmltools_0.3    yaml_2.1.13     
## [17] digest_0.6.9     Matrix_1.2-4     formatR_1.3      codetools_0.2-14
## [21] slam_0.1-34      evaluate_0.8.3   rmarkdown_0.9.5  scales_0.3.0    
## [25] chron_2.3-47
```










