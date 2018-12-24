import 'dart:io';
import 'dart:async';
import 'dart:collection';



// String inputFilePath = '../Inputs/InputTest0.AOCTestInput';
String inputFilePath = '../Inputs/Input.AOCInput';



void main() async {
    List<int> input = await decodeInput(inputFilePath);
    print(solve(input));
}

Future<List<int>> decodeInput(String inputFilePath) async {
    int unitStringToUnitInt(String unitString) {
        List<String> positiveUnits = 'abcdefghijklmnopqrstuvwxyz'.split('');
        List<String> negativeUnits = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

        int unit;

        if (positiveUnits.contains(unitString)) {
            unit = positiveUnits.indexOf(unitString)+1;
        } else if (negativeUnits.contains(unitString)) {
            unit = -(negativeUnits.indexOf(unitString)+1);
        }

        return unit;
    }

    final File inputFile = File(inputFilePath);

    List<String> inputFileLines = await inputFile.readAsLines();

    String polymer = inputFileLines[0];
    List<int> units = List<int>();

    for (String unitString in polymer.split('')) {
        units.add(unitStringToUnitInt(unitString));
    }

    return units;
}

int solve(List<int> units) {
    Queue unitsQueue = Queue();

    for (int unit in units) {
        if (unitsQueue.length == 0) {
            unitsQueue.addLast(unit);
        } else {
            int previousUnit = unitsQueue.removeLast();
            if (previousUnit != -unit) {
                unitsQueue.addLast(previousUnit);
                unitsQueue.addLast(unit);
            }
        }
    }

    return unitsQueue.length;
}
