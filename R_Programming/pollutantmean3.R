pollutantmean3 <- function(directory, pollutant, id = 1:332) {
    all_data <- lapply(list.files(directory, full.names = TRUE), read.csv)
    output <- do.call(rbind, all_data[id])
    mean(output[,pollutant], na.rm = TRUE)
}
    