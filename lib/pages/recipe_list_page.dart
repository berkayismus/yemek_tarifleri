import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/recipe_cubit.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../i18n/strings.g.dart';
import 'recipe_form_page.dart';
import 'recipe_detail_page.dart';
import 'category_list_page.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;

  void _navigateToForm({Recipe? recipe}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeFormPage(recipe: recipe),
      ),
    );
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    final cubit = context.read<RecipeCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.recipeList.deleteTitle),
        content: Text(t.recipeList.deleteContent(name: recipe.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.common.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      cubit.deleteRecipe(recipe.id);
    }
  }

  Future<void> _fetchRandomFromApi() async {
    setState(() => _loading = true);
    final meal = await _apiService.getRandomMeal();
    if (!mounted) return;
    setState(() => _loading = false);

    if (meal != null) {
      context.read<RecipeCubit>().addRecipe(meal);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.recipeList.added(name: meal.name))),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.recipeList.fetchFailed)),
      );
    }
  }

  Future<void> _searchFromApi() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);
    final results = await _apiService.searchMeals(query);
    if (!mounted) return;
    setState(() => _loading = false);

    if (results.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.recipeList.noResults(query: query))),
      );
      return;
    }

    final cubit = context.read<RecipeCubit>();
    for (final recipe in results) {
      if (cubit.getById(recipe.id) == null) {
        cubit.addRecipe(recipe);
      }
    }
    _searchController.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.recipeList.addedMultiple(n: results.length, count: results.length))),
    );
  }

  void _showRandomLocal() {
    final random = context.read<RecipeCubit>().getRandom();
    if (random != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: random)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.recipeList.noRecipe)),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: t.recipeList.categoriesTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoryListPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: t.recipeList.randomRecipeTooltip,
            onPressed: _showRandomLocal,
          ),
          IconButton(
            icon: const Icon(Icons.cloud_download),
            tooltip: t.recipeList.fetchFromApiTooltip,
            onPressed: _loading ? null : _fetchRandomFromApi,
          ),
        ],
      ),
      body: BlocBuilder<RecipeCubit, List<Recipe>>(
        builder: (context, recipes) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: t.recipeList.searchHint,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                        ),
                        onSubmitted: (_) => _searchFromApi(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _searchFromApi,
                        child: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(t.recipeList.searchButton),
                      ),
                    ),
                  ],
                ),
              ),
              _loading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
              Expanded(
                child: recipes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restaurant_menu,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              t.recipeList.empty,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed:
                                  _loading ? null : _fetchRandomFromApi,
                              icon:
                                  const Icon(Icons.cloud_download),
                              label: Text(t.recipeList.fetchFromApiButton),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 80),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return Card(
                            margin:
                                const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: recipe.imageUrl != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      child: Image.network(
                                        recipe.imageUrl!,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            const Icon(Icons.restaurant,
                                                size: 40),
                                      ),
                                    )
                                  : const Icon(Icons.restaurant, size: 40),
                              title: Text(recipe.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(recipe.category,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  if (recipe.ingredients.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      recipe.ingredients,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueGrey),
                                    onPressed: () =>
                                        _navigateToForm(recipe: recipe),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteRecipe(recipe),
                                  ),
                                ],
                              ),
                              onTap: () =>
                                  Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RecipeDetailPage(
                                      recipe: recipe),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: t.recipeList.newRecipeTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
