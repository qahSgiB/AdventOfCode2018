import 'dart:io';
import 'dart:async';



// String inputFilePath = '../Inputs/InputTest0.AOCTestInput';
String inputFilePath = '../Inputs/Input.AOCInput';
List<int> monthsDayCount = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];



enum Action { wake, sleep, begin }



class ActionDetails {
    Action action;
    Map<String, dynamic> details;

    ActionDetails(this.action, this.details);

    static Map<Action, RegExp> actionRegExps = {
        Action.wake: RegExp(r'wakes up'),
        Action.sleep: RegExp(r'falls asleep'),
        Action.begin: RegExp(r'Guard #(\d*) begins shift'),
    };

    static ActionDetails matchAction(String actionString) {
        ActionDetails actionDetails;
        bool matchFound = false;

        finding:
        for (Action action in ActionDetails.actionRegExps.keys) {
            List<Match> matches = ActionDetails.actionRegExps[action].allMatches(actionString).toList();

            if (matches.length == 1) {
                Match match = matches[0];

                Map<String, dynamic> details = Map<String, dynamic>();

                if (action == Action.begin) {
                    details['id'] = int.parse(match.group(1));
                }

                actionDetails = ActionDetails(action, details);
                matchFound = true;
                break finding;
            }
        }

        return matchFound ? actionDetails : null;
    }
}

class Record {
    int date;
    int minute;
    ActionDetails actionDetails;

    Record(int year, int month, int day, int hour, int minute, ActionDetails actionDetails) {
        if (hour == 23) {
            day++;
        }
        if (day > monthsDayCount[month]) {
            month++;
            day = 1;
        }

        this.date = day+100*(month+100*year);
        this.minute = minute;
        this.actionDetails = actionDetails;
    }
}

class GouardRecords {
    int id;
    Map<int, List<Action>> daysRecord = Map<int, List<Action>>();

    GouardRecords(this.id);

    void addRecord(Record record) {
        this.daysRecord[record.date][record.minute] = record.actionDetails.action;
    }

    void addDay(int date) {
        this.daysRecord[date] = List<Action>.generate(60, (int i) {return null;});
    }

    int getMinutesSleeping() {
        int minuteSleeping = 0;

        for (int day in daysRecord.keys) {
            bool sleeping = false;
            List<Action> dayRecord = this.daysRecord[day];

            for (int minute=0; minute<dayRecord.length; minute++) {
                Action action = dayRecord[minute];

                if (action == Action.wake) {
                    sleeping = false;
                } else if (action == Action.sleep) {
                    sleeping = true;
                }

                if (sleeping) {
                    minuteSleeping++;
                }
            }
        }

        return minuteSleeping;
    }

    int getBestMinute() {
        List<int> minutesDaysSleeping = List<int>.generate(60, (int i) {return 0;});

        for (int day in this.daysRecord.keys) {
            List<Action> dayRecord = this.daysRecord[day];

            bool sleeping = false;

            for (int minute=0; minute<dayRecord.length; minute++) {
                Action action = dayRecord[minute];

                if (action == Action.wake) {
                    sleeping = false;
                } else if (action == Action.sleep) {
                    sleeping = true;
                }

                if (sleeping) {
                    minutesDaysSleeping[minute]++;
                }
            }
        }

        int bestMinute;
        int bestMinuteDaysSleeping;

        for (int minute=0; minute<minutesDaysSleeping.length; minute++) {
            int minuteDaysSleeping = minutesDaysSleeping[minute];

            bool betterMinute = false;
            if (bestMinuteDaysSleeping == null) {
                betterMinute = true;
            } else {
                if (bestMinuteDaysSleeping < minuteDaysSleeping) {
                    betterMinute = true;
                }
            }

            if (betterMinute) {
                bestMinute = minute;
                bestMinuteDaysSleeping = minuteDaysSleeping;
            }
        }

        return bestMinute;
    }
}




void main() async {
    List<Record> input = await decodeInput(inputFilePath);
    print(solve(input));
}

Future<List<Record>> decodeInput(String inputFilePath) async {
    final File inputFile = File(inputFilePath);

    List<String> inputFileLines = await inputFile.readAsLines();

    List<Record> records = List<Record>();
    RegExp lineRegExp = RegExp(r'\[(\d*)-(\d*)-(\d*) (\d*):(\d*)\] (.*)');

    for (String line in inputFileLines) {
        Match lineMatch = lineRegExp.allMatches(line).toList()[0];

        int year = int.parse(lineMatch.group(1));
        int month = int.parse(lineMatch.group(2));
        int day = int.parse(lineMatch.group(3));
        int hour = int.parse(lineMatch.group(4));
        int minute = int.parse(lineMatch.group(5));
        String actionString = lineMatch.group(6);

        ActionDetails actionDetails = ActionDetails.matchAction(actionString);

        Record newRecord = Record(year, month, day, hour, minute, actionDetails);
        records.add(newRecord);
    }

    return records;
}

int solve(List<Record> records) {
    Map<int, GouardRecords> guardsRecords = Map<int, GouardRecords>();
    Map<int, int> dateToId = Map<int, int>();

    for (Record record in records) {
        if (record.actionDetails.action == Action.begin) {
            int guardId = record.actionDetails.details['id'];
            int date = record.date;

            if (!guardsRecords.keys.contains(guardId)) {
                guardsRecords[guardId] = GouardRecords(record.actionDetails.details['id']);
            }

            guardsRecords[guardId].addDay(date);

            dateToId[date] = guardId;
        }
    }

    for (Record record in records) {
        Action action = record.actionDetails.action;
        if (action == Action.wake || action == Action.sleep) {
            int guardId = dateToId[record.date];
            guardsRecords[guardId].addRecord(record);
        }
    }

    int bestGouardId;
    int bestGouardMinutesSleeping;

    for (int guardId in guardsRecords.keys) {
        GouardRecords gouardRecords = guardsRecords[guardId];
        int guardMinutesSleeping = gouardRecords.getMinutesSleeping();

        bool betterGuard = false;
        if (bestGouardMinutesSleeping == null) {
            betterGuard = true;
        } else {
            if (bestGouardMinutesSleeping < guardMinutesSleeping) {
                betterGuard = true;
            }
        }

        if (betterGuard) {
            bestGouardMinutesSleeping = guardMinutesSleeping;
            bestGouardId = guardId;
        }
    }

    GouardRecords bestGuardRecords = guardsRecords[bestGouardId];

    return bestGuardRecords.getBestMinute()*bestGouardId;
}
