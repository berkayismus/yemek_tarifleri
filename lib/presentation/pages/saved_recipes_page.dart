import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';
import '../widgets/language_switch.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key});

  @override
  State<SavedRecipesPage> createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _navigateToForm({Recipe? recipe}) {
    context.go('/recipe-form',
        extra: recipe != null ? {'recipe': recipe} : null);
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

  Future<void> _deleteAll() async {
    final cubit = context.read<RecipeCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.saved.deleteAllTitle),
        content: Text(t.saved.deleteAllContent),
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
      cubit.deleteAll();
    }
  }

  void _showRandomLocal() {
    final random = context.read<RecipeCubit>().getRandom();
    if (random != null) {
      context.go('/recipe/${random.id}', extra: random);
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
    final hasRecipes = context.watch<RecipeCubit>().state.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.saved.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          const LanguageSwitch(),
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: t.saved.categoriesTooltip,
            onPressed: () => context.go('/categories'),
          ),
          IconButton(
            icon: const Icon(Icons.casino_outlined),
            tooltip: t.saved.randomRecipeTooltip,
            onPressed: _showRandomLocal,
          ),
          if (hasRecipes)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'deleteAll') _deleteAll();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'deleteAll',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_sweep,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(t.saved.deleteAll),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: BlocBuilder<RecipeCubit, List<Recipe>>(
        builder: (context, recipes) {
          final filtered = _filterRecipes(recipes);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bookmark_border,
                                  size: 72, color: Colors.grey.shade300),
                              const SizedBox(height: 20),
                              Text(
                                t.saved.empty,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Colors.grey.shade500,
                                        ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () =>
                                    context.go('/discover'),
                                icon: const Icon(Icons.explore),
                                label: const Text('Keşfet'),
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
                            padding: const EdgeInsets.fromLTRB(
                                12, 0, 12, 80),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final recipe = filtered[index];
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: recipe.imageUrl !=
                                                    null
                                                ? Image.network(
                                                    recipe.imageUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, _, _) =>
                                                            Container(
                                                      color: Colors.grey
                                                          .shade200,
                                                      child: const Icon(
                                                          Icons
                                                              .restaurant,
                                                          color: Colors
                                                              .grey),
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.grey
                                                        .shade200,
                                                    child: const Icon(
                                                        Icons.restaurant,
                                                        color:
                                                            Colors.grey),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                recipe.name,
                                                style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                              const SizedBox(
                                                  height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration:
                                                    BoxDecoration(
                                                  color: colorScheme
                                                      .primaryContainer,
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(4),
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
                                              const SizedBox(
                                                  height: 4),
                                              if (recipe.ingredients
                                                  .isNotEmpty)
                                                Text(
                                                  recipe.ingredients,
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey
                                                        .shade500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                  color:
                                                      Colors.grey),
                                              onPressed: () =>
                                                  _navigateToForm(
                                                      recipe: recipe),
                                              padding:
                                                  EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(
                                                      minWidth: 36,
                                                      minHeight: 36),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons
                                                      .delete_outline,
                                                  size: 20,
                                                  color: Color(0xFFE57373)),
                                              onPressed: () =>
                                                  _deleteRecipe(
                                                      recipe),
                                              padding:
                                                  EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(
                                                      minWidth: 36,
                                                      minHeight: 36),
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
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
