import 'dart:math';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';

class RecipeCubit extends HydratedCubit<List<Recipe>> {
  final RecipeRepository _repository;
  final _random = Random();

  RecipeCubit(this._repository) : super([]);

  @override
  List<Recipe> fromJson(Map<String, dynamic> json) {
    final list = json['recipes'] as List<dynamic>?;
    if (list == null) return [];
    return list
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Map<String, dynamic> toJson(List<Recipe> recipes) => {
        'recipes':
            recipes.map((r) => RecipeModel.fromEntity(r).toJson()).toList(),
      };

  int get _nextId {
    if (state.isEmpty) return 1;
    int maxId = 0;
    for (final r in state) {
      final id = int.tryParse(r.id) ?? 0;
      if (id > maxId) maxId = id;
    }
    return maxId + 1;
  }

  String generateId() => _nextId.toString();

  void addRecipe(Recipe recipe) => emit([...state, recipe]);

  void updateRecipe(String id, Recipe updated) =>
      emit(state.map((r) => r.id == id ? updated : r).toList());

  void deleteRecipe(String id) =>
      emit(state.where((r) => r.id != id).toList());

  void deleteAll() => emit([]);

  Recipe? getById(String id) {
    try {
      return state.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Recipe? getRandom() {
    if (state.isEmpty) return null;
    return state[_random.nextInt(state.length)];
  }

  List<String> getCategories() =>
      state.map((r) => r.category).toSet().toList()..sort();

  List<Recipe> getByCategory(String category) =>
      state.where((r) => r.category == category).toList();

  Future<List<Recipe>> searchApiRecipes(String query) =>
      _repository.searchRecipes(query);

  Future<Recipe?> getRandomApiRecipe() => _repository.getRandomRecipe();

  Future<Recipe?> resolveRecipe(String id) {
    final local = getById(id);
    if (local != null) return Future.value(local);
    return _repository.lookupById(id);
  }
}
