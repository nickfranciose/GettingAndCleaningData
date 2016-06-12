library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels and features as variables
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract mean and standard deviation data from X_test/train observations
featuresSubset <- grep(".*mean.*|.*std.*", features[,2])
featuresSubset.names <- features[featuresSubset,2]
featuresSubset.names = gsub('-mean', 'Mean', featuresSubset.names)
featuresSubset.names = gsub('-std', 'Std', featuresSubset.names)
featuresSubset.names <- gsub('[-()]', '', featuresSubset.names)

# Load and bind train datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresSubset]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Load and bind test datasets
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresSubset]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge train, test datasets, add labels
boundData <- rbind(train, test)
colnames(boundData) <- c("subject", "activity", featuresSubset.names)

# turn activities & subjects into factors
boundData$activity <- factor(boundData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
boundData$subject <- as.factor(boundData$subject)

boundData.melted <- melt(boundData, id = c("subject", "activity"))
boundData.mean <- dcast(boundData.melted, subject + activity ~ variable, mean)

write.table(boundData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
