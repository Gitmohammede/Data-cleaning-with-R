## This is a Coursera Project Assignment from Getting and Cleaning Data Course Project. 
## Creating a script which does the following:
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Loading required library

library(dplyr)

# Set Directory path

path = "C:\\Users\\Abhinav Khandelwal\\OneDrive\\Desktop\\R_project\\R_Learning_Coursera\\getdata_projectfiles_UCI HAR Dataset"

# Loading features,activities and train files on R

features = read.table(paste0(path,"\\features.txt"),col.names = c("N","Features"))
activities = read.table(paste0(path,"\\activity_labels.txt"),col.names = c("Code","Activity"))
subject_train = read.table(paste0(path,"\\train\\subject_train.txt"),col.names = "Subjects")
activity_train = read.table(paste0(path,"\\train\\y_train.txt"),col.names = "Code")
value_train = read.table(paste0(path,"\\train\\X_train.txt"))
colnames(value_train) = features$Features


# Loading test files on R
subject_test = read.table(paste0(path,"\\test\\subject_test.txt"),col.names = "Subjects")
activity_test = read.table(paste0(path,"\\test\\y_test.txt"),col.names = "Code")
value_test = read.table(paste0(path,"\\test\\X_test.txt"))
colnames(value_test) = features$Features

# Merge Train and Test Data Frames

Train_Data = cbind(subject_train,activity_train,value_train)
Test_Data = cbind(subject_test,activity_test,value_test)
Merged_Data = rbind(Train_Data,Test_Data)

# Extracting features containing mean and standard deviation for each measurement

Merged_Data = select(Merged_Data,Subjects,Code,contains("mean"),contains("std"))

# Assigning descriptive names to name the activities in the data set

Tidy_data = merge(activities,Merged_Data,by.x = "Code",by.y = "Code")
Tidy_data = select(Tidy_data,-Code)
Tidy_data = select(Tidy_data,Subjects, Activity, contains("mean"),contains("std"))

# Labeling the data set with descriptive variable names

names(Tidy_data) = gsub("t[Bb]ody","TimeBody",names(Tidy_data))
names(Tidy_data) = gsub("BodyBody","Body",names(Tidy_data))
names(Tidy_data) = gsub("Acc","Accelerometer",names(Tidy_data))
names(Tidy_data) = gsub("^t","Time",names(Tidy_data))
names(Tidy_data) = gsub("Gyro","Gyroscope",names(Tidy_data))
names(Tidy_data) = gsub("Mag","Magnitude",names(Tidy_data))
names(Tidy_data) = gsub("[Ff]req","Frequency",names(Tidy_data))
names(Tidy_data) = gsub("^f","Frequency",names(Tidy_data))
names(Tidy_data) = gsub("angle","Angle",names(Tidy_data))
names(Tidy_data) = gsub("gravity","Gravity",names(Tidy_data))
names(Tidy_data) = gsub("-std",".STD",names(Tidy_data))
names(Tidy_data) = gsub("-mean",".Mean",names(Tidy_data))
names(Tidy_data) = gsub("//()","...",names(Tidy_data))
names(Tidy_data) = gsub("-","",names(Tidy_data))


# Creating second, independent tidy data set with the average 
# of each variable for each activity and each subject.

final_tidy_data = Tidy_data %>% group_by(subjects,activity) %>% summarise_all(.funs = mean)


## Save the file locally

# Create a directory to store the output file.

dir.create(paste0(path,"\\tidy_data"))

# Saving the file
write.table(summarised_data,paste0(path,"\\tidy_data\\final_tidy_data"),row.names = FALSE)


