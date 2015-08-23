==================================================================
Tidying up the "Human Activity Recognition" (HAR) Dataset
==================================================================

The script included in this repo, run_analysis.R, is designed to extract test 
and training data from a study of wearable athletic devices, the "Human Activity 
Recognition Using Smartphones" dataset, by Jorge L. Reyes-Ortiz, Davide Anguita, 
Alessandro Ghio, and Luca Oneto. 

The data for this study was gathered during six different kinds of physical 
activity, as carried out by 30 experimental participants. It is provided in 561 
variables (or features), whose names indicate various types of movement with 
various statistics applied, as X, Y, Z components or Euclidean absolute magnitudes. 

run_analysis.R combines this information, retaining only those features that 
are of the "mean()" or "std()" type. It then averages together those data values 
that correspond to the same combination of physical activity, participant, and 
feature type. These averages are then presented in a new column. 

run_analysis.R outputs a "tidy" representation of the results in a "long" form; 
this essentially gives the averaged feature values as a function of feature, 
participant, and activity type.

If you do not already have the necessary data folder "UCI HAR Dataset" in your 
working directory it can be downloaded and un-zipped there by running these 
commands in R or Rstudio:

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "./UCI HAR Dataset", method="curl")
unzip("./UCI HAR Dataset.zip")
unlink("./UCI HAR Dataset.zip", recursive=TRUE)

run_analysis.R also requires the dplyr and reshape 2 packages, which if needed are easily obtained by running:

install.packages("reshape2"); install.packages("dplyr")

==================================================================
