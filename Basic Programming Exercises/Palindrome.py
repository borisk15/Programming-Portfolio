# -*- coding: utf-8 -*-
"""
Created on Wed Sep  5 11:34:57 2018

This program determines whether an inputted string is a palindrome or not.

@author: BorisKouambo
"""

word = input("Please enter a word: ")

check = word[::-1]

if word==check:
    print("Your word is a palindrome")
else:
    print("Your word is not a palindrome")

