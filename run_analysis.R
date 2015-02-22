run_analysis <- function() {
    # Install dependencies and obtain the DataSet
    loadDependencies()
    cat("Obtaining the data set\n")
    if(!file.exists("./data")){dir.create("./data")}
    if(!file.exists("./data/Dataset.zip")){
        cat("Data Set not found. Downloading...")
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        ret = bdown(fileUrl, "./data/Dataset.zip")
    }
    cat("Unzipping DataSet...\n")
    old_dir = getwd(); setwd("./data")  
    unzip("Dataset.zip", overwrite = TRUE)
    setwd(old_dir)
    
    # Merge Training and Test datasets
    cat("Merging Training and Test Sets...\n")
    test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
    test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
    test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
    
    train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
    train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
    train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
    
    subject_set <- rbind(train_subject, test_subject)
    x_set <- rbind(train_x, test_x)
    y_set <- rbind(train_y, test_y)
    
    cat("Merge completed.\n")
    # Assign Column Names
    cat("Assigning column names...\n")
    features <- read.table("./data/UCI HAR Dataset/features.txt")
    names(x_set) <- features$V2
    names(y_set) <- "Activity"
    names(subject_set) <- "Subject"
   
    # Extract Measurements of Mean and Standard deviation
    cat("Extracting measurements of mean and standard deviation...\n")
    mean_cols <- matchcols(x_set, with=c("mean"), without=c("meanFreq"))
    std_cols  <- matchcols(x_set, with=c("std"))
    new_cols <- c(mean_cols, std_cols)
    x_sub_set <- subset(x_set, select=new_cols)
    
    # Use descriptive activity names to map the Activity value
    cat("Mapping Activity values...\n")
    activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
    activity_int_as_char <- as.character(activity_labels$V1)
    activity_factor_as_char <- as.character(activity_labels$V2)
    y_set$Activity <- mapvalues(as.character(y_set$Activity), from = activity_int_as_char, to = activity_factor_as_char)
    
    # Create DataSet
    cat("Creating DataSet and writing it to file...\n")
    dataSet <- cbind(y_set, subject_set, x_sub_set)
    write.table(dataSet, file="./data/result_step_4.txt", row.name=FALSE)
    
    # Create and Print a new tidy DataSet
    cat("Creating DataSet with summarised data and writing it to file...\n")
    dataSet2 <- dataSet %>% group_by(Activity, Subject) %>% summarise_each(funs(mean(., na.rm=TRUE)), 3:ncol(dataSet))
    write.table(dataSet2, file="./data/result_step_5.txt", row.name=FALSE)
    
    data.frame(dataSet2)
}

## HELPER Methods

# Method to pull the file from the Web in a more efficient way.
bdown <- function(url, file){
    f = CFILE(file, mode="wb")
    a = curlPerform(url = url, writedata = f@ref, noprogress=FALSE)
    close(f)
    return(a)
}

# Install Dependencies only if they are not installed on the system
installDependencies <- function(){
    list_of_packages <- c('plyr', 'dplyr', 'RCurl', 'gdata')
    new_packages <- list_of_packages[!(list_of_packages %in% installed.packages()[,'Package'])]
    if(length(new_packages)) install.packages(new_packages)
}

# Load required dependencies
loadDependencies <- function(){
    installDependencies()
    library('plyr')
    library('dplyr')
    library('RCurl')
    library('gdata')
}
