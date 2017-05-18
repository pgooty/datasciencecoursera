#######################################################################
# You should create one R script called run_analysis.R that does the 
# following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation
#    for each measurement.
# 3. Uses descriptive activity names to name the activities in the 
#    data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy 
#    data set with the average of each variable for each activity and 
#    each subject.
########################################################################

# Download the data files
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile= "./data/Dataset.zip")

#Unzip files
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# check what files are in unzipped folder UCI HAR Dataset
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
# recursive shows the list ofunderlying directories/files
files  
#
# Read the data from Activity, Subject and Features files 
# Read Activity data files # test and train are folders/directories
# under "UCI HAR Dataset"
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

# Read Subject data files

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

# Read Features data files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# Check the properties of above variables/columns by using str()

# Get Activity Variables properties
str(dataActivityTest)
str(dataActivityTrain)

# Get Subject Variables properties

str(dataSubjectTrain)
str(dataSubjectTest)

# Get Features Variables properties

str(dataFeaturesTest)
str(dataFeaturesTrain)

###################################################### 
# 1) Now join the data tables by rows by using rbind

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain,dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain,dataFeaturesTest)

# Give names to variables/columns
names(dataSubject)  <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames   <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

# 1. Merges the training and the test sets to create one data set.
# Now Merge columns to get the data frame for subject, activity 
# and features 
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# 2. Extracts only the measurements on the mean and standard deviation
#    for each measurement.
# Subsetting on Features names by measurements on mean & standard
# deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# Subset the data frame on selected names of Features
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

# 3. Uses descriptive activity names to name the activities in the 
#    data set
# read from activtiy_labels.txt
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#factorize Variable activity in the data frame using descriptive
#activity names
Data$activity<- factor(Data$activity);
Data$activity<- factor(Data$activity,labels=as.character(activityLabels$V2))

# 4. Appropriately labels the data set with descriptive variable names.
# Label names of feaures with descriptive variable names

# Replace the following:
# prefix t with time
# Acc with Accelerometer
# Gyro with Gyroscope
# prefix f with frequency
# Mag with Magnitude
# BodyBody with Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

# 5. From the data set in step 4, creates a second, independent tidy 
#    data set with the average of each variable for each activity and 
#    each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


