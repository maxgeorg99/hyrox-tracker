import 'package:flutter/material.dart';
import 'package:hyrox_tracker/ProgressCardViewModel.dart';

class ProgressCard extends StatelessWidget {
  final ProgressCardViewModel viewModel;

  const ProgressCard({super.key, required this.viewModel});

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
                viewModel.icon,
                size: 48,
                color: Colors.yellow[700],
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[700],
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.trendText,
                      style: TextStyle(
                        fontSize: 12,
                        color: viewModel.trendColor,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      viewModel.trendIcon,
                      size: 24,
                      color: Colors.yellow[700],
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
