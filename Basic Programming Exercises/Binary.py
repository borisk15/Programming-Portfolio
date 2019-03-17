# -*- coding: utf-8 -*-
"""
Created on Wed Sep 12 22:13:20 2018

This is a simple program that converts user-inputted binary numbers into decimal numbers

@author: BorisKouambo
"""

import math
binary = input("Please enter a binary number: ")
bin_len = len(binary)
decimal = 0

for i in range(0,bin_len):
    decimal = decimal + (int(binary[-(i+1)]) * math.pow(2,i))

print("The decimal value of " + binary + " is: " + str(decimal))