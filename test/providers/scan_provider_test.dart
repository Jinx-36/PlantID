import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plantid/providers/scan_provider.dart';
import 'package:plantid/services/plantnet_service.dart';
import 'package:plantid/services/openfarm_service.dart';
import 'package:plantid/models/plant_result.dart';
import 'package:plantid/models/care_advice.dart';

@GenerateMocks([PlantNetService, OpenFarmService])
import 'scan_provider_test.mocks.dart';

void main() {
  late ScanNotifier scanNotifier;
  late MockPlantNetService mockPlantNetService;
  late MockOpenFarmService mockOpenFarmService;

  setUp(() {
    mockPlantNetService = MockPlantNetService();
    mockOpenFarmService = MockOpenFarmService();
    scanNotifier = ScanNotifier(mockPlantNetService, mockOpenFarmService);
  });

  group('ScanProvider', () {
    test('initial state is idle', () {
      expect(scanNotifier.state.isLoading, false);
      expect(scanNotifier.state.result, null);
    });

    test('successful identification sequence', () async {
      final plantResult = PlantResult(
        commonName: 'Test Plant',
        scientificName: 'Testus',
        family: 'TestFamily',
        confidence: 0.95,
      );
      final careAdvice = CareAdvice.fallback();

      when(mockPlantNetService.identifyPlant(any))
          .thenAnswer((_) async => plantResult);
      when(mockOpenFarmService.getCareAdvice(any))
          .thenAnswer((_) async => careAdvice);

      await scanNotifier.identifyPlant('path/to/image');

      expect(scanNotifier.state.isLoading, false);
      expect(scanNotifier.state.result, plantResult);
      expect(scanNotifier.state.careAdvice, careAdvice);
    });

    test('failed identification sequence', () async {
      when(mockPlantNetService.identifyPlant(any))
          .thenThrow(Exception('Network Error'));

      await scanNotifier.identifyPlant('path/to/image');

      expect(scanNotifier.state.isLoading, false);
      expect(scanNotifier.state.error, 'Network Error');
    });
  });
}
