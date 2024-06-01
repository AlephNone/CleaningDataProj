
# This is the code book for cleaning data project.

# The raw data is saved in an imput folder 'UCI HAR Dataset'.
# Raw data files are 'activity_labels' describing 6 activities, to be used as a new column.
# 'features' describing 561 measurements, to be used as measurement column labels.
# 'subject_test' is a vector of rows from 6 human subjects, with each row corresponding to y_test and X_test (mentioned below) rows.
# 'y_test' is a vector of rows 6 activities, with each row corresponding to a X_test (mentioned below) row.
# 'X_test' is a headerless dataframe with each column corresponding to a measurement described in the 'features' file.
# 'subject_test', 'y_test', and 'X_test' thus can be reconstructed to a 'testset' with each row representing 561 measurements match a subject~activity combination at a certain timepoint of a time-lapse series.
# A 'trainset' can be similarly reconstructed with 'subject_train', 'y_train', and 'X_train'. There are 24 training subjects, not overlapping testing subjects.

# These raw datasets were first cleaning up by:
# 1. Convert number codes to descriptive words. This includes both column names and non-numeric values.
# 2. Adding column names.
# 3. Changing nonstandard characters ("-", ",","_") to dot (".").
# After tidying up, a full set can then be obtained by combining the testset and the trainset.
# A new datafram 'mean_and_sd' keeping only descriptive columns and measurement columns that contains word 'mean' or 'std' are subsetted from the fullset.
# This subset is then grouped by the three descriptive columns (subject, sourceset, activity). Note that in this particular project since subjects in the trainset and testset do not overlap, it's not necessary to include sourceset for grouping.
# Grouped mean of each columns are summairized in the final table. It contains 180 groups (30 subjects * 6 activities).

# The three datasets are saved in an output folder, and each is further described below:

# wk4prjAllset.csv - 10299 rows * 564 columns
# each row - measurements of a subject for an activity at a given timepoint.
# col 1 - subject, ID of a human subject.
# col 2 - souceset, indicating either testset or trainset the subject belongs to.
# col 3 - activity, one of 6 activities the measurements were taken, e.g., "STANDING", "SITTING".
# col 4-564 - 561 senser measurements and derivatives. e.g., "tBodyAcc.mean().X" meaning total body acceleration mean at X axis. Numeric values represent ratio to the g-force.

# mean and sd.csv - 10299 rows * 82 columns
# rows are exact as in wk4prjAllset.csv file.
# columns includes the first 3 descriptive columns (subject, sourceset, activity) and 79 measurement columns containing phrase 'mean' or 'std'.

# summary mean.csv - 180 rows * 82 columns
# each row is an aggregate (mean) of all time points corresponding to a same subject-sourceset-activity group. There are 30 subjects (6 in testset, 24 in trainset) each with 6 activites.
# columns are identical to those in mean and sd.csv.
