############################# FINAL PROJECT #############################
#Written by: Adam Mills


#Load in Data
library(readxl)
library(ggplot2)
library(gridExtra)
library(e1071)

University_Crime_Stats <- read_excel("Downloads/University Crime Stats.xlsx")

#Clean Data#--------------------------------------------------------------------------------------------
data = na.omit(University_Crime_Stats) # )
data$State <- as.factor(data$State) #prep state to numeric
#data$State <- as.numeric(data$State) #convert state to numeric


#convert to crime rates 
data$ViolentRate <- data$Violent.crime/data$Student_enrollment
data$PropertyRate <- data$Property.crime/data$Student_enrollment
data$RapeRate <- data$Rape/data$Student_enrollment
data$RobberyRate<- data$Robbery/data$Student_enrollment
data$AssultRate <- data$Aggravated.assault/data$Student_enrollment
data$BurglaryRate<- data$Burglary/data$Student_enrollment
data$LarcenyRate <- data$Larceny.theft/data$Student_enrollment
data$MotorRate<- data$Motor.vehicle.theft/data$Student_enrollment
data$ArsonRate<- data$Arson/data$Student_enrollment


#group decided repsonse variable 
data$CrimeP<- as.factor(ifelse(data$Property.crime>median(data$Property.crime),yes="Property Crime",no="Violent Crime"))
  
#removed NAs 
summary(df) 

#split into crime groups 
P_crime  = na.omit(subset(data, select = -c(1, 3, 5, 6, 7, 8, 9, 10))) #property crimes separated 

V_crime =  na.omit(subset(data, select = -c(1, 3, 5, 10, 11, 12, 13, 14))) #violent crimes separated

major_crimes = na.omit(subset(data, select = -c(1, 3, 6, 7, 8, 9, 11, 12, 13, 14))) #violent and property crimes separated

#data analysis #--------------------------------------------------------------------------------------------
plot(P_crime)

plot(V_crime)

plot(major_crimes)

plot(major_crimes$Violent_crime, major_crimes$Property_crime) #compare two major types of crime 
#-----------------------------------------------------------------------------------------------------------
print('View Data Statistics: Boxplots')
P1 <- ggplot(data, aes(x= "", y=Violent.crime)) + geom_boxplot()
P2 <- ggplot(data, aes(x= "", y=Murder.and..nonnegligent..manslaughter)) + geom_boxplot()
P3 <- ggplot(data, aes(x= "", y=Rape)) + geom_boxplot()
P4 <- ggplot(data, aes(x= "", y=Robbery)) + geom_boxplot()
P5 <- ggplot(data, aes(x= "", y=Aggravated.assault)) + geom_boxplot()
P6 <- ggplot(data, aes(x= "", y=Property.crime)) + geom_boxplot()
P7 <- ggplot(data, aes(x= "", y=Burglary)) + geom_boxplot()
P8 <- ggplot(data, aes(x= "", y=Larceny.theft)) + geom_boxplot()
P9 <- ggplot(data, aes(x= "", y=Motor.vehicle.theft)) + geom_boxplot()
P10 <- ggplot(data, aes(x= "", y=Arson)) + geom_boxplot()
grid.arrange(P1, P6, ncol=2,top="Overall Crimes") #these are the overall ones 
grid.arrange(P2,P3,P4,P5, ncol =2, nrow=2,top = "Violent Crimes") #these are the violent crimes 
grid.arrange( P7,P8,P9,P10, ncol=2, nrow=2, top= "Property Crimes") #these are the theft ones 


#Please select which you would like to use ------------------------------------------------------
# 1 = overall crime rates
# 2 = ALL specific crimes
# 3 = specific violent crime 
# 4 = specific property crime  
# 5 = specific crime rates + state  

I_want_to_use_these_variables <- 2 #change this number depending on what you want 
#leave out 6 there is no murder
if(I_want_to_use_these_variables ==1){
  print('Using Overall Crime:')
  vars.to.use <-colnames(data)[c(  4, 5,10)]
} else if (I_want_to_use_these_variables==2 ){
  print('Using ALL Specific Crimes: ') 
  vars.to.use <- colnames(data)[c(4,  7, 8, 9, 11, 12, 13, 14)]
} else if(I_want_to_use_these_variables == 3){
  print('Using Specific Violent Crime : ')
  vars.to.use <-colnames(data[c( 4, 7, 8, 9)])
} else if(I_want_to_use_these_variables == 4){
  print('Using Specific Property Crime : ')
  vars.to.use <-colnames(data[c(4, 11, 12, 13, 14)])
} else if(I_want_to_use_these_variables == 5){
    print('Using Specific Crime Rates : ')
    vars.to.use <-colnames(data[c(20, 21, 22, 23, 24, 25, 26)])

}

print('Using Variables: ')
vars.to.use

#--------------------------------------------------------------------------------------------

#Make the dataset: 
experiment_data <- data.frame(data[,vars.to.use] , y = as.factor(data$CrimeP))

#don't scale the data
scaled_data <-  experiment_data 
#scale the data: 
#scaled_data <-  data.frame(scale(data[,vars.to.use] ), y = as.factor(data$CrimeP))

#split into train and test sets --------------------------------

# training set
train.index <-  sample(nrow(scaled_data), 0.8*nrow(scaled_data))
scaled_data.train =  experiment_data[ train.index  , ]

# testing set
scaled_data.test =  scaled_data[-train.index , ]


#---------------------- linear ----------------------
set.seed(1)
tune.out = tune(svm, 
                y~., #***change target variable (y) here!!!!!!!
                data = scaled_data.train, 
                kernel = "linear", 
                ranges = list(cost = c(0.01, 0.05, 0.1, 0.5, 1, 10, 15)))
summary(tune.out) 

#train best model: 
svm.fit<-svm(y~., #***change target variable here!!!!!!!
             data = scaled_data.train, 
             kernel='linear', 
             cost=10) #best model parameter <- replace with what is above

#training error: 
svm.pred<-predict(svm.fit, newdata=scaled_data.train)
table(scaled_data.train$y, svm.pred)
mean(svm.pred != scaled_data.train$y)

#test error: 
svm.pred<-predict(svm.fit, newdata=scaled_data.test)
table(scaled_data.test$y, svm.pred)
mean(svm.pred != scaled_data.test$y)

plot(svm.fit, experiment_data, Student_enrollment~Larceny.theft) 
#---------------------- polynomial ----------------------
set.seed(1)
tune.out = tune(svm, 
                y~., #***change target variable (y) here!!!!!!!
                data = scaled_data.train, 
                kernel = "polynomial", 
                ranges = list(cost = c(0.01, 0.05, 0.1, 0.5, 1, 10), 
                              degree = c(1, 2, 3)))
summary(tune.out) 

#train best model: 
svm.fit<-svm(y~., data = scaled_data.train, kernel='polynomial', cost=10, degree=1) 

#training error: 
svm.pred<-predict(svm.fit, newdata = scaled_data.train)
table(scaled_data.train$y, svm.pred)
mean(svm.pred != scaled_data.train$y)

#test error: 
svm.pred<-predict(svm.fit, newdata = scaled_data.test)
table(scaled_data.test$y, svm.pred)
mean(svm.pred != scaled_data.test$y)

plot(svm.fit, experiment_data, Student_enrollment~Larceny.theft) 

#---------------------- radial ----------------------
set.seed(1)
tune.out = tune(svm, 
                y~., #***change target variable (y) here!!!!!!!
                data = scaled_data.train, 
                kernel = "radial", 
                ranges = list(cost = c(0.01, 0.05, 0.1, 0.5, 1, 10), 
                              gamma = c(1, 2, 3)))
summary(tune.out) 

#train best model: 
svm.fit<-svm(y~., data = scaled_data.train, kernel='radial', cost=1, gamma=1) 

#training error: 
svm.pred<-predict(svm.fit, newdata = scaled_data.train)
table(scaled_data.train$y, svm.pred)
mean(svm.pred != scaled_data.train$y)

#test error: 
svm.pred<-predict(svm.fit, newdata = scaled_data.test)
table(scaled_data.test$y, svm.pred)
mean(svm.pred != scaled_data.test$y)

plot(svm.fit, experiment_data, Student_enrollment~Larceny.theft) 

#SVM Analysis on best model ---------------------
#This is the best trained model on the split data

svm.fit<-svm(y~., data = scaled_data.train, kernel='linear', cost=10) 
summary(svm.fit) 

#test on the full dataset
svm.pred<-predict(svm.fit, newdata = experiment_data)
table(experiment_data$y, svm.pred)
mean(svm.pred != experiment_data$y)


# Make plots: 

plot(svm.fit, experiment_data, Student_enrollment~Larceny.theft)

head(svm.fit$SV)


svm.fit$SV
