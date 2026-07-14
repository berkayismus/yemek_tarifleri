import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.category,
    required super.ingredients,
    required super.instructions,
    super.imageUrl,
  });

  factory RecipeModel.fromEntity(Recipe entity) => RecipeModel(
        id: entity.id,
        name: entity.name,
        category: entity.category,
        ingredients: entity.ingredients,
        instructions: entity.instructions,
        imageUrl: entity.imageUrl,
      );

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        ingredients: json['ingredients'] as String,
        instructions: json['instructions'] as String,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
      };
}
