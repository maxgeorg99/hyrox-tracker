import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hyrox_tracker/ProgressCardViewModel.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/progressCategory.dart';

class ProgressCardViewModelProvider {
  ProgressCardViewModel provideViewModel(ProgressCategory category) {
    return ProgressCardViewModel(_getIcon(category), _getTitle(category), null,
        _getTrendIcon(_getTrend()), _getTrendText(), _getTrend == Trend.Up);
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
