import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../i18n/strings.g.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (recipe.imageUrl != null)
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(recipe.imageUrl!, fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20),
                      const SizedBox(width: 6),
                      Text(recipe.category,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(t.recipeDetail.ingredients,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(recipe.ingredients,
                      style: const TextStyle(fontSize: 15, height: 1.6)),
                  const Divider(height: 24),
                  Text(t.recipeDetail.instructions,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(recipe.instructions,
                      style: const TextStyle(fontSize: 15, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
