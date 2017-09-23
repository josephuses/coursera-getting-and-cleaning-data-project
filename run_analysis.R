## load the required packages
library(data.table)
library(dplyr)
library(tidyr)
library(stringr)

## download and unzip the data sets
if(!file.exists("./data")){
  dir.create("./data")
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile="./data/FUCIHARDataset.zip", method = "curl")
  unzip("./data/FUCIHARDataset.zip", exdir = "./data")
}

## Load activity labels and features

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
# Extract all features that contain the strings "mean" and "std"
# removing the patterns "-" and "()" from the measurement names
mean_sd_pattern <- ".*mean.*|.*std.*"
index_mean_sd <- features[,2] %>%
  str_detect(mean_sd_pattern)
features_mean_std <- features[,2] %>% 
  str_subset(mean_sd_pattern) %>% 
  str_replace_all("-|\\(\\)", "")

# Load the datasets

x_train <- fread("./data/UCI HAR Dataset/train/X_train.txt")
x_train <- x_train[ , c(index_mean_sd), with = FALSE]
y_train <- fread("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- fread("./data/UCI HAR Dataset/train/subject_train.txt")

# merge training data set
train <- cbind(subject_train, y_train, x_train)

x_test <- fread("./data/UCI HAR Dataset/test/X_test.txt")
x_test <- x_test[ , c(index_mean_sd), with = FALSE]
y_test <- fread("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- fread("./data/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, y_test, x_test)

# merge datasets and add labels

data <- rbind(train, test)
colnames(data) <- c("subject", "activity", features_mean_std)
data <- data %>% 
  inner_join(activity_labels, by=c("activity"="V1")) %>%
  mutate(activity = tolower(V2), V2 = NULL)

# Convert the data into long format in order to facilitate calculations
long_data <- gather(data, variable, value, -(subject:activity))

# Compute the mean by subject, activity, and features
# then spread back to tidy format
tidy <- long_data %>% 
  group_by( subject, activity, variable) %>% 
  summarise(mean = mean(value)) %>% 
  spread(variable, mean)

# write the output to an external file "tidy.txt"
readr::write_csv(tidy, "tidy.txt")
