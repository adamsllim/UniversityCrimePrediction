#Read in our data set
library(readxl)
uni_stats <- read_excel("C:/Users/neelj/Downloads/University Crime Stats.xlsx")
View(uni_stats)

#Libraries to use SVM and KNN functions
library(e1071)
library(caret)
library(ISLR)
library(MASS)
library(class)

attach(uni_stats)

#Creating a new variable "crime"
#Assign "property crime" if the university's property crime is higher than the median property crime
#Assign "violent crime" if the university's property crime is lower than the median property crime

crime <- ifelse(property_crime > median(uni_stats$property_crime), 
                yes = "property crime", no = "violent crime")

crime <- as.factor(crime)

#Add our new variable "crime" to the data set
uni_stats <- data.frame(uni_stats, crime)
View(uni_stats)


#Split data set into  80% training and 20% testing
n <- nrow(uni_stats)
set.seed(1)
train <- sample(1:n, 0.8*n)
college.train <- uni_stats[train,]
college.test <- uni_stats[-train,]

#Using SVM to predict whether a university has higher property or violent crime
svm.lin <- svm(crime~.,
               data = uni_stats,
               kernel = "linear")

trainerr <- predict(svm.obj, crime)
mean(trainerr != uni_stats$crime)

#Using KNN for predictions
#Data Pre Processing
uni_stats[,2]<-NULL
uni_stats[,1]<-NULL
uni_stats<-na.omit(uni_stats)

#Leave One Out Cross Validation
set.seed(1)

knn.cv.pred <- knn.cv(train = uni_stats[,-12],
                      cl = uni_stats$crime,
                      k=1)
table(knn.cv.pred, uni_stats$crime)
mean(knn.cv.pred != uni_stats$crime)


#Selecting Optimal K Value
for(k in c(1,3,5,10,15,20)) {
  set.seed(1)
  knn.cv.pred <- knn.cv(train = uni_stats[,-12],
                        cl = uni_stats$crime,
                        k=k)
  print(table(knn.cv.pred, uni_stats$crime))
  print(mean(knn.cv.pred != uni_stats$crime))
}
