import 'dart:math';
import '../models/recipe.dart';

class RecipeService {
  final List<Recipe> _recipes = [];
  int _nextId = 1;
  final _random = Random();

  List<Recipe> getAll() => List.unmodifiable(_recipes);

  Recipe? getRandom() {
    if (_recipes.isEmpty) return null;
    return _recipes[_random.nextInt(_recipes.length)];
  }

  Recipe? getById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Recipe recipe) {
    _recipes.add(recipe);
  }

  void update(String id, Recipe updated) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _recipes[index] = updated;
    }
  }

  void delete(String id) {
    _recipes.removeWhere((r) => r.id == id);
  }

  String generateId() => (_nextId++).toString();
}
