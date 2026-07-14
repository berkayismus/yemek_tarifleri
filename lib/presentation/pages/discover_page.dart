import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../i18n/strings.g.dart';
import '../../core/utils/slug.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final RecipeRemoteDataSource _remoteDataSource = RecipeRemoteDataSource();
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;
  List<Recipe> _results = [];

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);
    final results = await _remoteDataSource.searchMeals(query);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _results = results;
    });

    if (results.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.discover.noResults(query: query))),
      );
    }
  }

  void _saveRecipe(Recipe recipe) {
    final cubit = context.read<RecipeCubit>();
    if (cubit.getById(recipe.id) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.discover.alreadySaved)),
      );
      return;
    }
    cubit.addRecipe(recipe);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.discover.saved(name: recipe.name))),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RecipeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.discover.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: t.discover.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _search,
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(t.discover.searchButton),
                  ),
                ),
              ],
            ),
          ),
          _loading
              ? const LinearProgressIndicator()
              : const SizedBox.shrink(),
          Expanded(
            child: _results.isEmpty && !_loading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.travel_explore,
                              size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            t.discover.searchPrompt,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final recipe = _results[index];
                      final isSaved = cubit.getById(recipe.id) != null;
                      return InkWell(
                        onTap: () => context.push(
                            'recipe/${recipeSlug(recipe.name)}',
                            extra: recipe),
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 2,
                              child: recipe.imageUrl != null
                                  ? Image.network(
                                      recipe.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.restaurant,
                                            size: 40),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.restaurant,
                                          size: 40),
                                    ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      recipe.category,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: Icon(
                                          isSaved
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: isSaved
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : null,
                                        ),
                                        tooltip: t.discover.saveTooltip,
                                        onPressed: isSaved
                                            ? null
                                            : () => _saveRecipe(recipe),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
