# -*- coding: utf-8 -*-
"""
Created on Fri Sep  7 15:47:34 2018

This program returns the number of characters, words, lines & vowels from a text file. It is a very 
simple program that is meant to work for text files containing strings only. 

@author: BorisKouambo
"""

f = open('input.txt', 'r+')
contents = f.read()

numChar = len(contents)

contentLineSplit = contents.split("\n")
numLines = len(contentLineSplit)

wordList = []
countA = 0
countE = 0
countI = 0
countO = 0
countU = 0

for line in contentLineSplit:
    line = line.strip()
    words = line.split(" ")
    wordList = wordList + words
    countA = countA + line.count('a')
    countE = countE + line.count('e')
    countI = countI + line.count('i')
    countO = countO + line.count('o')
    countU = countU + line.count('u')

numWords = len(wordList)

countVowels = countA + countE + countI + countO + countU

print("The number of characters is: ", numChar)
print("The number of words is: ", numWords)
print("The number of lines is: ", numLines)
print("The number of vowels is: ", countVowels)

f.close()
