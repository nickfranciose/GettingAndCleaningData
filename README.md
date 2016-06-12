# Getting and Cleaning Data - Programming Assignment

The R script, `run_analysis.R` performs the following actions:

1. Downloads the UCI HAR dataset 
2. Loads the activity and feature data
3. Loads train and test datasets, extracting data associated with mean or standard deviation
4. Loads the activity and subject data for each dataset, and merges those columns with the dataset
5. Merges the two datasets
6. Converts the `activity` and `subject` columns into factors
7. Creates a tidy dataset consisting of the (mean) value of each
   variable for each subject and activity pair.
