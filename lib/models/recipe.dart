class Recipe {
  final String id;
  String name;
  String category;
  String ingredients;
  String instructions;
  String? imageUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
  });
}
