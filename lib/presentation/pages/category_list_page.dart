import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  String _normalize(String s) => s
      .replaceAll('ı', 'i')
      .replaceAll('ü', 'u')
      .replaceAll('ğ', 'g')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .toLowerCase();

  IconData _categoryIcon(String category) {
    final n = _normalize(category);
    if (n.contains('corba')) return Icons.soup_kitchen;
    if (n.contains('tatli')) return Icons.cake;
    if (n.contains('salata')) return Icons.eco;
    if (n.contains('icecek')) return Icons.local_drink;
    if (n.contains('kahvalti')) return Icons.breakfast_dining;
    if (n.contains('makarna')) return Icons.ramen_dining;
    if (n.contains('pilav')) return Icons.rice_bowl;
    if (n.contains('et yemegi')) return Icons.kebab_dining;
    if (n.contains('deniz')) return Icons.set_meal;
    if (n.contains('ana yemek')) return Icons.dinner_dining;
    return Icons.fastfood;
  }

  Color _categoryColor(int index) {
    const colors = [
      Color(0xFFFFE0E0),
      Color(0xFFE8F5E9),
      Color(0xFFE3F2FD),
      Color(0xFFF3E5F5),
      Color(0xFFFFF3E0),
      Color(0xFFE0F2F1),
      Color(0xFFFFF9C4),
      Color(0xFFFCE4EC),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, List<Recipe>>(
      builder: (context, state) {
        final cubit = context.read<RecipeCubit>();
        final categories = cubit.getCategories();

        return Scaffold(
          appBar: AppBar(
            title: Text(t.categories.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: categories.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.category,
                            size: 72, color: Colors.grey.shade300),
                        const SizedBox(height: 20),
                        Text(
                          t.categories.empty,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.categories.emptyHint,
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final count = cubit.getByCategory(category).length;
                    return Card(
                      color: _categoryColor(index),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          context.go('/category-recipes',
                              extra: category);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_categoryIcon(category), size: 42),
                              const SizedBox(height: 12),
                              Text(
                                category,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.categories
                                    .recipeCount(n: count, count: count),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
