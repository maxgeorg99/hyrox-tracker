import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'hyrox_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        total_time INTEGER,
        discipline_times TEXT
      )
    ''');
  }

  Future<int> insertSession(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('sessions', row);
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    Database db = await database;
    return await db.query('sessions', orderBy: 'date DESC');
  }

  Future<int> deleteSession(int id) async {
    Database db = await database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }
}
