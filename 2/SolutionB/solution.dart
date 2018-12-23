import 'dart:io';
import 'dart:async';



String inputFilePath = '../Inputs/input.AOCInput';



void main() async {
    List<String> input = await decodeInput(inputFilePath);
    print(solve(input));
}

Future<List<String>> decodeInput(String inputFilePath) async {
    final File inputFile = File(inputFilePath);

    List<String> inputFileLines = await inputFile.readAsLines();

    return inputFileLines;
}

String solve(List<String> phrases) {
    List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
    Map<String, int> alphabetMap = Map.fromIterable(List<int>.generate(alphabet.length, (int i) {return i;}), key: (dynamic i) {return alphabet[i];}, value: (dynamic i) {return i;});

    List<List<int>> phrasesInt = List<List<int>>.generate(phrases.length, (int i) {
        List<String> phrase = phrases[i].split('');
        List<int> phraseInt = List<int>();

        for (String char in phrase) {
            phraseInt.add(alphabetMap[char]);
        }

        return phraseInt;
    });

    bool found = false;
    List<int> phraseAFound = List<int>();
    List<int> phraseBFound = List<int>();

    finding:
    for (int phraseAIndex=0; phraseAIndex<phrasesInt.length-1; phraseAIndex++) {
        List<int> phraseA = phrasesInt[phraseAIndex];

        for (int phraseBIndex=phraseAIndex+1; phraseBIndex<phrasesInt.length; phraseBIndex++) {
            List<int> phraseB = phrasesInt[phraseBIndex];
            int diffCount = 0;

            for (int charIndex=0; charIndex<phraseA.length; charIndex++) {
                if (phraseA[charIndex] != phraseB[charIndex]) {
                    diffCount++;
                }

                if (diffCount > 1) {
                    break;
                }
            }

            if (diffCount == 1) {
                found = true;
                phraseAFound = phraseA;
                phraseBFound = phraseB;

                break finding;
            }
        }
    }

    if (found) {
        List<String> phraseFound = List<String>();

        for (int charIndex=0; charIndex<phraseAFound.length; charIndex++) {
            if (phraseAFound[charIndex] == phraseBFound[charIndex]) {
                phraseFound.add(alphabet[phraseAFound[charIndex]]);
            }
        }

        return phraseFound.join();
    } else {
        return 'Not found';
    }
}
