import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final bool isHateSpeech;
  final double confidence;
  final String category;

  const ResultCard({
    super.key,
    required this.isHateSpeech,
    required this.confidence,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: $category'),
            Text('Confidence: ${(confidence * 100).toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }
}
