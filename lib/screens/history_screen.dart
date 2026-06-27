import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantid/core/theme.dart';
import 'package:plantid/providers/history_provider.dart';
import 'package:plantid/screens/result_screen.dart';
import 'package:plantid/widgets/history_list_item.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: historyAsync.when(
        data: (scans) {
          if (scans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'No scans yet. Start identifying plants!',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              return HistoryListItem(
                record: scan,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        imagePath: scan.imagePath,
                        existingRecord: scan,
                      ),
                    ),
                  );
                },
                onDelete: () {
                  ref.read(historyProvider.notifier).deleteScan(scan.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scan deleted')),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
