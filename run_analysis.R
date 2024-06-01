#################################################################
# Cleaning Data project
# The workflow is slightly different from the order of the five project goals
#       - it's not necessary to follow the goals as exact analysis steps. In 
#       real world cases, it's more common to organize the entire dataset first 
#       then subsetting and summarizing, very often colleagues will ask for 
#       follow up after seeing the initial results and you don't have to 
#       repeat the data cleaning steps.

## The workflow is as following:
## > step 1. set environment
## > step 2. read raw data files
## > step 3. tidy up and add labels - note all labels will be carried over to all 
##      subsequent datasets, satisfying Goals 3 and 4.
## > step 4. Merge to a full set - satisfying Goal 1.
## > step 5. Subset the mean and std columns - satisfying Goal 2.
##      Goals 3 and 4 are now natively satisfied.
## > step 6. Create a summary group means - satisfying Goal 5.

### > In-line annotations and codes below.
###############################################################



## > step 1. set environment

# load packages
library(data.table)
library(dplyr)
library(stringr)
library(tidyr)

## > step 2. read raw data files
dir1 <- "UCI HAR Dataset"
dir2te <- "test"
dir2tr <- "train"
if(!dir.exists("output")) dir.create("output")

subject_test <- read.table(file.path(dir1,dir2te,"subject_test.txt"))
X_test <- read.table(file.path(dir1,dir2te,"X_test.txt"))
y_test <- read.table(file.path(dir1,dir2te,"y_test.txt"))

subject_train <- read.table(file.path(dir1,dir2tr,"subject_train.txt"))
X_train <- read.table(file.path(dir1,dir2tr,"X_train.txt")) 
y_train <- read.table(file.path(dir1,dir2tr,"y_train.txt"))

## > step 3. tidy up and add labels

# convert subject from integer class to factor class
subject_test$V1 <- factor(subject_test$V1, levels = 1:30)
subject_train$V1 <- factor(subject_train$V1, levels = 1:30)

# replace the column headers with meaningful words, also replace '-' or ',' 
# with '.'.
names(subject_test) <- "subject"
names(subject_train) <- "subject"
names(y_test) <- "activity"
names(y_train) <- "activity"

features <- read.table(file.path(dir1,"features.txt"))[,2] %>%
        str_replace_all("-|,", ".")
names(X_test) <- features
names(X_train) <- features


# Change y (activity) to factor class with word labels, e.g., 5 = "STANDING". 
# The following lines use activity labels for both value-to-char replacement 
# and setting the factor levels.
word_map <- read.table(file.path(dir1,"activity_labels.txt"))$V2 %>%
        str_replace_all("_", ".")
y_test$activity <- factor(word_map[y_test$activity], levels = word_map)
y_train$activity <- factor(word_map[y_train$activity], levels = word_map)

# Combine columns, and add a new column showing which set they belong to.
testset <- bind_cols(subject_test, "sourceset" = "testset", y_test, X_test)
trainset <- bind_cols(subject_train, "sourceset" = "trainset", y_train, X_train)

# There are 564 columns - the first three are source set, subject, and 
# activity, and the rest columns are numeric measurements relative to g-force.
# final check column names of two datasets are identical, sum should be 0.
sum(names(testset) != names(trainset)) # Just checking


## > step 4. Merge to a full set
# row bind to get the complete set. 
# total 10299 rows - 2947 from testset, 7352 from trainset.

allset <- rbind(testset,trainset)

# turn sourceset to factor
allset$sourceset <- factor(allset$sourceset, levels = c("trainset","testset"))

# Just checking
str(allset)
head(allset[,1:6])

## > step 5. Subset the mean and std columns
# This subset has 3 descriptive columns plus 79 value columns for a total of 82.

# First create a column index vector for column names containing "mean" or "std".
# use str_detect from stringr package for this action.
mean_SD_cols <- str_detect(names(allset), "mean|std")

# Subset the first three descriptive columns and the mean|std columns.
mean_and_SD <- cbind(allset[,c(1:3)],allset[,mean_SD_cols])

# Just checking
str(mean_and_SD)
head(mean_and_SD)
dim(mean_and_SD)


## > step 6. Create a summary group means
# The following codes assume 'dataset' refers to the mean_and_sd subset
# traced back to Goal 2, not the full set in Goal 1. 
# If not, just replace the following mean_and_SD with the allset variable.
dataset <- mean_and_SD

# Create a grouped summary means grouped by the first three columns 

# Also, note that the temporarily created grouped dataframe in the pipe 
# has 3 fewer columns due to the removal of grouping columns. 
# So the summarize(across,...) should either adjust for this index change 
# as below:
### summary_mean <- mean_and_SD %>% group_by(across(1:3)) %>%
###        summarize(across(1:(ncol(mean_and_SD)-3), mean, na.rm = TRUE))

# or just use where(is.numeric) to select
summary_mean <- dataset %>% group_by(subject,sourceset,activity) %>%
        summarize(across(where(is.numeric), mean, na.rm = TRUE))

# Last check. The summary table has 30 subjects * 6 activities == 180 rows. 
# Note that 6 subjects (10,12,13,18,20,24) belong to the testset and 
#      24 subjects (1,3,5-8,11,14-17,19,21-23,25-30) belong to the trainset 
#      without overlap, so essentially grouping by sourceset is unnecessary.
str(summary_mean)
head(summary_mean)
dim(summary_mean)
View(summary_mean[,1:8])

# Save files
write.csv(allset, file = file.path("output","wk4prjAllset.csv"))
write.csv(mean_and_SD, file = file.path("output", "mean and sd.csv"))
write.csv(summary_mean, file = file.path("output", "summary means.csv"))
write.table(summary_mean, file = file.path("output", "summary means.txt"), row.names = FALSE)

