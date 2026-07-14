import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/recipe_cubit.dart';
import '../models/recipe.dart';
import '../i18n/strings.g.dart';
import 'recipe_form_page.dart';
import 'recipe_detail_page.dart';
import 'category_list_page.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key});

  @override
  State<SavedRecipesPage> createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        title: Text(t.saved.deleteTitle),
        content: Text(t.saved.deleteContent(name: recipe.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child:
                Text(t.common.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      cubit.deleteRecipe(recipe.id);
    }
  }

  void _showRandomLocal() {
    final random = context.read<RecipeCubit>().getRandom();
    if (random != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: random)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.saved.noRecipe)),
      );
    }
  }

  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    if (_searchQuery.isEmpty) return recipes;
    return recipes
        .where((r) => r.name.toLowerCase().contains(_searchQuery))
        .toList();
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
        title: Text(t.saved.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: t.saved.categoriesTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoryListPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: t.saved.randomRecipeTooltip,
            onPressed: _showRandomLocal,
          ),
        ],
      ),
      body: BlocBuilder<RecipeCubit, List<Recipe>>(
        builder: (context, recipes) {
          final filtered = _filterRecipes(recipes);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.saved.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                  ),
                  onChanged: (value) {
                    setState(
                        () => _searchQuery = value.trim().toLowerCase());
                  },
                ),
              ),
              Expanded(
                child: recipes.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bookmark_border,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                t.saved.empty,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t.saved.emptyHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off,
                                    size: 64,
                                    color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  t.saved.noResults,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(8, 0, 8, 80),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final recipe = filtered[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(
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
                                                const Icon(
                                                    Icons.restaurant,
                                                    size: 40),
                                          ),
                                        )
                                      : const Icon(Icons.restaurant,
                                          size: 40),
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
                                            color:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      if (recipe
                                          .ingredients.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          recipe.ingredients,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors
                                                  .grey.shade700),
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
                                        onPressed: () => _navigateToForm(
                                            recipe: recipe),
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
        tooltip: t.saved.newRecipeTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
