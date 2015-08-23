    ###Cousera Getting and Cleaning Data Programming Assignment
    
    ### information to download file
    url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
    download.file(fileUrl,destfile="./UCI HAR.zip")
    file <- "UCI HAR.zip"
    unzip(file)
    print("Dataset downloaded, proceed to read in the files)
      
    ##loads the train and test datasets in R
    
    ### loading the datasets containing the subject participants - combined_subject
    subject_test <- read.table("test/subject_test.txt")
    subject_train <- read.table("train/subject_train.txt")
    combined_subject <- rbind(subject_train, subject_test)
    colnames(combined_subject) <- "subject"
    
    ### loading the datasets containing the activity of the participants - combined_activity_labels
    y_test <- read.table("test/y_test.txt")
    y_train <- read.table("train/y_train.txt")
    combined_activity <- rbind(y_train, y_test)
    colnames(combined_activity) <- "activity"

    ### loading the datasets containing the variables measured - rbind_df
    x_train <- read.table("train/X_train.txt")
    x_test <- read.table("test/X_test.txt")
    combined_variables <- rbind(x_train, x_test)
    variable_names <- read.table("features.txt")
    colnames(combined_variables) <- as.character(variable_names$V2)

    ### decoding the activity ID numbers and replacing it with descriptive activity names
    combined_activity[,1] <-gsub("1", "walking", combined_activity[,1])
    combined_activity[,1] <-gsub("2", "walking_upstairs", combined_activity[,1])
    combined_activity[,1] <-gsub("3", "walking_downstairs", combined_activity[,1])
    combined_activity[,1] <-gsub("4", "sitting", combined_activity[,1])
    combined_activity[,1] <-gsub("5", "standing", combined_activity[,1])
    combined_activity[,1] <-gsub("6", "laying", combined_activity[,1])

    ### merging the subject and activity variables with the rest of the variables of the experiment
    temp_df <- cbind(combined_activity, combined_variables)
    complete_df <- cbind(combined_subject, temp_df)

    ### selecting the mean and standard deviation variables we need 
    mean_sd_columns <- variable_names$V2[grep("mean\\(\\)|std\\(\\)", variable_names$V2)]
    selected_variables <- c("subject", "activity", as.character(mean_sd_columns))
    selected_df <- subset(complete_df, select = selected_variables)

    ### renaming the column names with descriptive variable names
    names(selected_df) <-gsub("^f", "frequency", names(selected_df))
    names(selected_df) <-gsub("BodyAcc", "BodyAcceleration", names(selected_df))
    names(selected_df) <-gsub("Mag", "Magnitude", names(selected_df))
    names(selected_df) <-gsub("Gyro", "Gyroscope", names(selected_df))
    names(selected_df) <-gsub("GravityAcc", "GravityAcceleration", names(selected_df))

    ## The tidied data
    selected_df
    
    ## Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
    tidy_data <- aggregate(.~subject - activity, selected_df, mean)
    print(tidy_data)
    
    