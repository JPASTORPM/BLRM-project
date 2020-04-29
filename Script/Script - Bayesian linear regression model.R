#-------------------------------------------------------------
# Script: Bayesian linear regression model
# Date: 04-28-2020 / dd-mm-yyyy
# Version: 0.1.0
#-------------------------------------------------------------



#-------------------------------------------------------------
# Initial steps
#-------------------------------------------------------------
rm(list = ls()) # Remove all objects
graphics.off()  # Remove all graphics
cat("\014")     # Remove  console scripts
set.seed(2019)
#-------------------------------------------------------------



#-------------------------------------------------------------
# Loading database
#-------------------------------------------------------------
database<-read.table("Data/Database - Leaf area.txt", header=TRUE, sep="\t", dec=".")
str(database)
head(database)
attach(database)
x<-LW; y<-LA; xl<-LW; yl<-LA
#-------------------------------------------------------------



#-------------------------------------------------------------
# Automated Package Installation
#-------------------------------------------------------------
if (!"devtools" %in% installed.packages()[,"Package"]) 
    install.packages("devtools") # install devtools, if it is not installed on your computer

library(devtools)

pkg <- c("brms","broom","coda", "ggplot2", "Metrics")

out <- lapply(pkg, function(y) {
    if (!y %in% installed.packages()[, "Package"]) 
        install.packages(y)
    require(y, character.only = T)
})
#-------------------------------------------------------------



#-------------------------------------------------------------
# MCMC diagnostics: BRMS
#-------------------------------------------------------------
data.brms = brm( LA ~  LW, data = database, 
                 iter = 10000, 
                 warmup = 5000, 
                 chains = 4, 
                 cores= 8,
                 thin = 2, 
                 refresh = 0, 
                 prior = c(prior(normal(0.9, 4), class = "Intercept"),
                           prior(normal(0.7, 4), class = "b"),
                           prior(cauchy(0, 4), class = "sigma")))

print(data.brms)

tidyMCMC(data.brms$fit, conf.int = TRUE, conf.method = "HPDinterval")

mcmc = as.mcmc(data.brms)
plot(mcmc)

raftery.diag(data.brms)

posterior_interval(as.matrix(data.brms), prob = 0.95)
#-------------------------------------------------------------



#-------------------------------------------------------------
# Model validation
#-------------------------------------------------------------
resid = resid(data.brms)[, "Estimate"]
fit = fitted(data.brms)[, "Estimate"]
ggplot() + geom_point(data = NULL, aes(y = resid, x = fit))

resid = resid(data.brms)[, "Estimate"]
fit = fitted(data.brms)[, "Estimate"]
ggplot() + geom_point(data = NULL, aes(y = resid, x = LW))

resid = resid(data.brms)[, "Estimate"]
sresid = resid/sd(resid)
fit = fitted(data.brms)[, "Estimate"]
ggplot() + geom_point(data = NULL, aes(y = sresid, x = fit))

plot(conditional_effects(data.brms), points = TRUE)
#-------------------------------------------------------------



#-------------------------------------------------------------
# Fig.
#-------------------------------------------------------------
mod <- lm(yl ~ xl)
c(mod$coef, sd(mod$residuals))

LA1<-xl*0.7036473 + 1.0966879
LA2<-xl*0.704 + 1.06


plot(yl, LA1, col="blue")
mod1 <- lm(LA1 ~ yl)
summary(mod1)
c(mod1$coef, sd(mod1$residuals))
abline(a=0.5713449, b= 0.9840431, col="blue", lwd=3)
predictions <- predict(mod1, data.frame(LA1))
rmse(yl, predictions)

points(yl, LA2, col="red")
mod2 <- lm(LA2 ~ yl)
summary(mod2)
c(mod2$coef, sd(mod2$residuals))
abline(a=0.514394, b= 0.984536, col="red", lwd=3)
predictions <- predict(mod2, data.frame(LA))
rmse(yl, predictions)

AIC(mod1, mod2)
BIC(mod1, mod2)
#-------------------------------------------------------------
df<-data.frame(database$Cultivar, yl, LA2)
names(df)<-c("Cultivar", "LA_observed", "LA_predicted")
#
pdf(file = "Results/Fig. LA_observed and LA_predicted.pdf", width = 4.5*1, height = 3.75*1)
par(xpd = FALSE,mfrow=c(1,1),mgp = c(1.75,0.5,0), mar = c(3,3,1,2.25))
plot(df$LA_observed[df$Cultivar=="IAC44"], df$LA_predicted[df$Cultivar=="IAC44"], pch=19, cex=1, 
     ylab=expression(paste("Predicted LA (cm", ""^"2", ")")), xlab=expression(paste("Observed LA (cm", ""^"2", ")")), xlim=c(4.6,115.6), ylim=c(4.55,115.6))
points(df$LA_observed[df$Cultivar=="19/08."], df$LA_predicted[df$Cultivar=="19/08."], pch=1, cex=1)
abline(a=0.514394, b= 0.984536, col="black", lwd=2)
text(x=7, y=113, "", cex=1.175)
text(x=90, y=37, expression(paste( "y =  0.5144 + 0.9845x\n"), paste("R"^"2", " = 0.98"," p < 0.0001")))
text(x=90,y=20, expression(paste("AIC =  2849.55\n"), paste("BIC =  2862.55")))
text(x=90, y=13, expression(paste("RMSE = 0.37 cm"^"2")))
dev.off()
#-------------------------------------------------------------
pdf(file = "Results/Fig. LA and LW.pdf", width = 4.5*1, height = 3.75*1)
par(xpd = FALSE,mfrow=c(1,1),mgp = c(1.75,0.5,0), mar = c(3,3,1,2.25))
plot(database$LW[database$Cultivar=="IAC44"], database$LA[database$Cultivar=="IAC44"], pch=19, cex=1, 
     ylab=expression(paste("LA (cm", ""^"2", ")")), xlab=expression(paste("LW (cm", ""^"2", ")")), xlim=c(4.6,170), ylim=c(4.55,115.6))
points(database$LW[database$Cultivar=="19/08."], database$LA[database$Cultivar=="19/08."], pch=1, cex=1)
mod1 <- lm(LA ~ LW, data = database)
summary(mod1)
AIC(mod1)
BIC(mod1)
c(mod1$coef, sd(mod1$residuals))
predictions <- predict(mod1, data.frame(LA))
rmse(database$LA, predictions)
abline(a=1.06, b= 0.704, col="black", lwd=2)
text(x=7, y=113, "", cex=1.175)
text(x=130, y=50, expression(paste("LA =  ",beta["0"]," + ",beta["1"]," LW")))
text(x=130, y=42, expression(paste( "LA =  1.06 + 0.704 LW")))
text(x=130,y=34, expression(paste("R"^"2", " = 0.98"," p < 0.0001")))
text(x=130,y=26, expression(paste("AIC =  2858.04")))
text(x=130, y=18, expression(paste("BIC =  2871.04")))
text(x=130, y=10, expression(paste("RMSE =  3.05 cm"^"2")))
dev.off()
#-------------------------------------------------------------
pdf(file = "Results/Fig. B0.pdf", width = 21, height = 9)
par(xpd = FALSE,mfrow=c(1,1),mgp = c(5,1.5,0), mar = c(25,8,1,0.5))
plot(mcmc[,c(1)], ylab=expression(paste(beta, ""["0"])), cex.lab=3.5, cex.axis=2.5)
dev.off()
#-------------------------------------------------------------
pdf(file = "Results/Fig. B1.pdf", width = 21, height = 9)
par(xpd = FALSE,mfrow=c(1,1),mgp = c(5,1.5,0), mar = c(25,8,1,0.5))
plot(mcmc[,c(2)], ylab=expression(paste(beta, ""["1"])), cex.lab=3.5, cex.axis=2.5)
dev.off()
#-------------------------------------------------------------



#-------------------------------------------------------------
# Reference web
#-------------------------------------------------------------
# [1] Simple linear regression (Bayesian) [WWW Document], 2018. 
#       URL http://www.flutterbys.com.au/stats/tut/tut7.2b.html 
#       (accessed 4.28.20).
#-------------------------------------------------------------

# The end.
