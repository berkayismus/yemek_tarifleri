import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/recipe.dart';
import '../../presentation/pages/discover_page.dart';
import '../../presentation/pages/saved_recipes_page.dart';
import '../../presentation/pages/recipe_detail_page.dart';
import '../../presentation/pages/recipe_form_page.dart';
import '../../presentation/pages/category_list_page.dart';
import '../../presentation/pages/category_recipe_list_page.dart';
import '../../presentation/pages/home_page.dart';

final _recipeDetailRoute = GoRoute(
  path: 'recipe/:slug',
  builder: (_, state) {
    final recipe = state.extra as Recipe?;
    if (recipe == null) {
      return const Scaffold(
        body: Center(child: Text('Tarif bulunamadı')),
      );
    }
    return RecipeDetailPage(recipe: recipe);
  },
);

final _recipeFormRoute = GoRoute(
  path: 'recipe-form',
  builder: (_, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return RecipeFormPage(
      recipe: extra?['recipe'] as Recipe?,
      defaultCategory: extra?['defaultCategory'] as String?,
    );
  },
);

final appRouter = GoRouter(
  initialLocation: '/discover',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomePage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (_, _) => const DiscoverPage(),
              routes: [
                _recipeDetailRoute,
                _recipeFormRoute,
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/saved',
              builder: (_, _) => const SavedRecipesPage(),
              routes: [
                _recipeDetailRoute,
                _recipeFormRoute,
                GoRoute(
                  path: 'categories',
                  builder: (_, _) => const CategoryListPage(),
                  routes: [
                    GoRoute(
                      path: ':category',
                      builder: (_, state) => CategoryRecipeListPage(
                          category: state.pathParameters['category']!),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
