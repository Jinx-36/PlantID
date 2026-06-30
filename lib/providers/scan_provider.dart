import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantid/models/care_advice.dart';
import 'package:plantid/models/plant_result.dart';
import 'package:plantid/models/scan_record.dart';
import 'package:plantid/providers/history_provider.dart';
import 'package:plantid/services/database_service.dart';
import 'package:plantid/services/image_service.dart';
import 'package:plantid/services/gemini_api_service.dart';
import 'package:plantid/services/plantnet_service.dart';

class ScanState {
  final bool isLoading;
  final PlantResult? result;
  final CareAdvice? careAdvice;
  final String? error;

  ScanState({
    this.isLoading = false,
    this.result,
    this.careAdvice,
    this.error,
  });

  factory ScanState.idle() => ScanState();
  factory ScanState.loading() => ScanState(isLoading: true);
  factory ScanState.success(PlantResult result, CareAdvice care) =>
      ScanState(result: result, careAdvice: care);
  factory ScanState.error(String message) => ScanState(error: message);
}

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  return ScanNotifier(ref, PlantNetService(), GeminiApiService());
});

class ScanNotifier extends StateNotifier<ScanState> {
  final Ref _ref;
  final PlantNetService _plantNetService;
  final GeminiApiService _geminiApiService;

  ScanNotifier(this._ref, this._plantNetService, this._geminiApiService) : super(ScanState.idle());

  Future<void> identifyPlant(String imagePath) async {
    state = ScanState.loading();
    try {
      // 1. Identify plant with PlantNet
      final plantResult = await _plantNetService.identifyPlant(imagePath);
      if (plantResult == null) {
        state = ScanState.error("We couldn't identify this plant. Try a clearer photo.");
        return;
      }

      // 2. Fetch care advice from Gemini (Fresh call every time)
      final careAdvice = await _geminiApiService.getCareAdvice(plantResult.commonName);

      // 3. Automatically save to history
      final savedPath = await ImageService.saveImageToDocs(imagePath);
      final record = ScanRecord(
        commonName: plantResult.commonName,
        scientificName: plantResult.scientificName,
        confidence: plantResult.confidence,
        imagePath: savedPath,
        careAdvice: careAdvice,
        scannedAt: DateTime.now(),
      );

      await _ref.read(historyProvider.notifier).addScan(record);

      // 4. Update state to success only after everything is complete
      state = ScanState.success(plantResult, careAdvice);
    } catch (e) {
      debugPrint('Identification Error: $e');
      state = ScanState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void reset() {
    state = ScanState.idle();
  }
}
