# Author : Boris Kouambo
# Title  : An Analysis of South African Market Neutral Hedge Funds

data <- read.csv(file="SA Market Neutral.csv", header=TRUE)
View(data)
attach(data)

extradata <- read.csv(file="ExtraData.csv", header=TRUE)
attach(extradata)

#########################    Rearrange the data into another Data Frame - Sheldon Help    ################
View(data)

convertDates <- function(dates) {
  return(
    as.factor(substring(as.character(dates), first=1, last=7))
  )
}

df <- data.frame(
  date = convertDates(data$MktDate), # substring(as.character(data$MktDate), first=1, last=7),
  mktRet = data$MktRet
  # , stringsAsFactors = FALSE
)
str(df)

colnames(data)[colnames(data) %in% c('Date', 'Return')] <- c('Date.0', 'Return.0')

for (i in 0:39) {
  retCol <- paste0("Return.", i)
  datCol <- paste0("Date.", i) 
  mask <- data[, retCol] != ""
  .returns <- as.numeric(sub("%", "", data[mask, retCol]))
  .dates <- convertDates(data[mask, datCol])
  df[df$date %in% .dates, retCol] <- .returns
}
View(df)


###########    table 1    ##########

## Creation of an equally weighted hedge fund index (where the index at time t is
#  just the arithmetic mean of the individual hedge fund returns at time t)

df.hfIndex <- df[,3:42]
hfIndex <- NULL

for (i in 126:249){
  colnums <- length(colnames(df.hfIndex[i, !is.na(df.hfIndex[i,1:40])]))
  x = 0
  for (j in 1:colnums){
    x = x + as.numeric(df.hfIndex[i, !is.na(df.hfIndex[i,1:40])][j])
  }
  hfIndex[i-125] <- x/colnums
}
View(hfIndex)

## Data Frame showing some summary statistics for the HFIndex vs ALSI


mktret <- df[126:249,'mktRet']
autoCor <- acf(mktret)
autoCorhfIndex <- acf(hfIndex)


names = c("Mean", "standard Deviation", "Skewness", "Kurtosis", "Minimum", "Maximum",
          "Autocorrel, lag1", "Autocorrel, lag2")

col1 = round(c(mean(hfIndex), sd(hfIndex), skewness(hfIndex), kurtosis(hfIndex),
               min(hfIndex), max(hfIndex), autoCorhfIndex$acf[2], autoCorhfIndex$acf[3]),
             digits=2)
col2 = round(c(mean(mktret), sd(mktret), skewness(mktret), kurtosis(mktret), 
               min(mktret),max(mktret), autoCor$acf[2], autoCor$acf[3]), digits = 2)

dataframe <- data.frame(
  rownames = names,
  MarketNeutralIndex = col1,
  ALSI = col2
  
)

dataframe


###########  Number of hedge funds in our database over time    ###########
database.size = NULL

for (i in 1:249){
  count = 0
  for (j in 1:40){
    if (!is.na(df.hfIndex[i,j])){
      count = count + 1
    }
  }
  database.size[i] = count
}

start.index = match(1, database.size)
database.size = database.size[start.index:249]

x = as.Date(data$Date.29[1:212])
xyplot(database.size ~ x, type = "l", col = "black", xlab = "Years",
       ylab = "Number of funds", 
       main = " The number of SA Market Neutral hedge funds in our database over time")

#######   Cross-sectional summary statistics    #############

mean_vec <- NULL
sd_vec <- NULL
kurtosis_vec <- NULL
skewness_vec <- NULL
min_vec <- NULL
max_vec <- NULL
nr.obs <- NULL
autoCor.l1 <- NULL
autoCor.l2 <- NULL


for (fund in 0:39) {
  retCol <- paste0("Return.", fund)
  mask <- !is.na(df[, retCol])
  rows <- as.integer(rownames(df)[mask])
  #cat(sprintf("\t%s: %f\n", retCol, cor(df[rows, 'mktRet'], df[rows, retCol])))
  mean_vec[fund+1] <- mean(df[rows, retCol])
  sd_vec[fund+1] <- sd(df[rows, retCol])
  kurtosis_vec[fund+1] <- kurtosis(df[rows, retCol])
  skewness_vec[fund+1] <- skewness(df[rows, retCol])
  min_vec[fund+1] <- min(df[rows, retCol])
  max_vec[fund+1] <- max(df[rows, retCol])
  nr.obs[fund+1] <- length(df[rows, retCol])
  
  autoCor <- acf(df[rows, retCol])
  autoCor.l1[fund+1] <- autoCor$acf[2]
  autoCor.l2[fund+1] <- autoCor$acf[3]
}

mean_vec
sd_vec


###########################     Correlations          ###################################

#mask0 <- !is.na(df[, 'Return.0'])

#rows

cor_vec <- matrix(0,ncol=1,nrow=40)

print("Correlations:")
for (fund in 0:39) {
  retCol <- paste0("Return.", fund)
  mask <- !is.na(df[, retCol])
  rows <- as.integer(rownames(df)[mask])
  cat(sprintf("\t%s: %f\n", retCol, cor(df[rows, 'mktRet'], df[rows, retCol])))
  cor_vec[fund+1] <- cor(df[rows, 'mktRet'], df[rows, retCol])
}

hist(cor_vec, main = " Histogram of hedge fund correlations with the market", 
     xlab = " Correlations ")
summary(cor_vec)

quantile(cor_vec, 0.05)
quantile(cor_vec, 0.95)


#######  bootstrap correlations 95% confidence interval for all funds ########

nsamps <- 1000
lo <- NULL
hi <- NULL

for (i in 0:39){
  retCol <- paste0("Return.", i)
  mask <- !is.na(df[, retCol])
  rows <- as.integer(rownames(df)[mask])
  
  blocklen <- b.star(df[rows, retCol], round=TRUE)[1]
  Bootstrap_samples <-matrix(0, nrow=nsamps, ncol=length(df[rows, retCol]))
  Bootstrap_corrs <- NULL
  
  
  for (j in 1:nsamps){
    if( blocklen <= 1){
      Bootstrap_samples[j,]   = tsbootstrap(df[rows, retCol], type="stationary")
      Bootstrap_corrs[j]   = cor(df[rows, 'mktRet'], Bootstrap_samples[j,])
    }
    else{
      Bootstrap_samples[j,]   = tsbootstrap(df[rows, retCol], type="stationary", b=blocklen)
      Bootstrap_corrs[j]   = cor(df[rows, 'mktRet'], Bootstrap_samples[j,])
    }  
  }
  
  lo[i+1]=quantile(Bootstrap_corrs, 0.025)
  hi[i+1]=quantile(Bootstrap_corrs, 0.975)
  
  #print(c(lo, hi, cor_vec[i]))
  
}

fail.Bootstrap.cor.test <- NULL

for (i in 1:40){
  print(c(lo[i], cor_vec[i], hi[i]))
}


for (i in 1:40){
  #print(c(lo[i], cor_vec[i], hi[i]))
  if(cor_vec[i] < lo[i] || cor_vec[i] > hi[i] ){
    fail.fund <- paste0("Return.", i)
    fail.Bootstrap.cor.test <- append(fail.Bootstrap.cor.test, fail.fund)
  }
}


#####  beta bootstrap 90% confidence interval for all funds  #####

nsamps <- 1000
lo <- NULL
hi <- NULL
beta_vec <- NULL

for (i in 0:39){
  retCol <- paste0("Return.", i)
  mask <- !is.na(df[, retCol])
  rows <- as.integer(rownames(df)[mask])
  
  Data = cbind(df[rows, retCol], df[rows, 'mktRet'])
  
  Boostrap_ints<-NULL
  Boostrap_slopes<-NULL
  
  block.len.mkt <- b.star(df[rows, 'mktRet'], round=TRUE)[1]
  block.len.fund <- b.star(df[rows, retCol], round=TRUE)[1]
  
  for (j in 1:nsamps)
  {
    
    if (block.len.fund > 1  && block.len.mkt >1){
      Y <- tsbootstrap(df[rows, retCol], type="stationary", b=block.len.fund)
      X <- tsbootstrap(df[rows, 'mktRet'], type="stationary", b=block.len.mkt)
    }
    else if(block.len.fund > 1 && block.len.mkt <= 1){
      Y <- tsbootstrap(df[rows, retCol], type="stationary", b=block.len.fund)
      X <- tsbootstrap(df[rows, 'mktRet'], type="stationary")
    }
    else if (block.len.fund <= 1  && block.len.mkt > 1){
      Y <- tsbootstrap(df[rows, retCol], type="stationary")
      X <- tsbootstrap(df[rows, 'mktRet'], type="stationary", b=block.len.mkt)
    }
    else{
      Y <- tsbootstrap(df[rows, retCol], type="stationary")
      X <- tsbootstrap(df[rows, 'mktRet'], type="stationary")
    }
    
    fit <-lm(Y~X)
    
    Boostrap_ints[j]<-  fit$coef[1]
    Boostrap_slopes[j]<-  fit$coef[2]
    
  }
  
  
  lo[i+1] <- quantile(Boostrap_slopes, 0.05)
  hi[i+1] <- quantile(Boostrap_slopes, 0.95)
  
  fund.beta <- lm(df[rows, retCol] ~ df[rows, 'mktRet'])$coefficients[2]
  beta_vec[i+1] = fund.beta
}

fail.Bootstrap.beta.test <- NULL



for (i in 1:40){
  print(c(lo[i], beta_vec[i], hi[i]))
}


for (i in 1:40){
  #print(c(lo[i], cor_vec[i], hi[i]))
  if(beta_vec[i] < lo[i] || beta_vec[i] > hi[i] ){
    fail.fund <- paste0("Return.", i)
    fail.Bootstrap.beta.test <- append(fail.Bootstrap.beta.test, fail.fund)
  }
}


#Linear Regression of all Funds against the Mkt for mean Neutrality via Taylor Polynomial Approx ######
p_vec = NULL
for (fund in 0:39) {
  retCol <- paste0("Return.", fund)
  mask <- !is.na(df[, retCol])
  rows <- as.integer(rownames(df)[mask])
  Y = df[rows, retCol]/100
  X = df[rows, 'mktRet']/100
  X.2 = X^2
  X.3 = X^3
  fit.mean.neutr <- lm(Y ~ X + X.2 + X.3)   ## taylor polynomial approximation
  
  test = wald.test(Sigma = vcov(fit.mean.neutr), 
                   b = fit.mean.neutr$coef, Terms = 2:4)# test whether the betas are zero
  p_vec[fund+1] <- test$result$chi2[3]
  
}                       

fail.mean.test <- NULL
fail.fund <- NULL

for (i in 1:40){
  #print(c(lo[i], cor_vec[i], hi[i]))
  if(p_vec[i] < 0.05){
    fail.fund <- paste0("Return.", i)
    fail.mean.test <- append(fail.mean.test, fail.fund)
  }
}

###  Linear Regression for variance neutrality of all funds via Taylor Approx of true variance ####

p_vec = NULL

for (fund in 0:39) {
  retCol <- paste0("Return.", fund)
  mask <- !is.na(df[, retCol])
  rows <- as.integer(rownames(df)[mask])
  
  Y = df[rows, retCol]/100
  X = df[rows, 'mktRet']/100
  X.2 = X^2
  
  var_vec = NULL
  var_vec[1] = 0
  for (j in 2:length(Y)){
    #var_vec[1] = 0
    var_vec[j] <- var(Y[1:j])
  }
  
  fit.variance.neutr <- lm(var_vec ~ X + X.2)   ## taylor polynomial approximation
  
  test = wald.test(Sigma = vcov(fit.variance.neutr), 
                   b = fit.variance.neutr$coef, Terms = 2:3)# test whether the betas are zero
  p_vec[fund+1] <- test$result$chi2[3]
  
}                       

fail.var.test <- NULL
fail.fund <- NULL

for (i in 1:40){
  #print(c(lo[i], cor_vec[i], hi[i]))
  if(p_vec[i] < 0.05){
    fail.fund <- paste0("Return.", i)
    fail.var.test <- append(fail.var.test, fail.fund)
  }
}


#####   VaR (or quantile) neutrality of Fund86 via test of Christoffersen ####

standardized.returns.86 <- ((ID86_return/100) - mktret86 - mktret.sq86 - mktret.cube86)/(sqrt(((mktret86 + mktret.sq86)^2)))^0.5


value.at.risk<- NULL
value.at.risk[1] <- 0
mkt.value.at.risk <- NULL
mkt.value.at.risk[1] <- 0

mktret86_mean <- NULL
mktret86_sd <- NULL


for (i in 1:length(mktret86)){
  mktret86_mean[i] <- mean(mktret86[1:i])
  mktret86_sd[i] <- sd(mktret86[1:i])
}
mktret86_sd[1] = mean(mktret86_sd)

standardized.mktret86 <- (mktret86 - mktret86_mean)/mktret86_sd

for(i in 2:length(standardized.returns.86)){
  value.at.risk[i] <- VaR(as.xts(zoo(standardized.returns.86[1:i], order.by = d1[1:i])), p=0.9, 
                          method="modified", clean="geltner", portfolio_method = "single", 
                          mu = mean(standardized.returns.86[1:i]),
                          sigma = var(standardized.returns.86[1:i]))
  mkt.value.at.risk[i] <- VaR(as.xts(zoo(standardized.mktret86[1:i], order.by = d1[1:i])), p=0.9, 
                              method="kernel", clean="geltner", portfolio_method = "component", 
                              mu = mean(standardized.mktret86[1:i]),
                              sigma = var(standardized.mktret86[1:i]))
  
  
}

christoff.test.return86 <- standardized.returns.86[standardized.mktret86 <= mkt.value.at.risk]
christoff.test.value.at.risk <- value.at.risk[standardized.mktret86 <= mkt.value.at.risk]

VaRTest(alpha = 0.1, actual = christoff.test.return86, VaR = christoff.test.value.at.risk, conf.level = 0.95)
VaRTest(alpha = 0.1, actual = standardized.returns.86, VaR = value.at.risk, conf.level = 0.95)
unconditional.christoff.test.pvalue <- VaRTest(alpha = 0.1, actual = standardized.returns.86, VaR = value.at.risk, conf.level = 0.95)$uc.LRp
conditional.christoff.test.pvalue <-  VaRTest(alpha = 0.1, actual = christoff.test.return86, VaR = christoff.test.value.at.risk, conf.level = 0.95)$uc.LRp

## fund 86 fails the test for VaR neutrality, but passes the test of downside VaR neutrality


#########   Tail Risk and Tail Neutrality Analysis     ###############
###  Creating a data base to analyse tail risk, where each fund must have at least 24
###  observations

df.hfIndex <- df[,3:42]
tailRiskDataBase <- NULL

for (i in 1:40){
  if (length(na.omit(df.hfIndex[,i])) >= 24){
    tailRiskDataBase = append(tailRiskDataBase, colnames(df.hfIndex)[i])
  }
}

df.tailRisk <- data.frame(mktRet = data$MktRet)

for (fund in tailRiskDataBase){
  df.tailRisk[,fund] <- df.hfIndex[,fund]
}


## Computing the Tail Risk for each individual fund
## tailRisk == 0 implies tailSens == 0, which then means that the fund is market neutral. 
## we find 4 funds are market neutral according to their tail risk
## We choose a 95% confidence level - we can change it to 90% by choosing the 10th quantile
## and finding the 90% Expected Shortfall


tailRisk.overall = NULL
for (fund in tailRiskDataBase){
  retCol <- fund
  mask <- !is.na(df.tailRisk[, retCol])
  rows <- as.integer(rownames(df.tailRisk)[mask])
  fund.return = df.tailRisk[rows, retCol]
  mkt.return = df.tailRisk[rows, 1]
  len = length(fund.return)-25
  
  tailRisk.indiv.fund = NULL
  for (i in 1:len){
    .dates = df[i:(23+i),1]
    
    x = fund.return[i:(23+i)]
    fund_quantile = quantile(x, .05)
    mask.fund = x < fund_quantile
    fund.crash = as.character(.dates[mask.fund])
    
    y = mkt.return[i:(23+i)]
    mkt_quantile = quantile(y, .05)
    mask.mkt = y < mkt_quantile
    mkt.crash = as.character(.dates[mask.mkt])
    
    l = length(.dates[mask.mkt])
    count = 0
    for (j in 1:l){
      if (fund.crash[j] %in% mkt.crash){
        count = count + 1
      }
    }
    
    tailSens = count/l
    CVaR.fund = abs(as.numeric(ETL(x/100, p = 0.95)))
    CVaR.mkt = abs(as.numeric(ETL(y/100, p = 0.95)))
    
    tailRisk = tailSens * CVaR.fund / CVaR.mkt
    tailRisk.indiv.fund[i] = tailRisk
  }
  tailRisk.overall = append(tailRisk.overall, mean(na.omit(tailRisk.indiv.fund)))
  
}

# add avg ES, VaR?

tailRiskMeanVector = NULL
for (fund in tailRiskDataBase){
  tailRiskMeanVector = append(tailRiskMeanVector, mean(na.omit(df.tailRisk[,fund])))
}

xyplot(tailRiskMeanVector ~ tailRisk.overall, xlab = "Tail Risk", 
       ylab = "Average Monthly Return", 
       main = " Mean-TailRisk scatter plot of Hedge Fund Industry", 
       pch = 8, col = "black", cex = 3)

sd_vec = NULL

for (fund in tailRiskDataBase){
  retCol <- fund
  mask <- !is.na(df.tailRisk[, retCol])
  rows <- as.integer(rownames(df.tailRisk)[mask])
  sd_vec <- append(sd_vec, sd(df.tailRisk[rows, retCol]))
}

xyplot(tailRiskMeanVector ~ sd_vec, xlab = "Standard Deviation", 
       ylab = "Average Monthly Return", 
       main = " Mean-Standard Deviation scatter plot of Hedge Fund Industry", 
       pch = 8, col = "black", cex=2)


### Finding the return spread between high and low TailRisk funds

upperTRquantile = quantile(tailRisk.overall, 0.9)
highest.fund.tailRisk = tailRiskDataBase[tailRisk.overall>= upperTRquantile]
lowest.fund.tailRisk = tailRiskDataBase[tailRisk.overall == 0]

mean_highTR = NULL
mean_lowTR = NULL

for (fund in highest.fund.tailRisk){
  mask <- !is.na(df.tailRisk[, fund])
  rows <- as.integer(rownames(df.tailRisk)[mask])
  Xt = df.tailRisk[rows, fund]
  mu = mean(Xt)
  mean_highTR = append(mean_highTR, mu)
}

for (fund in lowest.fund.tailRisk){
  mask <- !is.na(df.tailRisk[, fund])
  rows <- as.integer(rownames(df.tailRisk)[mask])
  Xt = df.tailRisk[rows, fund]
  mu = mean(Xt)
  mean_lowTR = append(mean_lowTR, mu)
}


mean_highTR
mean_lowTR

mean(mean_highTR)
mean(mean_lowTR)

tailRisk_returnSpread = mean(mean_lowTR) - mean(mean_highTR)   #spead = 0.3454219 per month
# = 4.145 per annum 

# Market Neutral funds with the lowest tail risk achieved annual returns 4.145% higher than
# market neutral funds with the highest tail risk. This is in contrast to other literature
# (Agarwal, Ruenzi & Weigert) where funds (avg over all styles) with highest tail risk 
# achieved annual returns 4.8% higher than those with the lowest tail Risk. This is an 
# indication of the fundamental difference in the risk-return characteristics of market 
# neutral hedge funds compared to other types of hedge funds - market neutral hedge funds 
# AIM to achieve returns that are not sensitive to market returns (including market crashes)
# and hence, it makes sense that those Market Neutral Hedge Funds that satisfy this 
# mandate/objective are more profitable than those that do not. 


#########     Granger Causality Analysis (within Hedge Funds) Data Frame    #############

granger.df <- data.frame()

for (i in 0:39){
  
  retCol <- paste0("Return.", i)
  mask <- !is.na(df[134:175, retCol])
  rows <- as.integer(rownames(df[134:175, ])[mask])
  
  if (length(df[rows, retCol]) == 42){
    granger.df[1:42, retCol] = df[rows, retCol]
  }
  
}


######## Granger Causality Test - Continuing from previous section  ########
len <- length(granger.df)
cols <- colnames(granger.df)
granger.pvalues <- data.frame()


for (i in 1:len){
  xCol = cols[i]
  X = granger.df[ , xCol]
  
  for (j in 1:len){
    yCol = cols[j]
    if (i == j){
      granger.pvalues[ i , yCol] = 0
    }  
    else{
      Y = granger.df[ , yCol]
      grang.test = grangertest(Y ~ X, order = 1)
      error.dof = grang.test$Res.Df[1]
      treat.dof = grang.test$Res.Df[2] - grang.test$Res.Df[1]
      f.stat = grang.test$F[2]
      granger.pvalues[ i , yCol] <- pf(q=f.stat, df1=treat.dof, df2= error.dof, lower.tail=FALSE)
    }
  }
}

granger.pvalues = round(granger.pvalues, digits=2)

for (i in 1:len){
  rownames(granger.pvalues)[i] = cols[i]
}


#######  Granger Causality test between Hedge Funds, Banks, Insurance, Fini15 #######

hfIndex.granger <- NULL

for (i in 1:42){
  x = 0
  for (j in 1:15){
    x = x + granger.df[i, j]
  }
  hfIndex.granger[i] <- x/15
}
hfIndex.granger = round(hfIndex.granger, digits = 2)
View(hfIndex.granger)

granger.df.extra <- data.frame(
  HFIndex = hfIndex.granger,
  Banks = ReturnBnks[98:139],
  Insurance = ReturnIns[98:139],
  Fini15 = ReturnFin[98:139]
)


cols <- colnames(granger.df.extra)
granger.extra.pvalues <- data.frame()

for (i in 1:4){
  xCol = cols[i]
  X = granger.df.extra[ , xCol]
  for (j in 1:4){
    yCol = cols[j]
    if (i == j){
      granger.extra.pvalues[ i , yCol] = 0
    }  
    else{
      Y = granger.df.extra[ , yCol]
      grang.test = grangertest(Y ~ X, order = 1)
      error.dof = grang.test$Res.Df[1]
      treat.dof = grang.test$Res.Df[2] - grang.test$Res.Df[1]
      f.stat = grang.test$F[2]
      granger.extra.pvalues[ i , yCol] <- pf(q=f.stat, df1=treat.dof, df2= error.dof, lower.tail=FALSE)
    }
  }
}

granger.extra.pvalues = round(granger.extra.pvalues, digits=2)

for (i in 1:4){
  rownames(granger.extra.pvalues)[i] = cols[i]
}


########  Entire Granger Analysis for period July 2012 to Dec 2015  ############

granger.df.new <- data.frame()

for (i in 0:39){
  
  retCol <- paste0("Return.", i)
  mask <- !is.na(df[206:247, retCol])
  rows <- as.integer(rownames(df[206:247, ])[mask])
  
  if (length(df[rows, retCol]) == 42){
    granger.df.new[1:42, retCol] = df[rows, retCol]
  }
  
}



len <- length(granger.df.new)
cols <- colnames(granger.df.new)
granger.new.pvalues <- data.frame()


for (i in 1:len){
  xCol = cols[i]
  X = granger.df.new[ , xCol]
  
  for (j in 1:len){
    yCol = cols[j]
    if (i == j){
      granger.new.pvalues[ i , yCol] = 0
    }  
    else{
      Y = granger.df.new[ , yCol]
      grang.test = grangertest(Y ~ X, order = 1)
      error.dof = grang.test$Res.Df[1]
      treat.dof = grang.test$Res.Df[2] - grang.test$Res.Df[1]
      f.stat = grang.test$F[2]
      granger.new.pvalues[ i , yCol] <- pf(q=f.stat, df1=treat.dof, df2= error.dof, lower.tail=FALSE)
    }
  }
}

granger.new.pvalues = round(granger.new.pvalues, digits=2)

for (i in 1:len){
  rownames(granger.new.pvalues)[i] = cols[i]
}


hfIndex.new.granger <- NULL

for (i in 1:42){
  x = 0
  for (j in 1:13){
    x = x + granger.df.new[i, j]
  }
  hfIndex.new.granger[i] <- x/13
}
hfIndex.new.granger = round(hfIndex.new.granger, digits = 2)
View(hfIndex.new.granger)

granger.df.new.extra <- data.frame(
  HFIndex = hfIndex.new.granger,
  Banks = ReturnBnks[170:211],
  Insurance = ReturnIns[170:211],
  Fini15 = ReturnFin[170:211]
)


cols <- colnames(granger.df.new.extra)
granger.new.extra.pvalues <- data.frame()

for (i in 1:4){
  xCol = cols[i]
  X = granger.df.new.extra[ , xCol]
  for (j in 1:4){
    yCol = cols[j]
    if (i == j){
      granger.new.extra.pvalues[ i , yCol] = 0
    }  
    else{
      Y = granger.df.new.extra[ , yCol]
      grang.test = grangertest(Y ~ X, order = 1)
      error.dof = grang.test$Res.Df[1]
      treat.dof = grang.test$Res.Df[2] - grang.test$Res.Df[1]
      f.stat = grang.test$F[2]
      granger.new.extra.pvalues[ i , yCol] <- pf(q=f.stat, df1=treat.dof, df2= error.dof, lower.tail=FALSE)
    }
  }
}

granger.new.extra.pvalues = round(granger.new.extra.pvalues, digits=2)

for (i in 1:4){
  rownames(granger.new.extra.pvalues)[i] = cols[i]
}


#######  Constructing a vector of ACFs  #########


acf_vec <- NULL


for (i in 2:length(ID86_return)){
  
  y.acf = acf(ID86_return[1:i], plot = FALSE)
  acf_vec[i-1] <- y.acf$acf[2]
}

ts.plot(acf_vec)


#######  Case Study of Fund 209     #####
# Exploratory Data Analysis

summary(ID209_return)

# Neutrality

# Correlation Neutrality

nsamps <- 1000
lo <- NULL
hi <- NULL

retCol <- "Return.29"
mask <- !is.na(df[, retCol])
rows <- as.integer(rownames(df)[mask])

blocklen <- b.star(df[rows, retCol], round=TRUE)[1]
Bootstrap_samples <-matrix(0, nrow=nsamps, ncol=length(df[rows, retCol]))
Bootstrap_corrs <- NULL

for (j in 1:1000){
  if( blocklen <= 1){
    Bootstrap_samples[j,]   = tsbootstrap(df[rows, retCol], type="stationary")
    Bootstrap_corrs[j]   = cor(df[rows, 'mktRet'], Bootstrap_samples[j,])
  }
  else{
    Bootstrap_samples[j,]   = tsbootstrap(df[rows, retCol], type="stationary", b=blocklen)
    Bootstrap_corrs[j]   = cor(df[rows, 'mktRet'], Bootstrap_samples[j,])
  }  
}

lo=quantile(Bootstrap_corrs, 0.025)
hi=quantile(Bootstrap_corrs, 0.975)

.cor = cor(df[rows, 'mktRet'], df[rows, retCol] )

if(.cor < lo || .cor > hi){
  print("Fund 209 fails the test of correlation neutrality")
}

# fails the test


## Mean Neutrality


Y = df[rows, retCol]/100
X = df[rows, 'mktRet']/100
X.2 = X^2
X.3 = X^3
fit.mean.neutr <- lm(Y ~ X + X.2 + X.3)   ## taylor polynomial approximation

test = wald.test(Sigma = vcov(fit.mean.neutr), 
                 b = fit.mean.neutr$coef, Terms = 2:4)# test whether the betas are zero

mean.neutr.pval = test$result$chi2[3]

if(mean.neutr.pval < 0.05){
  print("Fund 209 fails test of mean neutrality")
}


## variance neutr

p_vec = NULL
test = NULL
var_vec = NULL
var_vec[1] = 0
for (j in 2:length(Y)){
  #var_vec[1] = 0
  var_vec[j] <- var(Y[1:j])
}

fit.variance.neutr <- lm(var_vec ~ X + X.2)   ## taylor polynomial approximation

test = wald.test(Sigma = vcov(fit.variance.neutr), 
                 b = fit.variance.neutr$coef, Terms = 2:3)# test whether the betas are zero
p_vec <- test$result$chi2[3]

if(p_vec < 0.05){
  print("Fund 209 fails test of mean neutrality")
}


#Value at risk was shown to fail 


# Other general statistics and Risk Measures

fit = lm(Y ~ X)
summary(fit)
res <- residuals(fit)
jarque.bera.test(res)  # very much non normal

table.DownsideRisk(as.xts(zoo(Y, order.by = d30), dateFormat = 'Date'), scale=12, Rf=0)


chart.CumReturns(zoo(Y, order.by = d30), wealth.index=TRUE)

chart.RelativePerformance(Ra = as.xts(zoo(Y, order.by = d30)), 
                          Rb = as.xts(zoo(X, order.by = d30)))

chart.BarVaR(zoo((Y), order.by = d30), methods = c("ModifiedES", "HistoricalES"),
             width=0, p=0.95)               ###can be a data frame here
table.CAPM(Ra = as.xts(zoo(Y, order.by = d30)), 
           Rb = as.xts(zoo(X, order.by = d30)))



# Systemic Risk

y <- setar(ID209_return, m=3, mTh= c(0.8,0.15,0.05))
str(y)
plot(y)
y$coefficients
#setarTest(ID209_return, m=3, series = "Fund 86", nboot=100, test = "2vs3")
#autopairs(as.ts(ID209_return), lag=1, type="regression")
#auautopairs(as.ts(ID209_return), lag=2, type="regression")
#autopairs(as.ts(ID209_return), lag=3, type="regression")
#autopairs(as.ts(ID209_return), lag=4, type="regression")

#fund86.setar.model <- setar(fund.86, m=3, mTh = c(0.8, 0.15, 0.05))

y$model.specific$RegProp
ID209_return[y$model.specific$regime==1]
ID209_return[y$model.specific$regime==2]
summary(ID209_return[y$model.specific$regime==1])
summary(ID209_return[y$model.specific$regime==2])
sd(!is.na(ID209_return[y$model.specific$regime==1]))
sd(!is.na(ID209_return[y$model.specific$regime==2]))

# remember to find summary statistics for each regime and tabulate
# look at the different levels of volatility in these two states



lowReg.probs <- NULL

for (i in 36:length(ID209_return)){
  x <- ID209_return[1:i]
  fund.setar <- setar(x, m=3, mTh= c(0.8,0.15,0.05))
  lowReg.probs[i-35] <- fund.setar$model.specific$RegProp[1]
}

ts.plot(lowReg.probs)

