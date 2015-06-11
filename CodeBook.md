# Codebook

### Introduction

We have to dataframe that are important, the one answering question 3 and 4 (har.Keep), and the other one who anser question 5 (har.Tidy).

### har.Keep

6 columns:

1. ActivityCode: it's the code of the one of the six activities record. We found the data in the Y_test and Y_train for the code and the labels are in the file Activity_labels
2. SubjectId: It's the identification of the subject (24) who use the wearable computing device. 
3. value: it's the measure record by the wearable computing device. 
4. Activity: The label of the activity (Laying, standing, sitting, waliking, walking_Downstairs and Upstairs)
5. FeatureCode: The code of the type of measure
6. Feature: The description of the type of measure (tBodyAcc-mean()-x, tBodyGyro-std()-Z, etc). As request by question 3, we only retain the ones with mean and standard deviation measure.

### har.Tidy

4 columns (se the description before)

1. Feature
2. Activity
3. SubjectId
4. value
