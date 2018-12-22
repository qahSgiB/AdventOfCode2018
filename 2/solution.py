def solutionA(input):
    alphabet = list('abcdefghijklmnopqrstuvwxyz')



    def includeDoubleTriple(phrase):
        chars = {char: 0 for char in alphabet}

        for char in phrase:
            chars[char] += 1

        double, triple = False, False
        for char in alphabet:
            double = double or (chars[char] == 2)
            triple = triple or (chars[char] == 3)

        return double, triple



    doubleCount = 0
    tripleCount = 0

    for phrase in input:
        double, triple = includeDoubleTriple(phrase)
        if double:
            doubleCount += 1
        if triple:
            tripleCount += 1

    return doubleCount*tripleCount

def decodeInput(input):
    return input.split('\n')



if __name__ == '__main__':
    inputFileName = 'input.AOCInput'

    with open(inputFileName, 'r') as inputFile:
        print(solution(decodeInput(inputFile.read())))
