##Steps to download the data and unzip it, also for reshape2/dplyr are in the README.
##First read in everything you will need:
labels <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")[[1]]
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")[[1]]
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")[[1]]
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")[[1]]

##Now rbind the pieces together vertically:
Xtesttrain <- rbind(Xtest, Xtrain)

##Have to first make ytest, ytrain etc. into data frames. Then concatenate them:
ytest <- data.frame(ytest); ytrain <- data.frame(ytrain)
subjecttest <- data.frame(subjecttest); subjecttrain <- data.frame(subjecttrain)
ytesttrain <- c(ytest[[1]], ytrain[[1]])
subjecttesttrain <- c(subjecttest[[1]], subjecttrain[[1]])

##Apply names to the columns in Xtesttrain:
names(Xtesttrain) <- labels[,2]

##Now stick them all together side-by-side... using cbind is simpler than merge(). 
##Give the activity and participant columns names.
all1 <- cbind(subjecttesttrain, ytesttrain, Xtesttrain)
colnames(all1)[1:2] <- c("participant", "activity_type")

##Use grep() to find only variables that contain -mean() or -std().
meanstd <- c(grep("-std()", colnames(all1), fixed=TRUE), 
             grep("-mean()", colnames(all1), fixed=TRUE))

##Now use order() to put the vector in the proper order:
meanstd <- c(1:2, meanstd[order(meanstd)])

##Subset out the non-desired columns:
all2 <- all1[, meanstd]

##Average out all values having same feature, participant, and activity. Load needed packages and melt the data:
library(reshape2)
library(dplyr)
all3 <- melt(all2, id=c("activity_type", "participant"))

##Replace each group of measurements having the same participant, feature, & activity with the 
##mean of that group (using group_by and summarise to apply the mean):
all4 <- group_by(all3, activity_type, participant, variable)
all5 <- as.data.frame(summarise(all4, mean(value)))

##Prepare a key that can turn the activity numbers into descriptive names, and apply it:
key <- c(1:6)
names(key) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                "SITTING", "STANDING", "LAYING")
all5[,1] <- names(key)[all5[,1]]
colnames(all5)[3:4] <- c("feature", "feature_mean_value")

##Write the resulting file.
write.table(all5, file="./TidyAveragedHARdata.txt", row.name=FALSE)
