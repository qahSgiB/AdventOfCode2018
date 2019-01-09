inputFile = open('input.txt', 'r')
frequenciesChange = inputFile.read().split('\n')
frequenciesChange.pop(-1)

frequency = 0

for frequencyChange in frequenciesChange:
    frequency += int(frequencyChange)

print(frequency)
