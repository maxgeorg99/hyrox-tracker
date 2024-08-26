enum Discipline {
  skiErg,
  sledPush,
  sledPull,
  burpeeBroadJumps,
  row,
  farmersCarry,
  sandbagLunges,
  wallBalls,
}

extension DisciplineExtension on Discipline {
  String get name {
    switch (this) {
      case Discipline.skiErg:
        return '1000m SkiErg';
      case Discipline.sledPush:
        return '50m Sled Push';
      case Discipline.sledPull:
        return '50m Sled Pull';
      case Discipline.burpeeBroadJumps:
        return '80m Burpee Broad Jumps';
      case Discipline.row:
        return '1000m Row';
      case Discipline.farmersCarry:
        return '200m Farmers Carry';
      case Discipline.sandbagLunges:
        return '100m Sandbag Lunges';
      case Discipline.wallBalls:
        return '100 Wall Balls';
    }
  }
}
