import 'package:flutter/material.dart';
import 'package:plantid/core/theme.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.error,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'You are offline. Some features may be limited.',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
