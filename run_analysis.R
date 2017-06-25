# 1. Downloading and unzipping
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = fileUrl, destfile = "Dataset.zip")
# Unzip dataset
unzip(zipfile = "Dataset.zip")

# 2.Reading files
# Reading trainings tables:
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

#  Assigning column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#  Merging data set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# 3. Extracting one's with mean and standard deviation
#n3.1 Reading column names
colNames <- colnames(setAllInOne)

# VEctor for defining Id, mean, and Standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Making necessary subset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# 4. Using descriptive names for the data

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
# 5. Making second data set
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "TidySet.txt", row.name=FALSE)