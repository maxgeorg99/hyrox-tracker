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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hyrox Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Start New Session'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SessionScreen()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('View History'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
