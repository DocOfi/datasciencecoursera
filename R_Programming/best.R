best <- function(state, outcome) {
  ## Return hospital name in that state with lowest 30-day death rate
  data <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", na.string = "Not Available", stringsAsFactors = FALSE)
  mydf <- data[,c(2, 7, 11, 17, 23)]       ##read in the desired data
  states <- unique(mydf[ , 2])
  outcomes <- c("heart attack", "heart failure", "pneumonia") ##outcome_name: "heart attack", "heart failure", "pneumonia"
  if ((state %in% states) == FALSE) {
    stop(print("invalid state"))     ##check if the state is valid
  }
  else if ((outcome %in% outcomes) == FALSE) {
    stop(print("invalid outcome"))   ##check if the outcomes is valid
  }
  new_data <- subset(mydf, State == state) ##get the subset of the data with the desired state
  if (outcome == "heart attack") {         ##get the desired outcome column from the data file
    outcome_column <- 3
  }
  else if (outcome == "heart failure") {
    outcome_column <- 4
  }
  else {
    outcome_column <- 5
  }
  required_columns <- as.numeric(new_data[,outcome_column])
  bad <- is.na(required_columns)           ##get rid of the NA's in the desired outcome column
  desired_data <- new_data[!bad, ]
  columns_considered <- as.numeric(desired_data[, outcome_column])
  desired_rows <- which(columns_considered == min(columns_considered)) ##find the hospitals in the rows with the minimum outcome value
  desired_hospitals <- desired_data[desired_rows, 1]
  if (length(desired_hospitals) > 1) {      ## if there are multiple hospitals with the minimum outcome value, then
    hospitals_sorted <- sort(desired_hospitals)
    hospitals_sorted[1]               ## return the first hospital name from the alphabetically sorted hospital names list
  }
  else {
    desired_hospitals
  }
}
