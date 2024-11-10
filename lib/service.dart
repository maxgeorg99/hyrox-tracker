import 'dart:ffi';

import 'package:hyrox_tracker/category.dart';
import 'package:hyrox_tracker/database_helper.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/main.dart';

String getWeightString(Discipline discipline, Category category) {
  final weightMap = {
    Discipline.skiErg: null,
    Discipline.sledPush: {
      Category.menOpen: 125,
      Category.menPro: 175,
      Category.womenOpen: 75,
      Category.womenPro: 125
    },
    Discipline.sledPull: {
      Category.menOpen: 75,
      Category.menPro: 125,
      Category.womenOpen: 50,
      Category.womenPro: 75
    },
    Discipline.burpeeBroadJumps: null,
    Discipline.row: null,
    Discipline.farmersCarry: {
      Category.menOpen: 24,
      Category.menPro: 32,
      Category.womenOpen: 16,
      Category.womenPro: 24
    },
    Discipline.sandbagLunges: {
      Category.menOpen: 20,
      Category.menPro: 30,
      Category.womenOpen: 10,
      Category.womenPro: 20
    },
    Discipline.wallBalls: {
      Category.menOpen: 6,
      Category.menPro: 9,
      Category.womenOpen: 4,
      Category.womenPro: 6
    },
  };

  num weight = weightMap[discipline]?[category] ?? 0;

  return weight > 0 ? '${weight.toStringAsFixed(0)} kg' : '';
}

String? getWeightStringFromDiscipline(String disciplineStr) {
  try {
    final discipline = Discipline.values.firstWhere(
      (d) => d.name.toLowerCase() == disciplineStr.toLowerCase(),
    );
    return getWeightString(discipline, dbHelper.category);
  } catch (e) {
    return null;
  }
}

List<String> getFullWorkoutList() {
  List<String> fullList = [];
  for (var discipline in Discipline.values) {
    fullList.add('1000m Run');
    fullList.add(discipline.name);
  }
  return fullList;
}

String buildDisciplineTitle(Discipline discipline, String weightString) =>
    '${discipline.name}${weightString.isNotEmpty ? ' ($weightString)' : ''}';

Future<String> getSessionsPerMonth() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  var sessions = dbHelper.getSessions();

  final count = await sessions.then((sessionList) => sessionList
      .where((session) =>
          DateTime.parse(session['date']).month == DateTime.now().month &&
          DateTime.parse(session['date']).year == DateTime.now().year)
      .length);

  return count.toString();
}

Future<String> getTotalTimeDelta() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  var sessions = dbHelper.getSessions();

  final sessionList = await sessions;

  final recentSessions = sessionList.take(5).toList();

  if (recentSessions.length < 2) return '0';

  num totalDiff = 0;
  for (int i = 0; i < recentSessions.length - 1; i++) {
    final current = getTotalTime(recentSessions[i]);
    final previous = getTotalTime(recentSessions[i + 1]);
    totalDiff += (current - previous);
  }

  final averageDiff = totalDiff ~/ (recentSessions.length - 1);

  return averageDiff.toString();
}

double getAverageRunTime(dynamic session) {
  var runTimes = session
      .split(',')
      .asMap()
      .entries
      .where((entry) => entry.key.toLowerCase() == '1000m run')
      .map((entry) => int.parse(entry.value))
      .toList();
  return runTimes.isEmpty
      ? 0
      : runTimes.reduce((a, b) => a + b) / runTimes.length;
}

Future<String> runningTimeDelta() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  var sessions = dbHelper.getSessions();

  final sessionList = await sessions;

  final recentSessions = sessionList.take(5).toList();

  if (recentSessions.length < 2) return '0';

  num totalDiff = 0;
  for (int i = 0; i < recentSessions.length - 1; i++) {
    var currentAverage =
        getAverageRunTime(recentSessions[i]['discipline_times']);
    var previousAverage =
        getAverageRunTime(recentSessions[i + 1]['discipline_times']);

    totalDiff += (currentAverage - previousAverage);
  }

  final averageDiff = totalDiff ~/ (recentSessions.length - 1);

  return averageDiff.toString();
}

Future<String> getBestDiscipline() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  var sessions = dbHelper.getSessions();
  final sessionList = await sessions;

  // Take the 5 most recent sessions
  final recentSessions = sessionList.take(5).toList();

  if (recentSessions.length < 2) return 'Not enough data';

  // Map to store average improvement by discipline
  Map<String, List<num>> disciplineDeltas = {};

  // Calculate improvement for each discipline
  for (int i = 0; i < recentSessions.length - 1; i++) {
    // Get discipline times maps for current and previous sessions
    Map<String, dynamic> currentDisciplines =
        recentSessions[i]['discipline_times'];
    Map<String, dynamic> previousDisciplines =
        recentSessions[i + 1]['discipline_times'];

    // Compare each discipline
    for (String discipline in currentDisciplines.keys) {
      if (previousDisciplines.containsKey(discipline)) {
        var currentAverage = getAverageRunTime(currentDisciplines[discipline]);
        var previousAverage =
            getAverageRunTime(previousDisciplines[discipline]);

        // Calculate improvement (negative means better time)
        num improvement = previousAverage - currentAverage;

        // Store improvement for this discipline
        disciplineDeltas.putIfAbsent(discipline, () => []);
        disciplineDeltas[discipline]!.add(improvement);
      }
    }
  }

  // Find discipline with best average improvement
  String bestDiscipline = '';
  num bestImprovement = double.negativeInfinity;

  disciplineDeltas.forEach((discipline, improvements) {
    if (improvements.isEmpty) return;

    // Calculate average improvement for this discipline
    num avgImprovement =
        improvements.reduce((a, b) => a + b) / improvements.length;

    if (avgImprovement > bestImprovement) {
      bestImprovement = avgImprovement;
      bestDiscipline = discipline;
    }
  });

  if (bestDiscipline.isEmpty) return 'No improvements found';

  final roundedImprovement = bestImprovement.round();

  return '$bestDiscipline: ${roundedImprovement.abs()}';
}

getTotalTime(Map<String, dynamic> session) {
  var totalTime = session['total_time'];
  if (totalTime > 1) {
    return totalTime;
  }
  //fall back if session contains no total time
  return session['discipline_times']
      .split(',')
      .asMap()
      .entries
      .map((entry) => int.parse(entry.value))
      .reduce((a, b) => a + b);
}
