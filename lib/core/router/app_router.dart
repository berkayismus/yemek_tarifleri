import 'package:go_router/go_router.dart';
import '../../domain/entities/recipe.dart';
import '../../presentation/pages/discover_page.dart';
import '../../presentation/pages/saved_recipes_page.dart';
import '../../presentation/pages/recipe_detail_shell.dart';
import '../../presentation/pages/recipe_form_page.dart';
import '../../presentation/pages/category_list_page.dart';
import '../../presentation/pages/category_recipe_list_page.dart';
import '../../presentation/pages/home_page.dart';

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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/saved',
              builder: (_, _) => const SavedRecipesPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/recipe/:id',
      builder: (_, state) {
        final recipeId = state.pathParameters['id']!;
        final recipe = state.extra as Recipe?;
        return RecipeDetailShell(recipeId: recipeId, recipe: recipe);
      },
    ),
    GoRoute(
      path: '/recipe-form',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return RecipeFormPage(
          recipe: extra?['recipe'] as Recipe?,
          defaultCategory: extra?['defaultCategory'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (_, _) => const CategoryListPage(),
    ),
    GoRoute(
      path: '/category-recipes',
      builder: (_, state) =>
          CategoryRecipeListPage(category: state.extra as String),
    ),
  ],
);
