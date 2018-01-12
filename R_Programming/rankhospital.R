rankhospital <- function(state, outcome, num = "best") {
        ## Return hospital name in that state with the given rank 
    data <- data <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", na.string = "Not Available", stringsAsFactors = FALSE)
    mydf <- data[,c(2, 7, 11, 17, 23)]           ## read in the desired data
    states <- unique(mydf[, 2])
    outcomes <- c("heart attack", "heart failure", "pneumonia") ##outcome_name: "heart attack", "heart failure", "pneumonia"
        if ((state %in% states) == FALSE) {      ## check if the state is valid
                stop(print("invalid state"))
        }
        else if ((outcome %in% outcomes) == FALSE) {
                stop(print("invalid outcome"))   ## check if the outcomes is valid
        }
        new_data <- subset(mydf, State == state) ##get the subset of the data with the desired state
        if (outcome == "heart attack") {         
                outcome_column <- 3
        }
        else if (outcome == "heart failure") {   ##get the desired outcome column from the data file
                outcome_column <- 4
        }
        else {
                outcome_column <- 5
        }
        if (is.numeric(num) == TRUE) {
              if(length(new_data[,1]) < num) { ##if num is greater that the number of hospitals in the desired state, return NA
                    return(NA)
            }
        }  
        new_data[, outcome_column] <- as.numeric(new_data[, outcome_column])
        bad <- is.na(new_data[, outcome_column])
        desired_data <- new_data[!bad, ]        ##get rid of the NA's in the desired outcome column
        outcome_column_name <- names(desired_data[outcome_column])
        hospital_column_name <- names(desired_data[1])
        index <- with(desired_data, order(desired_data[outcome_column_name], desired_data[hospital_column_name]))  ##arrange the modified dataframe in ascending order of the outcome values
        ordered_desired_data <- desired_data[index, ]
        if (is.numeric(num) == TRUE) {
                num <- num
        }
        else if (num == "best") {            ##if num is either "best" or "worst", then interpret it to the corresponding numerical value
                num <- 1
        }
        else if (num == "worst") {
                num <- length(ordered_desired_data[, hospital_column_name])
        }
        ordered_desired_data[num, 1]            ##return the hospital name with the outcome ranking of num
}
