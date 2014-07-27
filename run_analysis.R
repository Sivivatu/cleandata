####################################################################################
## Preparation step in which all raw data downloaded and read                     ##
## without any transformations. After this step next variables are created:       ##
## trainSubject, trainX, trainY, testSubject, testX, testY,                       ##
## features and activities which correspond data files with similar names         ##
####################################################################################

# Check existence of data in the current directory
# And download and unzip data if necessary
zipFile = "getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(zipFile))
  file.download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zipFile)

dataDir = "UCI HAR Dataset"
if (!file.exists(dataDir))
  unzip(zipFile)

# Read all necessary raw data in a lazy way (only if it is not read yet)
# to speed-up subsequet calls of the script

# Read all training data
if (!exists("trainSubject"))
  trainSubject = read.table(paste0(dataDir, "\\train\\subject_train.txt"), stringsAsFactors = FALSE)

if (!exists("trainX"))
  trainX = read.table(paste0(dataDir, "\\train\\X_train.txt"), stringsAsFactors = FALSE)

if (!exists("trainY"))
  trainY = read.table(paste0(dataDir, "\\train\\y_train.txt"), stringsAsFactors = FALSE)

# Read all test data
if (!exists("testSubject"))
  testSubject = read.table(paste0(dataDir, "\\test\\subject_test.txt"), stringsAsFactors = FALSE)

if (!exists("testX"))
  testX = read.table(paste0(dataDir, "\\test\\X_test.txt"), stringsAsFactors = FALSE)

if (!exists("testY"))
  testY = read.table(paste0(dataDir, "\\test\\y_test.txt"), stringsAsFactors = FALSE)

# Read descriptions of the activities and features
if (!exists("features"))
  features = read.table(paste0(dataDir, "\\features.txt"), stringsAsFactors = FALSE)

if (!exists("activities"))
  activities = read.table(paste0(dataDir, "\\activity_labels.txt"), stringsAsFactors = FALSE)

####################################################################################
## Merging all data from the previous step to a single dataframe "all"            ##
## which has first columns "Subject", "Activity" then 561 numeric-values columns  ##
## with apropriate names from features dataframe.                                 ##
## Data consists from train and test data merged together                         ##
####################################################################################

train = cbind(trainSubject, trainY, trainX)
test = cbind(testSubject, testY, testX)
all = rbind(train, test)

# Assigning miningful column names from file features.txt
# This assignment transforms name strings to correct column name format
# (replacing brackets with dots, for example)
columns = make.names(c("Subject", "Activity", features$V2))
# Removing duplicated dots
columns = sub("\\.{2,}", ".", columns)
# Removing trailing dots
columns = sub("\\.$", "", columns)
names(all) = columns

all = transform(all, Subject = factor(all$Subject))
all = transform(all, Activity = factor(all$Activity, levels = activities$V1, labels = activities$V2))

####################################################################################
## Creating first required dataframe which contains only the measurements on      ##
## the mean and standard deviation for each measurement. For this, selecting      ##
## only columns which name contains ".mean" or ".std"                             ##
## (and "Subject" and "Activity" to distinguish cases).                           ##
## And writing it to "data1.txt"                                                  ##
####################################################################################

data1columns = c("Subject", "Activity", grep("\\.(mean|std)", names(all), value = T))
data1 = all[, data1columns]
write.table(data1, "data1.txt", row.names = FALSE, quote = FALSE)

####################################################################################
## Creating second required dataframe which contains the average of each variable ##
## for each activity and each subject.                                            ##
## And writing it to "data2.txt"                                                  ##
####################################################################################

data2 = aggregate(all[, -c(1, 2)], list(Subject = all$Subject, Activity = all$Activity), mean)
data2 = data2[order(data2$Subject, data2$Activity), ]
write.table(data2, "data2.txt", row.names = FALSE, quote = FALSE)