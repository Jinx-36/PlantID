import 'package:flutter_test/flutter_test.dart';
import 'package:plantid/models/care_advice.dart';

void main() {
  group('CareAdvice JSON Parsing', () {
    test('should parse correctly from Gemini-like JSON string', () {
      final json = {
        'name': 'Monstera',
        'description': 'A popular houseplant.',
        'watering': 'Water regularly',
        'sunlight': 'Indirect light',
        'soil': 'Well-draining',
      };

      final advice = CareAdvice(
        name: json['name']!,
        description: json['description']!,
        watering: json['watering']!,
        sunlight: json['sunlight']!,
        soil: json['soil']!,
      );

      expect(advice.name, 'Monstera');
      expect(advice.description, 'A popular houseplant.');
      expect(advice.sunlight, 'Indirect light');
      expect(advice.watering, 'Water regularly');
      expect(advice.soil, 'Well-draining');
    });
  });
}
