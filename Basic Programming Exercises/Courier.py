# -*- coding: utf-8 -*-
"""
Created on Mon Aug 13 12:02:01 2018

@author: BorisKouambo
"""

price = eval(input("Please enter the price of your purchase: "))
distance = eval(input("Please enter the distance of the delivery in Kms: "))

transportMethod = input("Please choose the transportation method (Air or Freight):\n")
insurance = input("Would you like full insurance or limited insurance? For full, answer F, and for limited, answer L\n")
gift = input("Would you like to add a gift? (Y/N)\n")
deliveryType = input("Would you like priority delivery or standard delivery? For priority, answer P and for standard, answer S.\n")

if transportMethod == "Air":
    transportCostPerKm = 0.36
else:
    transportCostPerKm = 0.25

if insurance == "F":
    insuranceCost = 50
else:
    insuranceCost = 25

if gift == "Y":
    giftCost = 15
else:
    giftCost = 0

if deliveryType == "P":
    deliveryTypeCharge = 100
else:
    deliveryTypeCharge = 20


totalPackageCost = price + transportCostPerKm*distance + insuranceCost + giftCost + deliveryTypeCharge

print("The total cost of the package is: ", totalPackageCost)