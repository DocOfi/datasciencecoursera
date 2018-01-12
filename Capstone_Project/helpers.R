mydf <- readRDS("./data/final5gdf.rds")
findnxtw <- function(text1) {
  no_punct <- gsub("[[:punct:]]", "", text1)
  no_cap <- tolower(no_punct)
  wintext <- strsplit(no_cap, " ")[[1]]
  num_words <- length(wintext)
  wrd1 <- wintext[num_words-3]
  wrd2 <- wintext[num_words-2]
  wrd3 <- wintext[num_words-1]
  wrd4 <- wintext[num_words-0]
  myrows1 <- subset(mydf, w1 == wrd1 & w2 == wrd2 & w3 == wrd3 & w4 == wrd4)
  a <- myrows1$w5
  myrows2 <- subset(mydf, w2 == wrd2 & w3 == wrd3 & w4 == wrd4)
  b <- myrows2$w5
  myrows3 <- subset(mydf, w1 == wrd2 & w2 == wrd3 & w3 == wrd4)
  c <- myrows3$w4
  myrows4 <- subset(mydf, w2 == wrd3 & w3 == wrd4)
  d <- myrows4$w4
  myrows5 <- subset(mydf, w3 == wrd3 & w4 == wrd4)
  e <- myrows5$w5
  myrows6 <- subset(mydf, w1 == wrd3 & w2 == wrd4)
  f <- myrows6$w3
  myrows7 <- subset(mydf, w1 == wrd4)
  g <- myrows7$w2
  myrows8 <- subset(mydf, w2 == wrd4)
  h <- myrows8$w3
  myrows9 <- subset(mydf, w3 == wrd4)
  i <- myrows9$w4    
  myrows10 <- subset(mydf, w4 == wrd4)
  j <- myrows10$w5
  predw <- c(a,b,c,d,e,f,g,h,i,j)
  ifelse(is.null(predw), phr <-"no match", phr <- predw[1])
  return(phr)
}