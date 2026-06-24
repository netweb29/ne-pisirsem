import 'package:sqflite/sqflite.dart';
import '../models/recipe_model.dart';
import 'database_helper.dart';

class RecipeDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // C (Create): Yeni tarif ekleme
  Future<int> insertRecipe(RecipeModel recipe) async {
    final db = await _dbHelper.database;
    return await db.insert('recipes', recipe.toMap());
  }

  // R (Read): Tüm favori tarifleri listeleme
  Future<List<RecipeModel>> getAllRecipes() async {
    final db = await _dbHelper.database;
    final result = await db.query('recipes', orderBy: 'id DESC');

    return result.map((json) => RecipeModel.fromMap(json)).toList();
  }

  // D (Delete): Tarifi veritabanından silme
  Future<int> deleteRecipe(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}