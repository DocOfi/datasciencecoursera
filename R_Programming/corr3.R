corr3 <- function(directory, threshold = 0)  {
  all_data <- lapply(list.files(directory, full.names = TRUE), read.csv)
  clean <-lapply(all_data, na.omit)
  nobs <- sapply(clean, nrow)
  abovet<- which(nobs > threshold)
  if (is.null(abovet) == TRUE) {
    numeric(0)
  }
  else {
        clean2 <- clean[abovet]
          corln <- sapply(clean2, function(a) cor(a["nitrate"], a["sulfate"]))
          corln2 <- as.numeric(corln)
          }
  return(corln2)
}