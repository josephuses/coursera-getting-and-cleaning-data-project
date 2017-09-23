# Getting and Cleaning Data - Course Project

The R script, `run_analysis.R` does the following:

1. Downloads, unzips, and stores the data.
2. Loads the information about the activities and measurements, retaining only those that contain information about the means and standard deviations for each measurement.
3. Merges the training and the test sets to create one data set.
4. Uses descriptive activity names to name the activities in the data set.
5. Appropriately labels the data set with descriptive variable names.
6. From the data set in step 5, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
7. Write the data set with the average for each activity to an external file with file name `tidy.txt`.