import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyrox_tracker/database_helper.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/main.dart';
import 'package:hyrox_tracker/summary.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<String> disciplines = getFullWorkoutList();
  int currentDisciplineIndex = 0;
  List<Duration> disciplineTimes = [];
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    stopwatch.stop();
    timer.cancel();
    super.dispose();
  }

  void pauseTimer() {
    setState(() {
      if (stopwatch.isRunning) {
        stopwatch.stop();
        isPaused = true;
      }
    });
  }

  void nextDiscipline() {
    disciplineTimes.add(stopwatch.elapsed);
    if (currentDisciplineIndex < disciplines.length - 1) {
      setState(() {
        currentDisciplineIndex++;
        if (isPaused) {
          stopwatch.start();
          isPaused = false;
        } else {
          stopwatch.reset();
        }
      });
    } else {
      finishSession();
    }
  }

  void finishSession() {
    stopwatch.stop();
    timer.cancel();

    DatabaseHelper().insertSession({
      'date': DateTime.now().toIso8601String(),
      'total_time': stopwatch.elapsed.inSeconds,
      'discipline_times': disciplineTimes.map((d) => d.inSeconds).join(','),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(disciplineTimes: disciplineTimes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Session')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              disciplines[currentDisciplineIndex],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(stopwatch.elapsed),
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: pauseTimer,
                  child: Text('Pause'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: nextDiscipline,
                  child: Text(currentDisciplineIndex == disciplines.length - 1
                      ? 'Finish'
                      : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
