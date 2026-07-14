import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../services/api_service.dart';
import 'recipe_form_page.dart';
import 'recipe_detail_page.dart';

class RecipeListPage extends StatefulWidget {
  final RecipeService recipeService;

  const RecipeListPage({super.key, required this.recipeService});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;

  List<Recipe> get recipes => widget.recipeService.getAll();

  void _refresh() => setState(() {});

  Future<void> _navigateToForm({Recipe? recipe}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RecipeFormPage(
          recipeService: widget.recipeService,
          recipe: recipe,
        ),
      ),
    );
    if (result == true) _refresh();
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tarifi Sil'),
        content:
            Text('"${recipe.name}" tarifini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.recipeService.delete(recipe.id);
      _refresh();
    }
  }

  Future<void> _fetchRandomFromApi() async {
    setState(() => _loading = true);
    final meal = await _apiService.getRandomMeal();
    if (!mounted) return;
    setState(() => _loading = false);

    if (meal != null) {
      widget.recipeService.add(meal);
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${meal.name}" eklendi!')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarif alınamadı.')),
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
        SnackBar(content: Text('"$query" için sonuç bulunamadı.')),
      );
      return;
    }

    for (final recipe in results) {
      if (widget.recipeService.getById(recipe.id) == null) {
        widget.recipeService.add(recipe);
      }
    }
    _refresh();
    _searchController.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${results.length} tarif eklendi.')),
    );
  }

  void _showRandomLocal() {
    final random = widget.recipeService.getRandom();
    if (random != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: random)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Henüz hiç tarif yok.')),
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
        title: const Text('Yemek Tarifleri'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Rastgele Tarif Öner',
            onPressed: _showRandomLocal,
          ),
          IconButton(
            icon: const Icon(Icons.cloud_download),
            tooltip: 'API\'den Rastgele Tarif Getir',
            onPressed: _loading ? null : _fetchRandomFromApi,
          ),
        ],
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
                      hintText: 'API\'de tarif ara...',
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
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ara'),
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
                          'Henüz tarif eklenmedi',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: _loading ? null : _fetchRandomFromApi,
                          icon: const Icon(Icons.cloud_download),
                          label: const Text('API\'den Rastgele Tarif Getir'),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(color: Colors.grey.shade700),
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
                                onPressed: () => _deleteRecipe(recipe),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Yeni Tarif',
        child: const Icon(Icons.add),
      ),
    );
  }
}
