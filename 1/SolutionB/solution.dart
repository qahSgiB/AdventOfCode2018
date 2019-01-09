import 'dart:io';
import 'dart:async';



String inputFilePath = '../Inputs/Input.AOCInput';



void main() async {
    List<int> input = await decodeInput(inputFilePath);
    print(solve(input));
}

Future<List<int>> decodeInput(String inputFilePath) async {
    final File inputFile = File(inputFilePath);

    List<String> inputFileLines = await inputFile.readAsLines();
    List<int> input = List<int>();
    for (String line in inputFileLines) {
        input.add(int.parse(line));
    }

    return input;
}

int solve(List<int> frequencyChanges) {
    List<int> frequencies = List<int>();
    int lastFrequency = 0;

    for (int frequencyChange in frequencyChanges) {
        frequencies.add(lastFrequency);
        lastFrequency += frequencyChange;
    }

    int frequencyLoopAdder = lastFrequency.abs();
    bool frequencyLoopAdderIsPositive = (frequencyLoopAdder == lastFrequency);

    if (frequencyLoopAdder == 0) {
        return 0;
    } else {
        int minimalLoopsCount = null;
        int minimalSecondFrequencyPosition = null;
        int firstRepeatedFrequency = null;

        for (int frequencyAIndex=0; frequencyAIndex<frequencies.length-1; frequencyAIndex++) {
            for (int frequencyBIndex=frequencyAIndex+1; frequencyBIndex<frequencies.length; frequencyBIndex++) {
                int frequencyA = frequencies[frequencyAIndex];
                int frequencyB = frequencies[frequencyBIndex];
                int frequencyDiff = (frequencyB-frequencyA).abs();
                bool frequencyDiffIsPositive = (frequencyB > frequencyA);

                if (frequencyDiff%frequencyLoopAdder == 0) {
                    int loopsCount = frequencyDiff~/frequencyLoopAdder;
                    int secondFrequencyPosition = (frequencyLoopAdderIsPositive != frequencyDiffIsPositive) ? frequencyBIndex : frequencyAIndex;
                    int repeatedFrequency = (frequencyLoopAdderIsPositive == frequencyDiffIsPositive) ? frequencyB : frequencyA;

                    bool betterFrequency = false;
                    if (minimalLoopsCount == null) {
                        betterFrequency = true;
                    } else {
                        if (loopsCount < minimalLoopsCount) {
                            betterFrequency = true;
                        } else if (loopsCount == minimalLoopsCount && secondFrequencyPosition < minimalSecondFrequencyPosition) {
                            betterFrequency = true;
                        }
                    }

                    if (betterFrequency) {
                        minimalLoopsCount = loopsCount;
                        minimalSecondFrequencyPosition = secondFrequencyPosition;
                        firstRepeatedFrequency = repeatedFrequency;
                    }
                }
            }
        }

        return firstRepeatedFrequency;
    }
}
