# -*- coding: utf-8 -*-
"""
Created on Thu Sep 13 11:57:50 2018

This program calculates the cost of going on a holidy based on the cost of accommodation & transport.

@author: BorisKouambo
"""

def hotel_cost(numOfNights):
    price = 1500
    totalCost = price * numOfNights
    return totalCost

def plane_cost(city):
    price = 0
    if city == "Maputo":
        price = 4000
    elif city == "Lagos":
        price = 5000
    elif city == "Nairobi":
        price = 6000
    elif city == "Accra":
        price = 7000
    elif city == "Cairo":
        price = 8000
    else:
        print("We do not have the price of flights to ", city)
    
    return price

def car_rental(numOfDays):
    price = 1000
    totalCost = price * numOfDays
    return totalCost

def holiday_cost(numOfNights, city, numOfDays):
    hotel = hotel_cost(numOfNights)
    plane = plane_cost(city)
    car = car_rental(numOfDays)
    
    totalCost = hotel + plane + car
    return totalCost

print("The total cost of your holiday is: R", str(holiday_cost(10, "Lagos", 9)))
        