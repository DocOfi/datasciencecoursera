complete6 <- function(directory, id = 1:332)  {
    all_data <- lapply(list.files(directory, full.names = TRUE), read.csv)
    clean <- lapply(all_data, na.omit)
    nobs <- sapply(clean, nrow)
    nobs2 <- nobs[id]
    return(data.frame(id = id, nobs = nobs2))
}
