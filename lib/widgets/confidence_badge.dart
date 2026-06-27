import 'package:flutter/material.dart';
import 'package:plantid/core/theme.dart';

class ConfidenceBadge extends StatelessWidget {
  final double confidence;

  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (confidence >= 70) {
      color = AppTheme.success;
    } else if (confidence >= 40) {
      color = AppTheme.warning;
    } else {
      color = AppTheme.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        '${confidence.toStringAsFixed(1)}% Confidence',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
