import 'package:flutter/material.dart';
import 'package:hyrox_tracker/ProgressCard.dart';
import 'package:hyrox_tracker/progressCardViewModelProvider.dart';
import 'package:hyrox_tracker/progressCategory.dart';

class ProgressScreem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HYROX Workout'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                _buildCardRow([
                  ProgressCategory.bestExercise,
                  ProgressCategory.totalTime,
                ]),
                _buildCardRow([
                  ProgressCategory.runningTime,
                  ProgressCategory.trainingSessions,
                ])
              ]),
            ),
          )
        ]));
  }

  _buildCardRow(List<ProgressCategory> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list.map((category) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ProgressCard(
              viewModel:
                  ProgressCardViewModelProvider().provideViewModel(category),
            ),
          ),
        );
      }).toList(),
    );
  }
}
