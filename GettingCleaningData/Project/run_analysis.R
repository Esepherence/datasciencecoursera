library(reshape)
library(reshape2)
library(plyr)

# Load Test and Train Meta-Data
labels = read.table("UCI HAR Dataset/activity_labels.txt", col.names=c('Activity_Number', 'Activity'))
features = read.table("UCI HAR Dataset/features.txt")

#Load training data and join into a single data frame
subtrain = read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c('Subject'))
xtrain = read.table("UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
ytrain = read.table("UCI HAR Dataset/train/Y_train.txt", col.names=c('Activity_Number'))

train = cbind(subtrain, ytrain, xtrain)
train$set = 'Train'

#Load test data and join into a single data frame
subtest = read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c('Subject'))
xtest = read.table("UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
ytest = read.table("UCI HAR Dataset/test/Y_test.txt", col.names=c('Activity_Number'))

test = cbind(subtest,ytest, xtest)
test$set = 'Test'

#Bind Test and Train date into a single data frame by row
data = rbind(train, test)

#Add descriptive Activity Label
data = merge(data, labels)

#Create Minimal Data Set with Only Mean and SD of Measurements, Ordered by Subject and Activity
mindata = data[order(data$Subject, data$Activity),c(2,565,grep('Mean|std|mean', names(data)))]

#Melt dataframe to facilitate finding averages of activity
melt_min = melt(mindata, id.vars=c('Subject', 'Activity'))
melt_min$Summary_Condition = as.factor(paste(melt_min$Subject, melt_min$Activity, melt_min$variable))
melt_min$Variable_Average = ave(melt_min$value, melt_min$Summary_Condition, FUN=mean)

#Create Tidy dataframe from melted dataframe
Tidy = melt_min[!duplicated(melt_min$Summary_Condition),c('Subject', 'Activity', 'variable', 'Variable_Average')]
names(Tidy)[3] = 'Feature' 
Tidy = dcast(Tidy, Subject + Activity ~ Feature)

#Write Tidy to file with only means
write.table(Tidy,'tidy_summary.txt', row.names=F)
