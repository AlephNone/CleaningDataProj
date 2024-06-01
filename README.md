
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