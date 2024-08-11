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
      } else {
        stopwatch.start();
        isPaused = false;
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
      'total_time': disciplineTimes.reduce((a, b) => a + b),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CURRENT SESSION',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[700],
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.timer,
                      color: Colors.yellow[700],
                      size: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        disciplines[currentDisciplineIndex].toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        formatTime(stopwatch.elapsed),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            isPaused ? 'CONTINUE' : 'PAUSE',
                            isPaused ? Icons.play_arrow_rounded : Icons.pause,
                            pauseTimer,
                          ),
                          const SizedBox(width: 20),
                          _buildButton(
                            currentDisciplineIndex == disciplines.length - 1
                                ? 'FINISH'
                                : 'NEXT',
                            Icons.skip_next,
                            nextDiscipline,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow[700],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
