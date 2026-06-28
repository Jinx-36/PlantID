import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantid/providers/scan_provider.dart';
import 'package:plantid/services/plantnet_service.dart';
import 'package:plantid/services/openfarm_service.dart';
import 'package:plantid/models/plant_result.dart';
import 'package:plantid/models/care_advice.dart';

@GenerateMocks([PlantNetService, OpenFarmService, Ref])
import 'scan_provider_test.mocks.dart';

void main() {
  late ScanNotifier scanNotifier;
  late MockPlantNetService mockPlantNetService;
  late MockOpenFarmService mockOpenFarmService;
  late MockRef mockRef;

  setUp(() {
    mockPlantNetService = MockPlantNetService();
    mockOpenFarmService = MockOpenFarmService();
    mockRef = MockRef();
    scanNotifier = ScanNotifier(mockRef, mockPlantNetService, mockOpenFarmService);
  });

  group('ScanProvider', () {
    test('initial state is idle', () {
      expect(scanNotifier.state.isLoading, false);
      expect(scanNotifier.state.result, null);
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
