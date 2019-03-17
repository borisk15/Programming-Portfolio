#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 11 14:50:14 2019

This program executes a simple linear regression algorithm on the diabetes datasets from the sklearn
module. The program defines a custom linear regression function that returns the slope and intercept of
the regression line of best fit, and then implements it on the required training dataset. The resultant 
line is then tested on the test data set. 

@author: boriskouambo
"""
#import statements
import matplotlib.pyplot as plt
import numpy as np
from sklearn.datasets import load_diabetes

#define the linear regression custom function
def Linear_Regression(x, y):
    mu = np.mean
    
    x_mean = mu(x)
    y_mean = mu(y)
    
    #get the equation of the line of best fit by finding the gradient & intercept
    sum_numerator = 0
    sum_denominator = 0
    for x_i,y_i in zip(x,y):
        sum_numerator = sum_numerator + ((x_i - x_mean)*(y_i - y_mean))
        sum_denominator = sum_denominator + ((x_i - x_mean)**2)
    m = sum_numerator/sum_denominator
    b = y_mean - (m*x_mean)
    return m,b

fig = plt.figure()

# load the dataset and divide it into a training and test set
d = load_diabetes()
d_X = d.data[:, np.newaxis, 2]
dx_train = d_X[:-20]
dy_train = d.target[:-20]
dx_test = d_X[-20:]
dy_test = d.target[-20:]

# fit a line of best fit using the linrear regression function
gradient, y_intercept = Linear_Regression(dx_train, dy_train)
fit = gradient * dx_test + y_intercept

# plot the results
plt.scatter(dx_test, dy_test, c='g', label = "Test Data")
plt.scatter(dx_train, dy_train, c='r', label = "Training Data")
plt.plot(dx_test, fit, c='b', label = "Best Fit Line")
plt.legend(loc='upper left')
plt.show()

fig.savefig("LinearRegressionFigure.png")