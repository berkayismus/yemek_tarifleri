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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        ingredients: json['ingredients'] as String,
        instructions: json['instructions'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}
