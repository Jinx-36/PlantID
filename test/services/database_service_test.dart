import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:plantid/models/scan_record.dart';
import 'package:plantid/models/care_advice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:plantid/core/constants.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE ${AppConstants.tableScanHistory} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          common_name TEXT NOT NULL,
          scientific_name TEXT NOT NULL,
          confidence REAL NOT NULL,
          image_path TEXT NOT NULL,
          care_json TEXT NOT NULL,
          scanned_at TEXT NOT NULL
        )
      ''');
    });
  });

  tearDown(() async {
    await db.close();
  });

  test('Database insert and read', () async {
    final record = ScanRecord(
      commonName: 'Test Plant',
      scientificName: 'Testus plantus',
      confidence: 90.0,
      imagePath: '/path/to/image.jpg',
      careAdvice: CareAdvice.fallback(),
      scannedAt: DateTime.now(),
    );

    await db.insert(AppConstants.tableScanHistory, record.toMap());

    final results = await db.query(AppConstants.tableScanHistory);
    expect(results.length, 1);
    expect(results.first['common_name'], 'Test Plant');
  });
}
