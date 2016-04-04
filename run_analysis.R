
resultsfolder <- "results"
if(!file.exists(resultsfolder)){
  print(paste("create results folder: ", resultsfolder))
  dir.create(resultsfolder)
} 

datafolder <- "UCI HAR Dataset"
#read txt and covnert to data.frame
get_table <- function (filename,cols = NULL){
  print(paste("Getting table:", filename))
  f <- paste(datafolder,filename,sep="/")
  data <- data.frame()
  if(is.null(cols)){
    data <- read.table(f,sep="",stringsAsFactors=F)
  } else {
    data <- read.table(f,sep="",stringsAsFactors=F, col.names= cols)
  }
  data
}

#read data and build database
get_data <- function(type, header){
  print(paste("Getting data", type))
  subject_data <- get_table(paste(type,"/","subject_",type,".txt",sep=""))
  y_data <- get_table(paste(type,"/","y_",type,".txt",sep=""))
  x_data <- get_table(paste(type,"/","X_",type,".txt",sep=""))
  return (cbind(subject_data,y_data,x_data))
}

#1) Merges the training and the test sets to create one data set.

train_data <- get_data('train')
test_data <- get_data('test')
data <- rbind(train_data, test_data)
features = get_table('features.txt')
names(data) <- c('subject_id','activities',features[,2])

#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
mean_std_data <- data[,c(1,2,mean_std_indices+2)]

#3) Uses descriptive activity names to name the activities in the data set
activity <- get_table('activity_labels.txt')
labelled_data <- mean_std_data
labelled_data[,2] <- activity[labelled_data[, 2], 2]
#labels <- mean_std_data[, 2]
#for (i in 1: length(lebels)){
#	labels[[i]] <- activity[[c(2,i)]]
#}
#labelled_data[, 2] <- labels

#4) Appropriately labels the data set with descriptive variable names. 
write.table(labelled_data, paste(resultsfolder,"merged_data.txt",sep='/'))

#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

joinSubject <- labelled_data$subject_id
subject_len <- length(table(joinSubject)) # 30
activity_len <- dim(activity)[1] # 6
columnLen <- dim(labelled_data)[2]
result <- matrix(NA, nrow=subject_len*activity_len, ncol=columnLen) 
result <- as.data.frame(result)
colnames(result) <- colnames(labelled_data)
row <- 1
for(i in 1:subject_len) {
    for(j in 1:activity_len) {
        result[row, 1] <- sort(unique(joinSubject))[i]
        result[row, 2] <- activity[j, 2]
        bool1 <- i == labelled_data$subject_id
        bool2 <- activity[j, 2] == labelled_data$activities
        result[row, 3:columnLen] <- colMeans(labelled_data[bool1&bool2, 3:columnLen])
        row <- row + 1
    }
}
head(result)
write.table(result, paste(resultsfolder,"data_with_means.txt",sep='/'))