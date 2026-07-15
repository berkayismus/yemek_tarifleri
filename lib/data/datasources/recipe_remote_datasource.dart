import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/recipe.dart';
import '../models/recipe_model.dart';

class RecipeRemoteDataSource {
  static const _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<Recipe?> getRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/random.php'));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) return null;

      return _parseMeal(meals.first);
    } catch (_) {
      return null;
    }
  }

  Future<List<Recipe>> searchMeals(String query) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final meals = data['meals'] as List?;
      if (meals == null) return [];

      return meals.map((m) => _parseMeal(m)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Recipe?> lookupMealById(String id) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) return null;

      return _parseMeal(meals.first);
    } catch (_) {
      return null;
    }
  }

  RecipeModel _parseMeal(Map<String, dynamic> m) {
    final ingredients = StringBuffer();
    for (int i = 1; i <= 20; i++) {
      final ingredient = m['strIngredient$i'] as String?;
      final measure = m['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.isNotEmpty) {
        if (ingredients.isNotEmpty) ingredients.write('\n');
        ingredients.write('$measure $ingredient'.trim());
      }
    }

    return RecipeModel(
      id: m['idMeal'] ?? '',
      name: m['strMeal'] ?? '',
      category: m['strCategory'] ?? '',
      ingredients: ingredients.toString(),
      instructions: m['strInstructions'] ?? '',
      imageUrl: m['strMealThumb'],
    );
  }
}
