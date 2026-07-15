import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';
import '../cubit/recipe_cubit.dart';
import 'recipe_detail_page.dart';

class RecipeDetailShell extends StatelessWidget {
  final String recipeId;
  final Recipe? recipe;

  const RecipeDetailShell({
    super.key,
    required this.recipeId,
    this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    if (recipe != null) {
      return RecipeDetailPage(recipe: recipe!);
    }

    return _RecipeDetailLoader(recipeId: recipeId);
  }
}

class _RecipeDetailLoader extends StatefulWidget {
  final String recipeId;

  const _RecipeDetailLoader({required this.recipeId});

  @override
  State<_RecipeDetailLoader> createState() => _RecipeDetailLoaderState();
}

class _RecipeDetailLoaderState extends State<_RecipeDetailLoader> {
  Recipe? _recipe;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cubit = context.read<RecipeCubit>();
    final recipe = await cubit.resolveRecipe(widget.recipeId);
    if (!mounted) return;
    setState(() {
      _recipe = recipe;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_recipe == null) {
      return Scaffold(
        body: Center(child: Text(t.recipeDetail.notFound)),
      );
    }
    return RecipeDetailPage(recipe: _recipe!);
  }
}
