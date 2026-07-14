import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/discover_state.dart';
import '../../domain/entities/recipe.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../i18n/strings.g.dart';
import '../../core/utils/slug.dart';
import '../widgets/language_switch.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final RecipeRemoteDataSource _remoteDataSource = RecipeRemoteDataSource();
  late final TextEditingController _searchController;
  bool _loading = false;
  List<Recipe> _results = [];

  @override
  void initState() {
    super.initState();
    final state = DiscoverState.instance;
    _searchController = TextEditingController(text: state.searchQuery);
    _results = state.results;
    _loading = state.loading;
  }

  void _persistState() {
    final state = DiscoverState.instance;
    state.searchQuery = _searchController.text.trim();
    state.results = _results;
    state.loading = _loading;
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);
    _persistState();
    final results = await _remoteDataSource.searchMeals(query);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _results = results;
    });
    _persistState();

    if (results.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.discover.noResults(query: query)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _saveRecipe(Recipe recipe) {
    final cubit = context.read<RecipeCubit>();
    if (cubit.getById(recipe.id) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.discover.alreadySaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    cubit.addRecipe(recipe);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.discover.saved(name: recipe.name)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _persistState();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RecipeCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.discover.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: const [
          LanguageSwitch(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: t.discover.searchHint,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.travel_explore,
                              size: 72, color: Colors.grey.shade300),
                          const SizedBox(height: 20),
                          Text(
                            t.discover.searchPrompt,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final recipe = _results[index];
                      final isSaved = cubit.getById(recipe.id) != null;
                      return GestureDetector(
                        onTap: () => context.go(
                            '/recipe/${recipeSlug(recipe.name)}',
                            extra: recipe),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    recipe.imageUrl != null
                                        ? Image.network(
                                            recipe.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                  Icons.restaurant,
                                                  size: 40,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                                Icons.restaurant,
                                                size: 40,
                                                color: Colors.grey),
                                          ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Material(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () =>
                                              _saveRecipe(recipe),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(6),
                                            child: Icon(
                                              isSaved
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              size: 20,
                                              color: isSaved
                                                  ? colorScheme.primary
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10, 8, 10, 10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colorScheme
                                            .primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        recipe.category,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colorScheme
                                              .onPrimaryContainer,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
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
