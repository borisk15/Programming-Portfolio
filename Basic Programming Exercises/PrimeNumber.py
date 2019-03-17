# -*- coding: utf-8 -*-
"""
Created on Wed Sep  5 00:41:41 2018

This program determines whether an inputted integer is a prime number or not

@author: BorisKouambo
"""
mylist=[]
num = eval(input("Please enter an integer: "))

while num<=1:
    num = eval(input("Please enter an integer (only integers above 1 are allowed): "))
    
for i in range(2,num):
    if (num%i)==0:
        mylist.append(i)

if (len(mylist)>=1):
    print(str(num)+" is not a prime number")
else:
    print(str(num)+" is a prime number!")