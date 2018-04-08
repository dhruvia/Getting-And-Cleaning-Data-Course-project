file4 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file4, destfile = "./data/proj.zip")
unzip(zipfile = "./data/proj.zip", exdir = "./data")
x_tr <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_tr <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
colnames(x_tr) <- features[,2] 
colnames(y_tr) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_tr, subject_train, x_tr)
mrg_test <- cbind(y_test, subject_test, x_test)
newdat <- rbind(mrg_train, mrg_test)

colNames <- colnames(newdat)

specific_col <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)
changeddat <- newdat[ , specific_col == TRUE]
combActivityNames <- merge(changeddat, activityLabels,
                              by='activityId',
                              all.x=TRUE)
final <- aggregate(. ~subjectId + activityId, combActivityNames, mean)
final <- final[order(final$subjectId, final$activityId),]
write.table(final, "final.txt", row.name=FALSE)
