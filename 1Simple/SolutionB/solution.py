inputFile = open('../../1/Inputs/Input.AOCInput', 'r')
frequenciesChange = list(map(int, inputFile.read().split('\n')[:-1]))

frequencies = []
lastFrequency = 0

for frequencyChange in frequenciesChange:
    frequencies.append(lastFrequency)
    lastFrequency += frequencyChange

frequencyLoopAdder = abs(lastFrequency)
frequencyLoopAdderIsPositive = (frequencyLoopAdder == lastFrequency)

if frequencyLoopAdder == 0:
    print(0)
else:
    minimalLoopsCount = None
    minimalSecondFrequencyPosition = None
    firstRepeatedFrequency = None

    for frequencyAIndex in range(len(frequencies)-1):
        for frequencyBIndex in range(frequencyAIndex+1, len(frequencies)):
            frequencyA = frequencies[frequencyAIndex]
            frequencyB = frequencies[frequencyBIndex]
            frequencyDiff = abs(frequencyB-frequencyA)
            frequencyDiffIsPositive = (frequencyB > frequencyA)

            if frequencyDiff%frequencyLoopAdder == 0:
                loopsCount = frequencyDiff//frequencyLoopAdder
                secondFrequencyPosition = frequencyBIndex if (frequencyLoopAdderIsPositive != frequencyDiffIsPositive) else frequencyAIndex
                repeatedFrequency = frequencyB if (frequencyLoopAdderIsPositive == frequencyDiffIsPositive) else frequencyA

                betterFrequency = False
                if minimalLoopsCount == None:
                    betterFrequency = True
                else:
                    if loopsCount < minimalLoopsCount:
                        betterFrequency = True
                    elif loopsCount == minimalLoopsCount and secondFrequencyPosition < minimalSecondFrequencyPosition:
                        betterFrequency = True

                if betterFrequency:
                    minimalLoopsCount = loopsCount
                    minimalSecondFrequencyPosition = secondFrequencyPosition
                    firstRepeatedFrequency = repeatedFrequency

    print(firstRepeatedFrequency)
