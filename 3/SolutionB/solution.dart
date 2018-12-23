import 'dart:io';
import 'dart:async';



// String inputFilePath = '../Inputs/InputTestA0.AOCTestInput';
String inputFilePath = '../Inputs/Input.AOCInput';



class Claim {
    int id;
    int x;
    int y;
    int width;
    int height;

    Claim(this.id, this.x, this.y, this.width, this.height);
}

class Range {
    int start;
    int end;

    Range(this.start, this.end);
}



void main() async {
    List<Claim> input = await decodeInput(inputFilePath);
    print(solve(input));
}

Future<List<Claim>> decodeInput(String inputFilePath) async {
    final File inputFile = File(inputFilePath);

    List<String> inputFileLines = await inputFile.readAsLines();

    List<Claim> claims = List<Claim>();
    RegExp lineRegExp = RegExp(r'#(\d+) @ (\d+),(\d+): (\d+)x(\d+)');

    for (String line in inputFileLines) {
        Match lineMatch = lineRegExp.allMatches(line).toList()[0];

        int id = int.parse(lineMatch.group(1));
        int x = int.parse(lineMatch.group(2));
        int y = int.parse(lineMatch.group(3));
        int width = int.parse(lineMatch.group(4));
        int height = int.parse(lineMatch.group(5));

        Claim newClaim = Claim(id, x, y, width, height);
        claims.add(newClaim);
    }

    return claims;
}

int solve(List<Claim> claims) {
    List<List<List<int>>> used = List<List<List<int>>>.generate(1000, (int x) {return List<List<int>>.generate(1000, (int y) {return List<int>();});});

    for (Claim claim in claims) {
        for (int x=claim.x; x<claim.x+claim.width; x++) {
            for (int y=claim.y; y<claim.y+claim.height; y++) {
                used[x][y].add(claim.id);
            }
        }
    }

    int notOverlapedClaimId;

    finding1:
    for (Claim claim in claims) {
        bool isNotOverlaped = true;

        finding2:
        for (int x=claim.x; x<claim.x+claim.width; x++) {
            for (int y=claim.y; y<claim.y+claim.height; y++) {
                if (used[x][y].length > 1) {
                    isNotOverlaped = false;
                    break finding2;
                }
            }
        }

        if (isNotOverlaped) {
            notOverlapedClaimId = claim.id;
            break finding1;
        }
    }

    return notOverlapedClaimId;
}
