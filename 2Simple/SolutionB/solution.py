inputFile = open('input.txt', 'r')
boxIds = inputFile.read().split('\n')
boxIds.pop(-1)

boxLength = len(boxIds[0])
boxIdf1 = None
boxIdf2 = None
boxId12Found = False

for boxId1 in boxIds:
    for boxId2 in boxIds:
        boxId12differenciesCount = 0

        for letterIndex in range(boxLength):
            charBoxId1 = boxId1[letterIndex]
            charBoxId2 = boxId2[letterIndex]

            if charBoxId1 != charBoxId2:
                boxId12differenciesCount += 1

        if boxId12differenciesCount == 1:
            boxIdf1 = boxId1
            boxIdf2 = boxId2
            boxId12Found = True

        if boxId12Found:
            break

    if boxId12Found:
        break

boxId12Common = ''

for letterIndex in range(boxLength):
    charBoxId1 = boxId1[letterIndex]
    charBoxId2 = boxId2[letterIndex]

    if charBoxId1 == charBoxId2:
        boxId12Common += charBoxId1

print(boxId12Common)
