import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Метод для отримання бази
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // Ініціалізація бази (створення)
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pdr_learning.db'); // назва файлу бази

    // створюємо базу при першому запуску
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            content TEXT
          )
        ''');
      },
    );
  }

  // Додати новий запис
  Future<void> insertSection(Map<String, dynamic> section) async {
    final db = await database;
    await db.insert('sections', section,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Отримати всі розділи
  Future<List<Map<String, dynamic>>> getSections() async {
    final db = await database;
    return await db.query('sections');
  }
}
