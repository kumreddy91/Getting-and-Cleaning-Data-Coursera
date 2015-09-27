setwd("A:/Coursera/Getting And Cleaning Data/Course Project/UCI HAR Dataset")
#reading data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt") #table has two columns for index and feature

#1.merge training and test data
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_train,y_test)
subject_data <- rbind(subject_train,subject_test)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
x_data <- x_data[,featuresWanted]
names(x_data) <- features[featuresWanted,2]

#3.according to link y_data numbers represents activity names, we should rename y_data
#with corresponding name

y_data[,1] <- activity_labels[y_data[,1],2]
names(y_data) <- "activities"
all_data <- cbind(subject_data,y_data,x_data)
#head(all_data)

#appropriate labeling

names(all_data)[1] <- "subject"

write.table(all_data, "allData.txt", row.names = FALSE, quote = FALSE)
#independent tidy data set with the average of each variable for each activity
#and each subject.
all_data$activities <- factor(all_data$activities)
all_data$subject <- as.factor(all_data$subject)

# http://seananderson.ca/2013/10/19/reshape.html

allData.molten <- melt(all_data, id = c("subject", "activities"))
allData.mean <- dcast(allData.molten, subject + activities ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)



