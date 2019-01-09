inputFile = open('input.txt', 'r')
boxIds = inputFile.read().split('\n')
boxIds.pop(-1)

boxIdsContains2Count = 0
boxIdsContains3Count = 0
alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

for boxId in boxIds:
    lettersCount = {}
    for letter in alphabet:
        lettersCount[letter] = 0

    for char in boxId:
        lettersCount[char] += 1

    boxIdContains2 = False
    boxIdContains3 = False

    for letter in alphabet:
        letterCount = lettersCount[letter]
        if letterCount == 2:
            boxIdContains2 = True
        if letterCount == 3:
            boxIdContains3 = True

    if boxIdContains2:
        boxIdsContains2Count += 1
    if boxIdContains3:
        boxIdsContains3Count += 1

print(boxIdsContains2Count*boxIdsContains3Count)
