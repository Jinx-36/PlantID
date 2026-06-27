import 'dart:convert';
import 'package:plantid/models/care_advice.dart';

class ScanRecord {
  final int? id;
  final String commonName;
  final String scientificName;
  final double confidence;
  final String imagePath;
  final CareAdvice careAdvice;
  final DateTime scannedAt;

  ScanRecord({
    this.id,
    required this.commonName,
    required this.scientificName,
    required this.confidence,
    required this.imagePath,
    required this.careAdvice,
    required this.scannedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'confidence': confidence,
      'image_path': imagePath,
      'care_json': jsonEncode(careAdvice.toJson()),
      'scanned_at': scannedAt.toIso8601String(),
    };
  }

  factory ScanRecord.fromMap(Map<String, dynamic> map) {
    return ScanRecord(
      id: map['id'],
      commonName: map['common_name'],
      scientificName: map['scientific_name'],
      confidence: map['confidence'],
      imagePath: map['image_path'],
      careAdvice: CareAdvice.fromJson({
        'attributes': jsonDecode(map['care_json']),
      }),
      scannedAt: DateTime.parse(map['scanned_at']),
    );
  }
}
