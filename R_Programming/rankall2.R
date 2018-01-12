rankall2 <- function(outcome, num = "best")  {
        ocm <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
        if (outcome != "heart attack" && outcome != "heart failure" && outcome != "pneumonia") {
             stop("invalid outcome")               ## Check that outcome is valid
        }
        if (is.character(num) == TRUE) {
            if (num != "best" && num != "worst")  { 
              stop("invalid outcome")              ## Check that num is valid
            }
        }
        if (outcome == "heart attack")  outcome_column <- 11   ##subset the desired column 
        if (outcome == "heart failure") outcome_column <- 17   ##from the original 
        if (outcome == "pneumonia")     outcome_column <- 23   ##data file
        mydf <- ocm[c(2, 7, outcome_column)]                   ##assemble the data we need
        names(mydf) <- c("hospital", "state", outcome)
        df_nona <- subset(mydf, mydf[, 3] != "Not Available")  ##remove "Not Available"
        df_nona[, 3] <- as.numeric(df_nona[, 3])               ##Coerce column 3 as. numeric
        if (is.numeric(num) == TRUE)  { 
            ordered_columns <- df_nona[order(df_nona[, 2], df_nona[, 3], df_nona[, 1]), ]
            ordered_columns$rank <- with(ordered_columns, ave(ordered_columns[, 3], ordered_columns[, 2], FUN = seq_along))
            num <- num
            ranked_df <- ordered_columns[ordered_columns[, "rank"] == num, ]
        }
        if (num == "best") {
            ordered_columns <- df_nona[order(df_nona[, 2], df_nona[, 3], df_nona[, 1]), ]
            ordered_columns$rank <- with(ordered_columns, ave(ordered_columns[, 3], ordered_columns[, 2], FUN = seq_along))
            num <- 1  
            ranked_df <- ordered_columns[ordered_columns[, "rank"] == num, ] 
            }
        if (num == "worst") {
            ordered_columns <- df_nona[order(df_nona[, 2], df_nona[, 3], df_nona[, 1], decreasing = TRUE), ]  
            ordered_columns$rank <- with(ordered_columns, ave(ordered_columns[, 3], ordered_columns[, 2], FUN = seq_along))            
            num <- 1
            rev_ranked_df <- ordered_columns[ordered_columns[, "rank"] == num, ] 
            ranked_df <- rev_ranked_df[order(rev_ranked_df[, 2]), ]
        }
        output <- ranked_df[c(1,2)]
        unique_state <- levels(factor(mydf[, 2]))
        to_merge <- data.frame(state = unique_state)
        output2 <- merge(output, to_merge, by.x = "state", by.y = "state", all = TRUE)
        output3 <- output2[, c(2,1)]
        rownames(output3)<- output3$state
        return(output3)                            ## Return a data frame with the hospital names and list of states
        }       