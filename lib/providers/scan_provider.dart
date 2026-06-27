import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantid/models/care_advice.dart';
import 'package:plantid/models/plant_result.dart';
import 'package:plantid/services/openfarm_service.dart';
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
  return ScanNotifier(PlantNetService(), OpenFarmService());
});

class ScanNotifier extends StateNotifier<ScanState> {
  final PlantNetService _plantNetService;
  final OpenFarmService _openFarmService;

  ScanNotifier(this._plantNetService, this._openFarmService) : super(ScanState.idle());

  Future<void> identifyPlant(String imagePath) async {
    state = ScanState.loading();
    try {
      final plantResult = await _plantNetService.identifyPlant(imagePath);
      if (plantResult == null) {
        state = ScanState.error("We couldn't identify this plant. Try a clearer photo.");
        return;
      }

      final careAdvice = await _openFarmService.getCareAdvice(plantResult.commonName);
      state = ScanState.success(plantResult, careAdvice);
    } catch (e) {
      state = ScanState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void reset() {
    state = ScanState.idle();
  }
}
