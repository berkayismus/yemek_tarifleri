import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';

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
          context.go('/recipe-form',
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
            title: Text(category,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: recipes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restaurant_menu,
                            size: 72, color: Colors.grey.shade300),
                        const SizedBox(height: 20),
                        Text(
                          t.categoryRecipes.empty,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => navigateToForm(),
                          icon: const Icon(Icons.add),
                          label: Text(t.categoryRecipes.addRecipe),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    final colorScheme = Theme.of(context).colorScheme;
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.go(
                            '/recipe/${recipe.id}',
                            extra: recipe),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: recipe.imageUrl != null
                                      ? Image.network(
                                          recipe.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                                Icons.restaurant,
                                                color: Colors.grey),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                              Icons.restaurant,
                                              color: Colors.grey),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        recipe.category,
                                        style: TextStyle(
                                          color: colorScheme
                                              .onPrimaryContainer,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    if (recipe.ingredients.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        recipe.ingredients,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20, color: Colors.grey),
                                    onPressed: () =>
                                        navigateToForm(recipe: recipe),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                        minWidth: 36, minHeight: 36),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        size: 20, color: Color(0xFFE57373)),
                                    onPressed: () => deleteRecipe(recipe),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                        minWidth: 36, minHeight: 36),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => navigateToForm(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
