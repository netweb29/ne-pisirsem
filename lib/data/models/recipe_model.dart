class RecipeModel {
  final int? id;
  final String title;
  final String ingredients;
  final String instructions;

  RecipeModel({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
  });

  // 1. SQLite'tan gelen veriyi (Map) Dart nesnesine dönüştürür (Raporda açıkla!)
  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      ingredients: map['ingredients'] as String,
      instructions: map['instructions'] as String,
    );
  }

  // 2. Dart nesnesini SQLite'a kaydetmek için Map formatına çevirir (Raporda açıkla!)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }
}