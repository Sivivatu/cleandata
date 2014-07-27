cleandata
=========

Getting and Cleaning Data course project

This repository contains next files:

* *README.md* - this file which describes this repository
* *CodeBook.md* - a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data
* *run_analysis.R* - a script which performs data transformations
* *data1.txt* - first data set produced by run_analysis.R and described in more details in the code book
* *data2.txt* - second data set produced by the script

run_analysis.R doesn't require anything for its work. It downloads and unpacks all necessary data from [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
if it doesn't exist yet. Then it reads the data, transforms it in the following way:

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

And saves these 2 data sets into data1.txt and data2.txt files in the current directory.