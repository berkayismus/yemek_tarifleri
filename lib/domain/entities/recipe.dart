class Recipe {
  final String id;
  final String name;
  final String category;
  final String ingredients;
  final String instructions;
  final String? imageUrl;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? category,
    String? ingredients,
    String? instructions,
    String? imageUrl,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
