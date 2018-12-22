def solution(claims):
    yss = [[] for i in range(1000)]
    ysDoubles = [[] for i in range(1000)]
    for claim in claims:
        cX1 = claim['x']
        cY1 = claim['y']
        cX2 = claim['width']+cX1
        cY2 = claim['height']+cY1

        print(cX1, cX2, cY1, cY2)


        for y in range(cY1, cY2+1):
            xs = yss[y]
            yDoubles = ysDoubles[y]

            for x in xs:
                x1 = x[0]
                x2 = x[1]

                newYDouble = None
                if cX1 <= x2 and cX1 >= x1:
                    newYDouble = [x1, cX1]
                elif cX2 <= x2 and cX2 >= x1:
                    newYDouble = [x2, cX2]

                if newYDouble != None:
                    ysDoubles[cY1].append(newYDouble)

            yss[y].append([cX1, cX2])

    return ysDoubles

def decodeInput(input):
    claims = []
    for line in input.split('\n'):
        print(line)
        if line != '':
            partA, partB = line.split('@')
            partB = partB[1:]
            partBA, partBB = partB.split(':')
            x, y = list(map(int, partBA.split(',')))
            partBB = partBB[1:]
            width, height = list(map(int, partBB.split('x')))

            claims.append({
                'x': x,
                'y': y,
                'width': width,
                'height': height
            })

    return claims



if __name__ == '__main__':
    inputFile = 'input.AOCTestInput'
    with open(inputFile, 'r') as inputFile:
        print(solution(decodeInput(inputFile.read())))
