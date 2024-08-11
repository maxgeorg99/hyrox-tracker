import 'package:flutter/material.dart';
import 'package:hyrox_tracker/history.dart';
import 'package:hyrox_tracker/session.dart';

String formatTime(Duration duration) {
  return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}

void main() => runApp(const HyroxTrackerApp());

class HyroxTrackerApp extends StatelessWidget {
  const HyroxTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyrox Tracker',
      theme: ThemeData(
        primaryColor: Colors.yellow[700],
        hintColor: Colors.yellow[600],
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                      'HYROX TRACKER',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[700],
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.fitness_center,
                      color: Colors.yellow[700],
                      size: 40,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        context,
                        'START NEW SESSION',
                        Icons.play_arrow,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SessionScreen()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        context,
                        'VIEW HISTORY',
                        Icons.history,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryScreen()),
                        ),
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

  Widget _buildButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow[700],
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
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
