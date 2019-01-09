class Node():
    def __init__(self, value):
        self.value = value
        self.next = None

class Stack():
    def __init__(self):
        self.begin = None

    def add(self, value):
        if self.begin == None:
            self.begin = Node(value)
        else:
            beginH = self.begin
            self.begin = Node(value)
            self.begin.next = beginH

    def get(self):
        if self.begin != None:
            beginHInfo = self.begin.value
            self.begin = self.begin.next
            return beginHInfo

    def isEmpty(self):
        return self.getLength() == 0

    def getLength(self):
        temp = self.begin
        length = 0

        while temp != None:
            length += 1
            temp = temp.next

        return length



def unitStringToUnitInt(unitString):
    positiveUnitsString = list('abcdefghijklmnopqrstuvwxyz')
    negativeUnitsString = list('ABCDEFGHIJKLMNOPQRSTUVWXYZ')

    if unitString in positiveUnitsString:
        return positiveUnitsString.index(unitString)+1
    if unitString in negativeUnitsString:
        return -(negativeUnitsString.index(unitString)+1)



inputFile = open('../../5/Inputs/Input.AOCInput', 'r')
units = list(map(unitStringToUnitInt, list(inputFile.read().split('\n')[0])))

unitsStack = Stack()

for unit in units:
    if unitsStack.isEmpty():
        unitsStack.add(unit)
    else:
        lastUnit = unitsStack.get()
        if lastUnit != -unit:
            unitsStack.add(lastUnit)
            unitsStack.add(unit)

print(unitsStack.getLength())
