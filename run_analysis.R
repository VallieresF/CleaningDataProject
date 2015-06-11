library(plyr)
library(reshape2)

# reading all the files (training and test)
X_test <- read.table("./data/test/X_test.txt", sep="", header=FALSE)
X_train <- read.table("./data/train/X_train.txt", sep="", header=FALSE)
Y_test <- read.table("./data/test/y_test.txt", sep="", header=FALSE)
Y_train <- read.table("./data/train/y_train.txt", sep="", header=FALSE)
subject_test <- read.table("./data/test/subject_test.txt", sep="", header=FALSE)
subject_train <- read.table("./data/train/subject_train.txt", sep="", header=FALSE)
activities <- read.table("./data/activity_labels.txt", sep="", header=FALSE,
                         colClasses=c("numeric", "character"),
                         col.names=c("ActivityCode", "Activity"))
features <- read.table("./data/features.txt", sep="", header=FALSE,
                       colClasses=c("numeric", "character"),
                       col.names=c("FeatureCode", "Feature"))

# Renaming columns
Y_test <- rename(Y_test, c("V1" = "ActivityCode"))
Y_train <- rename(Y_train, c("V1" = "ActivityCode"))
subject_test <- rename(subject_test, c("V1" = "SubjectId"))
subject_train <- rename(subject_train, c("V1" = "SubjectId"))

# Insert the data for the subject in the Y files to identify each observations
Y_test$SubjectId <- subject_test$SubjectId
Y_train$SubjectId <- subject_train$SubjectId

# integrate the X and Y files for the Test and training
test <- cbind(Y_test)
test <- cbind(test, X_test)
train <- cbind(Y_train)
train <- cbind(train, X_train)

# Integrate the test and training files
har <- rbind(test, train)

# We have 561 variables of measures. They are identify in the Feature file.
# We will retain only the mean and standard deviation in the label of the measure
features$variable <- paste("V", features$FeatureCode, sep="")
toMatch <- c("mean()", "std()")
features$retenir <- grepl(paste(toMatch,collapse="|"), features$Feature)
features.Keep <- subset(features, retenir == TRUE)

# We unpivot the 561 measures to create only one with different feature
har.Unpivot <- melt(har, id=c("ActivityCode", "SubjectId"))

# We add the activity code for each observation (6 differents activities)
har.Unpivot <- merge(har.Unpivot, activities, by = "ActivityCode")

# We retain the measures only for the chosen features (mean and std)
har.Keep <- merge(har.Unpivot, features.Keep, by = "variable")
har.Keep$retenir <- NULL
har.Keep$variable <- NULL

# We aggregate the measures to answer the 5th questions: 
# average by each retain measures (feature) and activities and subject
har.Tidy <- aggregate(formula=value~Feature+Activity+SubjectId, data=har.Keep, FUN=mean)

# Exporting the result for question 5 to text file
write.table(har.Tidy, file = "./data/har.txt", row.names = FALSE)
