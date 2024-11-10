import 'package:flutter/material.dart';
import 'package:hyrox_tracker/ProgressCardViewModel.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/progression/progressCategory.dart';
import 'package:hyrox_tracker/service.dart';

class ProgressCardViewModelProvider {
Future<ProgressCardViewModel> provideViewModel(ProgressCategory category) async {
    IconData? disciplineIcon;
    Trend trend = Trend.Neutral;
    String? trendText;

    switch (category) {
      case ProgressCategory.bestExercise:
        final bestDisciplineString = await getBestDiscipline();
        // Split the string since getBestDiscipline returns "discipline: value"
        final parts = bestDisciplineString.split(': ');
        if (parts.length == 2) {
          final disciplineString = parts[0];
          final discipline = stringToDiscipline(disciplineString);
          disciplineIcon = _getDisciplineIcon(discipline);
          
          // Parse the numeric difference
          final diff = int.tryParse(parts[1]) ?? 0;
          trend = diff > 0 ? Trend.Up : Trend.Down;
          trendText = diff.toString();
        } else {
          trend = Trend.Neutral;
          trendText = "N/A";
        }
        
      case ProgressCategory.totalTime:
        final diff = await getTotalTimeDelta();
        trend = diff > 0 ? Trend.Up : Trend.Down;
        trendText = diff.toString();
        
      case ProgressCategory.runningTime:
        final diffString = await runningTimeDelta();
        final diff = int.tryParse(diffString) ?? 0;
        trend = diff > 0 ? Trend.Up : Trend.Down;
        trendText = diff.toString();
        
      case ProgressCategory.trainingSessions:
        final numberOfSessions = await getSessionsPerMonth();
        trend = Trend.Up;
        trendText = numberOfSessions;
    }

    return ProgressCardViewModel(
      icon: _getIcon(category),
      title: _getTitle(category),
      diciplineIcon: disciplineIcon,
      trendIcon: _getTrendIcon(trend),
      trendText: trendText,
      isPositiveTrend: trend == Trend.Up,
    );
  }

  String _getTitle(ProgressCategory category) {
    switch (category) {
      case ProgressCategory.bestExercise:
        return 'Best Exercise';
      case ProgressCategory.totalTime:
        return 'Total Time';
      case ProgressCategory.runningTime:
        return 'Running Time';
      case ProgressCategory.trainingSessions:
        return 'Training Sessions';
    }
  }

  IconData _getTrendIcon(Trend trend) {
    switch (trend) {
      case Trend.Up:
        return Icons.trending_up;
      case Trend.Down:
        return Icons.trending_down;
      case Trend.Neutral:
        return Icons.trending_flat;
    }
  }

  //refactor to once central class
  IconData _getDisciplineIcon(Discipline discipline) {
    switch (discipline) {
      case Discipline.skiErg:
        return Icons.downhill_skiing;
      case Discipline.sledPush:
        return Icons.arrow_forward;
      case Discipline.sledPull:
        return Icons.arrow_back;
      case Discipline.burpeeBroadJumps:
        return Icons.accessibility_new;
      case Discipline.row:
        return Icons.rowing;
      case Discipline.farmersCarry:
        return Icons.fitness_center;
      case Discipline.sandbagLunges:
        return Icons.sports_martial_arts;
      case Discipline.wallBalls:
        return Icons.sports_baseball;
    }
  }

  IconData _getIcon(ProgressCategory category) {
    switch (category) {
      case ProgressCategory.bestExercise:
        return Icons.star;
      case ProgressCategory.totalTime:
        return Icons.timer;
      case ProgressCategory.runningTime:
        return Icons.directions_walk;
      case ProgressCategory.trainingSessions:
        return Icons.calendar_month;
    }
  }
}

enum Trend { Up, Down, Neutral }
