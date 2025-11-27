import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pdr_learning.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            content TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> clearSections() async {
    final db = await database;
    await db.delete('sections');
  }

  Future<void> insertSection(Map<String, dynamic> section) async {
    final db = await database;

    print('🧠 Вставляю у базу секцію: ${section['title']}');
    print('📦 Контент: ${section['content']}\n');

    await db.insert(
      'sections',
      section,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSections() async {
    final db = await database;
    return await db.query('sections');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
