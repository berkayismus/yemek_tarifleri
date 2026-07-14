import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';
import '../../core/utils/slug.dart';

class CategoryRecipeListPage extends StatelessWidget {
  final String category;

  const CategoryRecipeListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, List<Recipe>>(
      builder: (context, state) {
        final cubit = context.read<RecipeCubit>();
        final recipes = cubit.getByCategory(category);

        void navigateToForm({Recipe? recipe}) {
          context.push('/recipe-form',
              extra: recipe != null
                  ? {'recipe': recipe}
                  : {'defaultCategory': category});
        }

        Future<void> deleteRecipe(Recipe recipe) async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(t.categoryRecipes.deleteTitle),
              content: Text(
                  t.categoryRecipes.deleteContent(name: recipe.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(t.common.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(t.common.delete,
                      style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            cubit.deleteRecipe(recipe.id);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(category),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: recipes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restaurant_menu,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        t.categoryRecipes.empty,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () => navigateToForm(),
                        icon: const Icon(Icons.add),
                        label: Text(t.categoryRecipes.addRecipe),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: recipe.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
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
                        subtitle: recipe.ingredients.isNotEmpty
                            ? Text(
                                recipe.ingredients,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade700),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueGrey),
                              onPressed: () =>
                                  navigateToForm(recipe: recipe),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () => deleteRecipe(recipe),
                            ),
                          ],
                        ),
                        onTap: () => context.go(
                            '/recipe/${recipeSlug(recipe.name)}',
                            extra: recipe),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => navigateToForm(),
            tooltip: t.categoryRecipes.newRecipeTooltip,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
