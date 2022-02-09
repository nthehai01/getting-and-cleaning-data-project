library(dplyr)


## Read features
features <- readLines('./data/features.txt')
features %<>% strsplit(" ") %>% 
    sapply(function(ele) ele[2])


## Load data
X_train <- read.table('./data/train/X_train.txt', col.names = features)
y_train <- read.table('./data/train/y_train.txt', col.names = "activity")
subject_train <- read.table("./data/train/subject_train.txt", col.names = "subject")

X_test <- read.table('./data/test/X_test.txt', col.names = features)
y_test <- read.table('./data/test/y_test.txt', col.names = "activity")
subject_test <- read.table("./data/test/subject_test.txt", col.names = "subject")


## 1. Merges the training and the test sets to create one data set.
## Add subject and activity columns
X_train <- cbind(y_train, subject_train, X_train)
X_test <- cbind(y_test, subject_test, X_test)

## Merge datasets
mergedDataset <- rbind(X_train, X_test)


## 2. Extracts only the measurements on the mean 
## and standard deviation for each measurement. 
## Extract the indexes of proper features in 'features' vector
properIndexes <- grep("(?:mean|std)", features)

## Due to the first and second columns in the 'mergedDataset' data frame
## is 'activity' and 'subject', to convert the 'properIndexes' of 'features' vector
## to the indexes in 'mergedDataset', we need to add 2 to each index.
properIndexes.mergedDataset <- properIndexes + 2

## Add indexes of 'activity' and 'subject' columns to 
## the proper column indexes in 'mergedDataset'
properIndexes.mergedDataset <- append(c(1, 2), properIndexes.mergedDataset)

## Extract features 
df <- mergedDataset[, properIndexes.mergedDataset]


## 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- readLines('./data/activity_labels.txt')
activity_labels %<>% strsplit(" ") %>% 
    sapply(function(ele) ele[2])


## 4. Appropriately labels the data set with descriptive variable names. 
df$activity <- sapply(df$activity, 
                      function(ele) activity_labels[ele])


## 5. From the data set in step 4, creates a second, 
##  independent tidy data set with the average of each variable 
##  for each activity and each subject.
tidyDataset <- df %>% 
    group_by(subject, activity) %>%
    summarise_all(mean)


## Export tidy dataset
write.table(tidyDataset,"tidy_dataset.txt", sep = " ", row.names = FALSE)
