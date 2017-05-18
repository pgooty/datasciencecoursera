---
title: "codebook.md"
author: "P Gooty"
date: "May 18, 2017"
output: html_document
---

Getting and Cleaning Data Course Project

Instructions for project. The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement.
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names.
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Description of the DATA

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. and the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) - both using a low pass Butterworth filter.

The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).


Description of abbreviations of measurements
1.leading t or f is based on time or frequency measurements.
2.Body = related to body movement.
3.Gravity = acceleration of gravity
4.Acc = accelerometer measurement
5.Gyro = gyroscopic measurements
6.Jerk = sudden movement acceleration
7.Mag = magnitude of movement
8.mean and SD are calculated for each subject for each activity for each mean and SD measurements.

The units given are g's for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.
.tBodyAcc-XYZ
.tGravityAcc-XYZ
.tBodyAccJerk-XYZ
.tBodyGyro-XYZ
.tBodyGyroJerk-XYZ
.tBodyAccMag
.tGravityAccMag
.tBodyAccJerkMag
.tBodyGyroMag
.tBodyGyroJerkMag
.fBodyAcc-XYZ
.fBodyAccJerk-XYZ
.fBodyGyro-XYZ
.fBodyAccMag
.fBodyAccJerkMag
.fBodyGyroMag
.fBodyGyroJerkMag


The set of variables that were estimated from these signals are:
.mean(): Mean value
.std(): Standard deviation


Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


Download the Data

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile= "./data/Dataset.zip")

####Unzip files
unzip(zipfile="./data/Dataset.zip",exdir="./data")

####check what files are in unzipped folder UCI HAR Dataset
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

files  

####Files in folder 'UCI HAR Dataset' that will be used are:

1.SUBJECT FILES
.test/subject_test.txt
.train/subject_train.txt
2.ACTIVITY FILES
.test/X_test.txt
.train/X_train.txt
3.DATA FILES
.test/y_test.txt
.train/y_train.txt

4.features.txt - Names of column variables in the dataTable

5.activity_labels.txt - Links the class labels with their activity name.

Read the data from Activity, Subject and Features files. 
test and train are folders/directories under "UCI HAR Dataset"

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

Read Subject data files

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

Read Features data files.

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#### Check the properties of above variables/columns by using str()

#### Get Activity Variables properties
str(dataActivityTest)
str(dataActivityTrain)

#### Get Subject Variables properties

str(dataSubjectTrain)
str(dataSubjectTest)

Get Features Variables properties

str(dataFeaturesTest)
str(dataFeaturesTrain)

###################################################### 
1) Join the data tables by rows by using rbind

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain,dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain,dataFeaturesTest)

Give names to variables/columns
names(dataSubject)  <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames   <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

###1. Merges the training and the test sets to create one data set.
 Now Merge columns to get the data frame for subject, activity 
 and features 
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Subsetting on Features names by measurements on mean & standard
deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

Subset the data frame on selected names of Features
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

### 3. Uses descriptive activity names to name the activities in the data set
read from activtiy_labels.txt
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

factorize Variable activity in the data frame using descriptive
activity names
Data$activity<- factor(Data$activity);
Data$activity<- factor(Data$activity,labels=as.character(activityLabels$V2))

### 4. Appropriately labels the data set with descriptive variable names.

Label names of features with descriptive variable names.

Replace the following:
prefix t with time
Acc with Accelerometer
Gyro with Gyroscope
prefix f with frequency
Mag with Magnitude
BodyBody with Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and 
each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)





