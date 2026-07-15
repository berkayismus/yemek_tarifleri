import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  Future<void> _shareRecipe(BuildContext context) async {
    final segments = List<String>.from(Uri.base.pathSegments);
    if (segments.isNotEmpty) {
      segments.removeLast();
    }
    if (segments.isEmpty || segments.last != 'recipe') {
      segments.add('recipe');
    }
    segments.add(recipe.id);
    final url = Uri.base.replace(pathSegments: segments).toString();
    final subject = t.recipeDetail.shareSubject(name: recipe.name);

    try {
      await SharePlus.instance.share(
        ShareParams(text: url, subject: subject, mailToFallbackEnabled: false),
      );
    } catch (_) {
      if (!context.mounted) return;
      await Clipboard.setData(ClipboardData(text: url));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.recipeDetail.copiedToClipboard),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: t.recipeDetail.share,
                onPressed: () => _shareRecipe(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: recipe.imageUrl != null
                  ? Image.network(recipe.imageUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                            color: colorScheme.primaryContainer,
                          ))
                  : Container(color: colorScheme.primaryContainer),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      recipe.category,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    t.recipeDetail.ingredients,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.ingredients,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    t.recipeDetail.instructions,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.instructions,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
