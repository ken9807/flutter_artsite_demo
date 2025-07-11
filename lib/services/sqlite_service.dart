import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class SQLiteService {
  static final SQLiteService _instance = SQLiteService._internal();
  factory SQLiteService() => _instance;
  SQLiteService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('local_storage.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createSchema,
    );
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kv_store (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT
      )
    ''');
  }

  Future<void> insertOrUpdate(String key, String value) async {
    final db = await database;
    await db.insert(
      'kv_store',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getValue(String key) async {
    final db = await database;
    final result = await db.query(
      'kv_store',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }

  Future<void> deleteValue(String key) async {
    final db = await database;
    await db.delete(
      'kv_store',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('kv_store');
  }
}
