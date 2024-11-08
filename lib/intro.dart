import 'package:flutter/material.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/discipline_card.dart';
import 'package:hyrox_tracker/session.dart';

class HyroxIntroScreen extends StatelessWidget {
  final Function(String) getWeightStringFromDiscipline;

  const HyroxIntroScreen({
    super.key,
    required this.getWeightStringFromDiscipline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HYROX Workout'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildCardRow([
                    Discipline.skiErg,
                    Discipline.sledPush,
                  ]),
                  _buildCardRow([
                    Discipline.sledPull,
                    Discipline.burpeeBroadJumps,
                  ]),
                  _buildCardRow([
                    Discipline.row,
                    Discipline.farmersCarry,
                  ]),
                  _buildCardRow([
                    Discipline.sandbagLunges,
                    Discipline.wallBalls,
                  ]),
                ],
              ),
            ),
          ),
          // Start Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text(
                'START WORKOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardRow(List<Discipline> disciplines) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: disciplines.map((discipline) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: DisciplineCard(
              discipline: discipline,
              weight: getWeightStringFromDiscipline(discipline.name),
            ),
          ),
        );
      }).toList(),
    );
  }
}