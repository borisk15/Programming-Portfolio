# -*- coding: utf-8 -*-
"""
Created on Thu Sep 13 12:51:56 2018

This simple program serves as a simple calculator for the user. The user can input two numbers and 
choose an operation from addition, subtraction, multiplication and division.

@author: BorisKouambo
"""

def addNum(x,y):
    return x+y

def subtractNum(x,y):
    return x-y

def multiplyNum(x,y):
    return x*y

def divideNum(x,y):
    return x/y

print("Option 1 - add\nOption 2 - subtract\nOption 3 - multiply\nOption 4 - divide")

choice = eval(input("Which option would you like to choose (1,2,3,4)?: "))

x = eval(input("Please enter the first number: "))
y = eval(input("Please enter the second number: "))

if choice == 1:
    result = addNum(x,y)
elif choice == 2:
    result = subtractNum(x,y)
elif choice == 3:
    result = multiplyNum(x,y)
elif choice == 4:
    result = divideNum(x,y)
else:
    print("Wrong option! Only 1,2,3, or 4 can be chosen.")
    
print("The result of your operation is: ", result)
