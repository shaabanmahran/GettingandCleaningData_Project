# Apply setwd() to the folder that contains the data as a subfolder named "UCI HAR Dataset" containing the datasets
# Read data, assign column names if necessary
train_data                  <- read.table("UCI HAR Dataset\\train\\X_train.txt")
test_data                   <- read.table("UCI HAR Dataset\\test\\X_test.txt")
f_data                      <- read.table("UCI HAR Dataset\\features.txt")
names(f_data)               <- c("fid", "fname")
activity_train_data         <- read.table("UCI HAR Dataset\\train\\y_train.txt")
names(activity_train_data)  <- c("activity_id")
activity_test_data          <- read.table("UCI HAR Dataset\\test\\y_test.txt")
names(activity_test_data)   <- c("activity_id")
subject_train_data          <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
names(subject_train_data)   <- c("subject")
subject_test_data           <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
names(subject_test_data)    <- c("subject")
activity_lables_data        <- read.table("UCI HAR Dataset\\activity_labels.txt")
names(activity_lables_data) <- c("activity_id", "activity_name")

# merge training and test data
all_data <- rbind(train_data,test_data)

#extract mean features , std features using grep command. then merge them
mean_features <- f_data[grep("mean\\(\\)", f_data$fname) ,]
std_features  <- f_data[grep("std\\(\\)", f_data$fname) ,]
mean_std_features <- rbind(mean_features, std_features)

#subset columns to mean and std columns only, and label them with corresponding names
my_data <- all_data[, mean_std_features$fid]
names(my_data ) <- mean_std_features$fname

#add activity column, subject column
x <- rbind(activity_train_data, activity_test_data)
my_data$activity_id <- unlist(x)
y <- rbind(subject_train_data, subject_test_data)
my_data$subject     <- unlist(y)
#join the data set with the activity labels 
my_data <- merge(my_data, activity_lables_data, by.x="activity_id", by.y="activity_id")


#summarized the data into a new data set
library(reshape2)
my_data2 <- melt(my_data, id=c("activity_id", "activity_name", "subject"))
my_data2 <- dcast(my_data2, activity_id + activity_name + subject ~ variable, mean)

#write.table(my_data2,"my_data2.txt", row.names=FALSE )
