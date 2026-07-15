import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _remoteDataSource;

  RecipeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Recipe>> searchRecipes(String query) =>
      _remoteDataSource.searchMeals(query);

  @override
  Future<Recipe?> getRandomRecipe() => _remoteDataSource.getRandomMeal();

  @override
  Future<Recipe?> lookupById(String id) => _remoteDataSource.lookupMealById(id);
}
