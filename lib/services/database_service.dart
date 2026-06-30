import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:plantid/core/constants.dart';
import 'package:plantid/models/scan_record.dart';
import 'package:plantid/models/care_advice.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
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

  }

  Future<int> insertScan(ScanRecord scan) async {
    final db = await instance.database;
    return await db.insert(AppConstants.tableScanHistory, scan.toMap());
  }

  Future<List<ScanRecord>> getAllScans() async {
    final db = await instance.database;
    final result = await db.query(AppConstants.tableScanHistory, orderBy: 'scanned_at DESC');
    return result.map((json) => ScanRecord.fromMap(json)).toList();
  }

  Future<int> deleteScan(int id) async {
    final db = await instance.database;
    return await db.delete(
      AppConstants.tableScanHistory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
