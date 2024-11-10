import 'package:hyrox_tracker/settings/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  Category? _cachedCategory;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'hyrox_tracker.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from $oldVersion to $newVersion");
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings(
          key TEXT PRIMARY KEY,
          value TEXT
        )
      ''');
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        total_time INTEGER,
        discipline_times TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> saveCategory(Category category) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': 'selected_category', 'value': category.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _cachedCategory = category;
  }

  Future<void> loadCategory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['selected_category'],
    );

    if (maps.isNotEmpty) {
      _cachedCategory = Category.values.firstWhere(
        (e) => e.toString() == maps.first['value'],
        orElse: () => Category.menOpen,
      );
    } else {
      _cachedCategory = Category.menOpen;
    }
  }

  Category get category => _cachedCategory ?? Category.menOpen;

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
