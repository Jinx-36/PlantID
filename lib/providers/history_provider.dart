import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantid/models/scan_record.dart';
import 'package:plantid/services/database_service.dart';

final historyProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<ScanRecord>>>((ref) {
  return HistoryNotifier();
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<ScanRecord>>> {
  HistoryNotifier() : super(const AsyncValue.loading()) {
    loadScans();
  }

  Future<void> loadScans() async {
    state = const AsyncValue.loading();
    try {
      final scans = await DatabaseService.instance.getAllScans();
      state = AsyncValue.data(scans);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addScan(ScanRecord scan) async {
    try {
      await DatabaseService.instance.insertScan(scan);
      await loadScans();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteScan(int id) async {
    try {
      await DatabaseService.instance.deleteScan(id);
      await loadScans();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
