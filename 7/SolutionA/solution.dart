import 'dart:io';
import 'dart:async';



// String inputFilePath = '../Inputs/InputTest0.AOCTestInput';
String inputFilePath = '../Inputs/Input.AOCInput';



class Requirement {
    String stepA;
    String stepB;

    Requirement(this.stepA, this.stepB);
}

class Step {
    List<String> next = List<String>();
    List<String> previous = List<String>();
    String name;
    bool done = false;

    Step(this.name);

    bool isPossible(Map<String, Step> otherSteps) {
        bool possible = true;

        for (String stepName in this.previous) {
            Step step = otherSteps[stepName];
            if (!step.done && step.name != this.name) {
                possible = false;
                break;
            }
        }

        return possible;
    }
}



void main() async {
    List<Requirement> input = await decodeInput(inputFilePath);
    print(solve(input));
}

Future<List<Requirement>> decodeInput(String inputFilePath) async {
    final File inputFile = File(inputFilePath);

    List<String> inputFileLines = await inputFile.readAsLines();

    RegExp lineRegExp = RegExp(r'Step (\w*) must be finished before step (\w*) can begin\.');
    List<Requirement> requirements = List<Requirement>();

    for (String line in inputFileLines) {
        Match match = lineRegExp.allMatches(line).toList()[0];

        String stepA = match.group(1);
        String stepB = match.group(2);
        Requirement requirement = Requirement(stepA, stepB);

        requirements.add(requirement);
    }

    return requirements;
}

String solve(List<Requirement> requirements) {
    List<String> alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    Map<String, int> alphabetMap = Map<String, int>.fromIterables(alphabet, List<int>.generate(26, (int i) {return i;}));

    Map<String, Step> steps = Map<String, Step>();
    List<String> possibleSteps = List<String>();

    for (Requirement requirement in requirements) {
        String stepA = requirement.stepA;
        String stepB = requirement.stepB;

        if (!steps.keys.contains(stepA)) {
            steps[stepA] = Step(stepA);
        }
        steps[stepA].next.add(stepB);

        if (!steps.keys.contains(stepB)) {
            steps[stepB] = Step(stepB);
        }
        steps[stepB].previous.add(stepA);
    }

    for (String step in steps.keys) {
        if (steps[step].previous.length == 0) {
            possibleSteps.add(step);
        }
    }

    List<String> stepsOrder = List<String>();

    bool end = false;
    while (!end) {
        if (possibleSteps.length == 0) {
            end = true;
        } else {
            possibleSteps.sort((String a, String b) {return alphabetMap[a]-alphabetMap[b];});
            List<String> newPossibleSteps = List<String>();
            bool stepFound = false;

            for (String possibleStep in possibleSteps) {
                Step step = steps[possibleStep];
                if (!step.done) {
                    bool stepDone = false;

                    if (!stepFound) {
                        if (step.isPossible(steps)) {
                            for (String nextStep in step.next) {
                                newPossibleSteps.add(nextStep);
                            }

                            stepsOrder.add(possibleStep);
                            step.done = true;
                            stepDone = true;
                            stepFound = true;
                        }
                    }

                    if (!stepDone) {
                        newPossibleSteps.add(possibleStep);
                    }
                }
            }

            possibleSteps = newPossibleSteps;
        }
    }

    return stepsOrder.join('');
}
