#assignment 1
library(readxl)
mydata <- read_excel("Downloads/Data for Weeks 1-5 (4).xlsx", 
                     sheet = "NPS")
View(mydata)
mydata <- read_excel("Downloads/Data for Weeks 1-5 (4).xlsx", sheet = "NPS")

mydata$Analyst <- ifelse(mydata$Personality=="Analyst",1,0)
mydata$Diplomat <- ifelse(mydata$Personality=="Diplomat",1,0)
mydata$Sentinel <- ifelse(mydata$Personality=="Sentinel",1,0)
mydata$Explorer <- ifelse(mydata$Personality=="Explorer",1,0)

Linear_Model = lm(NPS~ Analyst+Sentinel+Explorer+Certificates, data=mydata)
summary(Linear_Model)

predict(Linear_Model, data.frame(Certificates=3, Analyst=1, Sentinel=0, Explorer=0))
predict(Linear_Model, data.frame(Certificates=3, Analyst=0, Sentinel=1, Explorer=0))
predict(Linear_Model, data.frame(Certificates=3, Analyst=0, Sentinel=0, Explorer=1))
predict(Linear_Model, data.frame(Certificates=3, Analyst=0, Sentinel=0, Explorer=0))

predict(Linear_Model, data.frame(Certificates=3, Analyst=0, Sentinel=0, Explorer=0), level=0.95, interval = "confidence")
predict(Linear_Model, data.frame(Certificates=3, Analyst=0, Sentinel=0, Explorer=0), level=0.95, interval = "prediction")

#
#assignment 2
library(readxl)
medata <- read_excel("Downloads/Data for Weeks 1-5 (4).xlsx", 
                     sheet = "RepSalary")
View(medata)

medata = read_excel("Downloads/Data for Weeks 1-5 (4).xlsx", sheet = "RepSalary")

medata$Analyst <- ifelse(medata$Personality=="Analyst",1,0)
medata$Diplomat <- ifelse(medata$Personality=="Diplomat",1,0)
medata$Sentinel <- ifelse(medata$Personality=="Sentinel",1,0)
medata$Explorer <- ifelse(medata$Personality=="Explorer",1,0)

model = lm(Salary~ Age+Feedback+Female+Diplomat+Analyst+Explorer, data=medata)
summary(model)

predict(model, data.frame(Analyst=1, Diplomat=0, Explorer=0, Age=50, Female=0, Feedback=3))
predict(model, data.frame(Analyst=0, Diplomat=1, Explorer=0, Age=50, Female=0, Feedback=3))
predict(model, data.frame(Analyst=0, Diplomat=0, Explorer=1, Age=50, Female=0, Feedback=3))
predict(model, data.frame(Analyst=0, Diplomat=0, Explorer=0, Age=50, Female=0, Feedback=3))

model2 = lm(Salary~ Age+I(Age^2)+Feedback+Female+Diplomat+Analyst+Explorer, data=medata)
summary(model2)

cf = coef(model2); -cf[2]/(2*cf[3])

Female = predict(model2, data.frame(Age=20:60, Female=1, Feedback=3, Diplomat=1, Explorer=0, Analyst=0))
Male = predict(model2, data.frame(Age=20:60, Female=0, Feedback=3, Diplomat=1, Explorer=0, Analyst=0))
plot(20:60, Male, type="l", lwd=1, col="red", xlab = "Age", ylab = "Salary")
lines(20:60, Female, type="l", lwd=1, col="black", xlab = "Age", ylab = "Salary")

model3 = lm(log(Salary)~ Age+I(Age^2)+Feedback+Female+Diplomat+Analyst+Explorer, data=medata)
Predly = predict(model3)
se = sigma(model3)
Predy = exp(Predly+se^2/2)
cor(medata$Salary, Predy)^2
#holdout method
Tdata = midata[1:300,]; Vdata = midata[301:400,]
model4 = lm(Salary~ Age+I(Age^2)+Feedback+Female+Diplomat+Analyst+Explorer, data=Tdata)
summary(model4)
Pred1 = predict(model4, Vdata)
sqrt(mean(Vdata$Salary-Pred1)^2)

model5 = lm(log(Salary)~ Age+I(Age^2)+Feedback+Female+Diplomat+Analyst+Explorer, data=Tdata)
summary(model5)
Pred2 = predict(model5, Vdata)
sqrt(mean(Vdata$Salary-Pred2)^2)



#assignment 3

library(readxl)
mydata <- read_excel("Downloads/Data for Weeks 6-10.xlsx", 
                     sheet = "Discount")
View(mydata)
mydata <- read_excel("Data for Weeks 6-10.xls", sheet = "Discount")
#partial ftest
Model <- lm(Sales ~ Discount+Radio+Newspaper, data=mydata)
summary(Model)
Model2 <- lm(Sales ~ Discount+I(Newspaper+Radio), data=mydata)
summary(Model2)
anova(Model, Model2)


library(readxl)
datamy <- read_excel("Downloads/Data for Weeks 6-10.xlsx", 
                     sheet = "Manager")
View(datamy)
datamy <- read_excel("Data for Weeks 6-10.xlsx", sheet = "Manager")
Model <- lm(Salary ~ Size+Age+Exper+Female, data=datamy)
summary(Model)
#cor means correalation or covariance. We use it to see the covariance between variables 
cor(datamy [,2:5])
Modela <- lm(Size ~ Age+Exper+Female, data=datamy)
summary(Modela)
1/(1-.03309)
Modelb <- lm(Age ~ Size+Exper+Female, data=datamy)
summary(Modelb)
1/(1-.9755)
Modelc <- lm(Exper~ Age+Size+Female, data=datamy)
summary(Modelc)
1/(1-.9755)
Modeld <- lm(Female ~ Size+Age+Exper, data=datamy)
summary(Modeld)
1/(1-0.01183)
# or use 
library(car)
vif(Model)
# we use this to find the multicollinearity. Anything over 5 VIF has sever multicollinearity

Model2 <- lm(Salary ~ Size+Age+Female, data=datamy)
summary(Model2)

Model3 <- lm(Salary ~ Exper+Female+Size, data=datamy)
summary(Model3)
#we use Model 3 because the adjusted R^2 is greater than model2. This means its more preferred.

#assignment 4

library(readxl)
midata <- read_excel("Downloads/Data for Weeks 6-10.xlsx", 
                     sheet = "Score")
View(midata)
midata <- read_excel("Downloads/Data for Weeks 6-10.xls", sheet = "Score")
#DID Treatment
midata$Professor <- ifelse(midata$Professor=="A",1,0)
midata$Period <- ifelse(midata$Period=="Before",1,0)

Model <- lm(Score ~ Professor+Period+I(Professor*Period), data=midata)
summary(Model)
predict(Model, data.frame(Professor=1, Period=1))
predict(Model, data.frame(Professor=0, Period=1))
predict(Model, data.frame(Professor=0, Period=0))
predict(Model, data.frame(Professor=1, Period=1))

78.525-78.6-(79.65-84.15) = 4.425

library(readxl)
medata <- read_excel("Downloads/Data for Weeks 6-10.xlsx", 
                     sheet = "Promotion")
View(medata)
medata <- read_excel("Downloads/Data for Weeks 6-10.xlsx", sheet = "Promotion")
Linear_Model <- lm(Promote ~ Age + Age^2 + Female + Personality + Certificates, data= medata)
summary(Linear_Model)

medata$Analyst <- ifelse(medata$Personality=="Analyst",1,0)
medata$Diplomat <- ifelse(medata$Personality=="Diplomat",1,0)
medata$Sentinel <- ifelse(medata$Personality=="Sentinel",1,0)
medata$Explorer <- ifelse(medata$Personality=="Explorer",1,0)
medata$Promote <- ifelse(medata$Promote=="Thumbs Up",1,0)
LogModel <- glm(Promote ~ Age + I(Age^2) + Female + Analyst+Diplomat+Sentinel + Certificates, family = binomial, data = medata)
summary(LogModel)


predict(LogModel, data.frame(Age=40,Female=0,Analyst=1,Diplomat=0,Sentinel=0,Certificates=3), type = "response")
predict(LogModel, data.frame(Age=40,Female=0,Analyst=0,Diplomat=1,Sentinel=0,Certificates=3), type = "response")
predict(LogModel, data.frame(Age=40,Female=0,Analyst=0,Diplomat=0,Sentinel=1,Certificates=3), type = "response")
predict(LogModel, data.frame(Age=40,Female=0,Analyst=0,Diplomat=0,Sentinel=0,Certificates=3), type = "response")

optimalage
(.0650774/(2*.0006887))
optimalage = 47.24655

predictAnalyst = predict(LogModel, data.frame(Age=20:60,Female=0,Analyst=1,Diplomat=0,Sentinel=0, Certificates=3), type = "response")
predictDiplomat = predict(LogModel, data.frame(Age=20:60,Female=0,Analyst=0,Diplomat=1,Sentinel=0, Certificates=3), type = "response")
predictSentinel = predict(LogModel, data.frame(Age=20:60,Female=0,Analyst=0,Diplomat=0,Sentinel=1, Certificates=3), type = "response")
predictExplorer = predict(LogModel, data.frame(Age=20:60,Female=0,Analyst=0,Diplomat=0,Sentinel=0, Certificates=3), type = "response")
plot(20:60,predictAnalyst,type="l",lwd=.5,col="pink",xlab="Age",ylab="Promotion",ylim=c(0,.5))
lines(20:60,predictDiplomat,type="l",lwd=.5,col="black")
lines(20:60,predictSentinel,type="l",lwd=.5,col="purple")
lines(20:60,predictExplorer,type="l",lwd=.5,col="green")

library(lmtest)
Model2 <- glm(Promote ~ Age+I(Age^2)+Female+Certificates, family = binomial, data = medata)
summary(Model2)
lrtest(LogModel,Model2)

# the lrtest is used between a ligistic model and a model without certain dummy variables in order to do the likelihood ratio test to see if the restriction are invlid or not.


#Midterm 

library(readxl)
midata <- read_excel("Downloads/Data for Midterm (1).xlsx", 
                     sheet = "Salary")
View(midata)
midata = read_excel("Downloads/Data for Midterm (1).xlsx", sheet = "Salary")
#1a

midata$Analyst <- ifelse(midata$Personality=="Analyst",1,0)
midata$Diplomat <- ifelse(midata$Personality=="Diplomat",1,0)
midata$Sentinel <- ifelse(midata$Personality=="Sentinel",1,0)
midata$Explorer <- ifelse(midata$Personality=="Explorer",1,0)

model = lm(Salary ~ Age+Female+Feedback+Analyst+Diplomat+Explorer, data = midata)
summary(model)
#1b
model = lm(Salary ~ Age+Female+Feedback+Analyst+Diplomat+Explorer, data = midata)
summary(model)
model2 = lm(Salary ~ Age+Female+Feedback, data = midata)
summary(model2)
#I am using a goodness of fit measure to comparing model and model2 with one another by their adjusted R squared and their residual standard error

#1c
predict(model, data.frame(Age=50, Female=0, Feedback=3, Analyst=1, Diplomat=0, Explorer=0))
predict(model, data.frame(Age=50, Female=0, Feedback=3, Analyst=0, Diplomat=1, Explorer=0))
predict(model, data.frame(Age=50, Female=0, Feedback=3, Analyst=0, Diplomat=0, Explorer=1))
predict(model, data.frame(Age=50, Female=0, Feedback=3, Analyst=0, Diplomat=0, Explorer=0))

#1d

model3 = lm(Salary ~ Age+Female+Feedback+Analyst+Diplomat+Explorer, data = midata)
summary(model3)
#1e
model4 = lm(Salary ~ Age+I(Age^2)+Female+Feedback+Analyst+Diplomat+Explorer, data = midata)
summary(model4)
cf = coef(model4); -cf[2]/(2*cf[3])

#1f
#goodness of fit by comparing model4 and model5 by their adjusted R squared. Higher R squared means more preferred
model5 = lm(log(Salary) ~ Age+I(Age^2)+Female+Feedback+Analyst+Diplomat+Explorer, data = midata)
summary(model5)
Predly = predict(model5)
se = sigma(model5)
Predy = exp(Predly+se^2/2)
cor(midata$Salary, Predy)^2

#1g

logm = predict(model5, data.frame(Age=50, Feedback=3, Female= 0, Diplomat=1, Analyst=0, Explorer=0))
logf = predict(model5, data.frame(Age=50, Feedback=3, Female=1, Diplomat=1, Analyst=0, Explorer=0))
exp(logm+se^2/2)
exp(logf+se^2/2)

#2a
#holdout method
library(readxl)
midata <- read_excel("Downloads/Data for Midterm (1).xlsx", 
                     sheet = "Rural")
View(midata)
midata <- read_excel("Downloads/Data for Midterm (1).xlsx",  sheet = "Rural")

Tdata = midata[1:60,]; Vdata = midata[61:80,]
model1 = lm(Usage ~ Income+Rural+College, data = Tdata)
summary(model1)
Pred1 = predict(model1, Vdata)
sqrt(mean(Vdata$Usage-Pred1)^2)

model2 = lm(Usage ~ Income+Rural+College+Rural*College, data=Tdata) 
summary(model2)
Pred2 = predict(model2, Vdata)
sqrt(mean(Vdata$Usage-Pred2)^2)



#2b

model1 = lm(Usage ~ Income+Rural+College+Rural*College, data=midata)
predict(model1, data.frame(Income=120, Rural=1, College=1))
predict(model1, data.frame(Income=120, Rural=0, College=1))


#week 10 cross validation with logistic models first paert is using the holdout method
library(readxl)
mydata <- read_excel("Downloads/Data for Weeks 6-10.xlsx", 
                     sheet = "Spam")
View(mydata)
mydata <- read_excel("Downloads/Data for Weeks 6-10.xlsx", 
                     sheet = "Spam")

TData = mydata[1:375,]
VData = mydata[376:500,]
Model1 = glm(Spam ~ Recipients+Hyperlinks+Characters, family=binomial, data=TData)
Pred1 = predict(Model1, VData, type = "response")
Binary1 = round(Pred1); 100*mean(VData$Spam==Binary1)

Model2 = glm(Spam ~ Recipients+Hyperlinks,family=binomial, data=TData)
Pred2 = predict(Model2, VData, type="response")
Binary2 = round(Pred2);100*mean(VData$Spam==Binary2)

Modelf = glm(Spam ~ Recipients+Hyperlinks+Characters, family=binomial, data=mydata)
summary(Modelf)
predict(Modelf, data.frame(Recipients=20, Hyperlinks=5, Characters=60),type="response")
