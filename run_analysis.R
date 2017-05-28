setwd("C:/Users/Griselda/Desktop/Proyecto/UCI HAR Dataset")
source("leer.R")

#Load activity_labels and fetures
activity_labels<- leer("activity_labels.txt")

#Load features and Extract mean and std
features<- leer("features.txt")
features_wanted<-c(grep("mean",features[,2]),grep("std",features[,2]))
featuresWnames<-as.character(features[features_wanted,2])

#Search files names
files_train<-paste0("./train/",list.files("./train",pattern = "txt"))
files_test<-paste0("./test/",list.files("./test",pattern = "txt"))

#Load train data
X_train<-leer(files_train[2])[features_wanted]
others_train<- lapply(files_train[c(1,3)],leer)
data_train<- cbind(do.call(cbind,others_train),X_train)

#Load test data
X_test<-leer(files_test[2])[features_wanted]
others_test<- lapply(files_test[c(1,3)],leer)
data_test<- cbind(do.call(cbind,others_test),X_test)

#merge datasets and add labels
allData<-rbind(data_train,data_test)
colnames(allData)<-c("subject","activity",featuresWnames)

#subject and activities into factors
allData$subject<-as.factor(allData$subject)
allData$activity<-factor(allData$activity,levels=activity_labels[,1], labels= activity_labels[,2])

#average of each variable for each activity(Act) and each subject(Sub)
by_SubAct<-group_by(allData,activity,subject)

bySubAct.mean<-summarise_each(by_SubAct,funs(mean), vars=3:81)
colnames(bySubAct.mean)<-c("subject","activity",featuresWnames)

#write tidy.txt file
tidy<-write.table(bySubAct.mean,"tidy.txt",row.name = FALSE,col.names=TRUE,sep = " ")

#read tidy.txt into tidy
tidy<-read.table("tidy.txt",header=TRUE)
View(tidy)





