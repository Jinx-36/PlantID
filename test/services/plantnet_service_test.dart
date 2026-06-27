import 'package:flutter_test/flutter_test.dart';
import 'package:plantid/models/plant_result.dart';

void main() {
  group('PlantResult Parsing', () {
    test('should parse correctly from JSON', () {
      final json = {
        'score': 0.85,
        'species': {
          'scientificNameWithoutAuthor': 'Monstera deliciosa',
          'commonNames': ['Swiss cheese plant'],
          'family': {
            'scientificNameWithoutAuthor': 'Araceae',
          },
        },
        'images': [
          {
            'url': {'m': 'https://example.com/image.jpg'}
          }
        ]
      };

      final result = PlantResult.fromJson(json);

      expect(result.commonName, 'Swiss cheese plant');
      expect(result.scientificName, 'Monstera deliciosa');
      expect(result.family, 'Araceae');
      expect(result.confidence, 85.0);
      expect(result.imageUrl, 'https://example.com/image.jpg');
    });
  });
}
