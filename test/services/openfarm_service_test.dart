import 'package:flutter_test/flutter_test.dart';
import 'package:plantid/models/care_advice.dart';

void main() {
  group('CareAdvice Parsing', () {
    test('should parse correctly from OpenFarm JSON', () {
      final json = {
        'attributes': {
          'name': 'Monstera',
          'description': 'A popular houseplant.',
          'sun_requirements': 'Partial Sun',
          'sowing_method': 'Water regularly',
          'row_spacing': 50,
        }
      };

      final advice = CareAdvice.fromJson(json);

      expect(advice.name, 'Monstera');
      expect(advice.description, 'A popular houseplant.');
      expect(advice.sunlight, 'Partial Sun');
      expect(advice.watering, 'Water regularly');
      expect(advice.soil, 'Spacing: 50 cm');
    });
  });
}
