import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> searchRecipes(String query);
  Future<Recipe?> getRandomRecipe();
  Future<Recipe?> lookupById(String id);
}
