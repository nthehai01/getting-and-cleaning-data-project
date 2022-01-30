library(dplyr)


## Load data
X_train <- read.table('./data/train/X_train.txt')
y_train <- read.table('./data/train/y_train.txt')
X_test <- read.table('./data/test/X_test.txt')
y_test <- read.table('./data/test/y_test.txt')


## 1. Merges the training and the test sets to create one data set.
X_train$activity <- y_train
X_test$activity <- y_test
tidyDataset <- rbind(X_train, X_test)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
meanMesurement <- lapply(select(tidyDataset, -activity), mean)
stdMesurement <- lapply(select(tidyDataset, -activity), sd)


## 3. Uses descriptive activity names to name the activities in the data set
activity_labels %<>%  {readLines('./data/activity_labels.txt')} %>% 
    strsplit(" ") %>% 
    sapply(function(ele) ele[2])


## 4. Appropriately labels the data set with descriptive variable names. 
tidyDataset$activity <- sapply(tidyDataset$activity, function(ele) activity_labels[ele])


## 5. From the data set in step 4, creates a second, 
##    independent tidy data set with the average of each variable for each activity and each subject.
grouped <- tidyDataset %>% 
    group_by(activity) %>%
    summarise(across(everything(), list(mean)))

