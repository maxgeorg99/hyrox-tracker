import 'package:flutter/material.dart';
import 'package:hyrox_tracker/ProgressCard.dart';
import 'package:hyrox_tracker/ProgressCardViewModel.dart';
import 'package:hyrox_tracker/progression/progressCardViewModelProvider.dart';
import 'package:hyrox_tracker/progression/progressCategory.dart';

class ProgressScreen extends StatelessWidget {
  final _provider = ProgressCardViewModelProvider();

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
                    ProgressCategory.bestExercise,
                    ProgressCategory.totalTime,
                  ]),
                  _buildCardRow([
                    ProgressCategory.runningTime,
                    ProgressCategory.trainingSessions,
                  ])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardRow(List<ProgressCategory> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((category) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FutureBuilder(
              future: _provider.provideViewModel(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading data',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ProgressCard(
                  viewModel: snapshot.data!,
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Approach 2: Using StatefulWidget (Alternative)
class ProgressScreenStateful extends StatefulWidget {
  @override
  _ProgressScreenStatefulState createState() => _ProgressScreenStatefulState();
}

class _ProgressScreenStatefulState extends State<ProgressScreenStateful> {
  final _provider = ProgressCardViewModelProvider();
  final Map<ProgressCategory, Future<ProgressCardViewModel>> _viewModels = {};

  @override
  void initState() {
    super.initState();
    // Initialize all futures
    for (var category in ProgressCategory.values) {
      _viewModels[category] = _provider.provideViewModel(category);
    }
  }

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
                    ProgressCategory.bestExercise,
                    ProgressCategory.totalTime,
                  ]),
                  _buildCardRow([
                    ProgressCategory.runningTime,
                    ProgressCategory.trainingSessions,
                  ])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardRow(List<ProgressCategory> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((category) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FutureBuilder(
              future: _viewModels[category],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading data',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ProgressCard(
                  viewModel: snapshot.data!,
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}