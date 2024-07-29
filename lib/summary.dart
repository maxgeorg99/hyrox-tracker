import 'package:flutter/material.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/main.dart';

class SummaryScreen extends StatelessWidget {
  final List<Duration> disciplineTimes;

  const SummaryScreen({super.key, required this.disciplineTimes});

  @override
  Widget build(BuildContext context) {
    final totalTime = disciplineTimes.reduce((a, b) => a + b);
    return Scaffold(
      appBar: AppBar(title: const Text('Session Summary')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Total Time'),
            trailing: Text(
              formatTime(totalTime),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(disciplineTimes.length, (index) {
            return ListTile(
              title: Text(getFullWorkoutList()[index]),
              trailing: Text(formatTime(disciplineTimes[index])),
            );
          }),
        ],
      ),
    );
  }
}
