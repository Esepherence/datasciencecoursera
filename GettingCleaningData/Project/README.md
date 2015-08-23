# Getting and Cleaning Data Project

#run_analysis.R

Raw data from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The .zip file should be unzipped and within the working directory e.g.('cwd/UCI HAR Dataset').

run_analysis.R loads both the training set and testing set of data and joins them into a single data set (data).

data is the complete data set with descriptive feature header names and the activities mapped out.

mindata is created by only extracting the features relating to means and standard deviations.

Using mindata, the dataframe is melted and averages are formed for every combination of Subject, Activity, and Feature Mean/SD.

This is cast back into a dataframe (Tidy) which is written to file within the working directory.

