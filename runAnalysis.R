#############################################################################
# Project for the Coursera "Getting and Cleaning Data" course.
#
# Analyzes Accellerometer data from smartphones from the site:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#############################################################################

#----------------------------------------------------------------------------
# read data sets
#----------------------------------------------------------------------------

subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")

features<-read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[[2]]
activitynames<-read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)[[2]]

# merge data sets. concatenate test and training rows, and add columns for 
# subject and activity. also add descriptive names to data columns.

data<-rbind(xtrain, xtest)
colnames(data)<-features
subject<-rbind(subjecttrain, subjecttest)
activity<-rbind(ytrain, ytest)

data$subject<-subject[[1]]
data$activity<-activity[[1]]

# build new data set with only subject, activity and columns containing mean
# or std
data2<-data[,c("subject", "activity", features[grep("mean|std", features)])]

# convert activities into named factors
data2$activity<-factor(data2$activity, labels=activitynames)

# new dataframe with average of each variable grouped by subject/activity.
tidy<-aggregate(. ~ subject + activity, data2, mean)

# write dataframe to text file
write.table(tidy, file="tidy.txt", row.name=FALSE)
