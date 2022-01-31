# Getting and Cleaning Data Course Project

This is an in-class assignment of [Getting and Cleaning Data Course](https://www.coursera.org/learn/data-cleaning) on Coursera.

## Content

-   The [run_analysis.R](./run_analysis.R) script performing all the analysis

-   This [README.md](./README.md) with all instructions to run the analysis and explainations.

-   The [CodeBook.md](./CodeBook.md) with description of the variables and the transformations performed to clean up the data.

## How to run the analysis

All the needed is in the **run_analysis.R** script. First of all, you are required to install the package called *dplyr* by run this command `install.package("dplyr")` in your R terminal. Then run the analysis script by the following command `source("./run_analysis.R")`.

## How it works

These are the steps followed in the **run_analysis.R** script

1.  Load the dependence (dplyr)

    ```{r}
    library(dplyr)
    ```

2.  Read the **features.txt** in the data folder and remove the index number at the beginning of each feature then store them in the `features` variable.

    ```{r}
    features <- readLines('./data/features.txt')
    features %<>% strsplit(" ") %>% 
        sapply(function(ele) ele[2
    ```

3.  Load the training and testing data with the column names are the stored features.

    ```{r}
    X_train <- read.table('./data/train/X_train.txt', col.names = features)
    y_train <- read.table('./data/train/y_train.txt')
    X_test <- read.table('./data/test/X_test.txt', col.names = features)
    y_test <- read.table('./data/test/y_test.txt')
    ```

4.  Append the activity labels for `X_train` and `X_test` as the new column called *activity.* Then merge `X_train` and `X_test` into one set called `tidyDataset`.

    ```{r}
    ## Add activity column
    X_train$activity <- y_train
    X_test$activity <- y_test

    ## Merge datasets
    tidyDataset <- rbind(X_train, X_test)
    ```

5.  Extract the measurements on the mean and standard deviation for each feature by using the `sapply` function.

    ```{r}
    meanMesurement <- lapply(select(tidyDataset, -activity), mean)
    stdMesurement <- lapply(select(tidyDataset, -activity), sd)
    ```

6.  Read the **activity_labels.txt** in the data folder and remove the index number at the beginning of each feature then store them in the `activity_labels` variable.

    ```{r}
    activity_labels <- readLines('./data/activity_labels.txt')
    activity_labels %<>% strsplit(" ") %>% 
        sapply(function(ele) ele[2])
    ```

7.  In the *activity* column of `tidyDataset`, replace the values with the corresponding labels.

    ```{r}
    tidyDataset$activity <- sapply(tidyDataset$activity, function(ele) activity_labels[ele])
    ```

8.  Group all the records with the same *activity label* into a group and calculate the mean measure for all the features of each group.

    ```{r}
    grouped <- tidyDataset %>% 
        group_by(activity) %>%
        summarise_all(mean)
    ```

9.  Export tidyDataset to csv file.

    ```{r}
    write.csv(tidyDataset,"tidy_dataset.csv", row.names=FALSE)
    ```
