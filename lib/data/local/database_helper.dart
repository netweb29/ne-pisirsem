import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Veritabanını açar, telefon belleğinde yoksa sıfırdan oluşturur
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // SQLite tablosunu oluşturan fonksiyon (CRUD için ilk adım)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL
      )
    ''');
  }
}