import 'package:hyrox_tracker/category.dart';
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
    Discipline.wallBalls: null,
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
