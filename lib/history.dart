import 'package:flutter/material.dart';
import 'package:hyrox_tracker/database_helper.dart';
import 'package:hyrox_tracker/discipline.dart';
import 'package:hyrox_tracker/main.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSessions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var session = snapshot.data![index];
                return ListTile(
                  title: Text(
                      'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(session['date']))}'),
                  subtitle: Text(
                      'Total Time: ${formatTime(Duration(seconds: session['total_time']))}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await dbHelper.deleteSession(session['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session deleted')),
                      );
                      // Refresh the screen
                      setState(() {});
                    },
                  ),
                  onTap: () {
                    // Show detailed view of the session
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Session Details'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: session['discipline_times']
                                .split(',')
                                .asMap()
                                .entries
                                .map<Widget>((entry) {
                              return Text(
                                  '${getFullWorkoutList()[entry.key]}: ${formatTime(Duration(seconds: session['total_time']))}');
                            }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
