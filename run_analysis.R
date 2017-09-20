#############################################################################################################################################
#
#                                               GETTING AND CLEAING DATA - WEEK 4 ASSIGNMENT
#
#############################################################################################################################################
# Gerard Mazi
# 09/17/2017

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("~//Coursera/samsung")

# Download and unzip files
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "samsung.zip")
unzip(zipfile = "samsung.zip")

# Load activity labels + features
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")
features = read.table("UCI HAR Dataset/features.txt")

# Extract only the data on mean and standard deviation
target_features = grep(pattern = "*mean*|*std*", x = features[,2])
target_features_names = features[target_features, 2]
target_features_names = gsub(pattern = "-mean", replacement = "Mean", x = target_features_names)
target_features_names = gsub(pattern = "-std", replacement = "Std", x = target_features_names)
target_features_names = gsub(pattern = "[-()]", replacement = "", x = target_features_names)

# Load main datasets and limit by target features
train = read.table("UCI HAR Dataset/train/X_train.txt")[target_features]
train_activities = read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects = read.table("UCI HAR Dataset/train/subject_train.txt")
train = cbind(train_subjects, train_activities, train)

test = read.table("UCI HAR Dataset/test/X_test.txt")[target_features]
test_activities = read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects = read.table("UCI HAR Dataset/test/subject_test.txt")
test = cbind(test_subjects, test_activities, test)

# Merge datasets
all_data = rbind(train, test)
colnames(all_data) = c("subject", "activity", target_features_names)

# Reshape the data and calculate mean for each variable
library(reshape2)
all_data_melt = melt(all_data, id = c("subject", "activity"))
all_data_mean = dcast(all_data_melt, subject + activity ~ variable, mean)

# Publish tidy data
write.table(all_data_mean, "tidy_samsung.txt", row.names = FALSE, quote = FALSE)
