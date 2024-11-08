import 'package:flutter/material.dart';
import 'package:hyrox_tracker/discipline.dart';

class DisciplineCard extends StatelessWidget {
  final Discipline discipline;
  final String weight;

  const DisciplineCard({
    super.key,
    required this.discipline,
    required this.weight,
  });

  IconData _getIcon(Discipline discipline) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[900],
      child: SizedBox(
        width: 120, // Set a fixed width
        height: 160, // Set a fixed height
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                _getIcon(discipline),
                size: 48,
                color: Colors.yellow[700],
              ),
              const SizedBox(height: 8),
              Text(
                discipline.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[700],
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                weight,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}