import '../../domain/entities/recipe.dart';

class DiscoverState {
  static final DiscoverState instance = DiscoverState._();
  DiscoverState._();

  List<Recipe> results = [];
  String searchQuery = '';
  bool loading = false;
}
