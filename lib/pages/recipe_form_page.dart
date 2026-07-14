import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeFormPage extends StatefulWidget {
  final RecipeService recipeService;
  final Recipe? recipe;

  const RecipeFormPage({
    super.key,
    required this.recipeService,
    this.recipe,
  });

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _imageUrlController;

  bool get isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe?.name ?? '');
    _categoryController =
        TextEditingController(text: widget.recipe?.category ?? '');
    _ingredientsController =
        TextEditingController(text: widget.recipe?.ingredients ?? '');
    _instructionsController =
        TextEditingController(text: widget.recipe?.instructions ?? '');
    _imageUrlController =
        TextEditingController(text: widget.recipe?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final imageUrl = _imageUrlController.text.trim();

    if (isEditing) {
      widget.recipe!.name = _nameController.text.trim();
      widget.recipe!.category = _categoryController.text.trim();
      widget.recipe!.ingredients = _ingredientsController.text.trim();
      widget.recipe!.instructions = _instructionsController.text.trim();
      widget.recipe!.imageUrl = imageUrl.isNotEmpty ? imageUrl : null;
      widget.recipeService.update(widget.recipe!.id, widget.recipe!);
    } else {
      final recipe = Recipe(
        id: widget.recipeService.generateId(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        ingredients: _ingredientsController.text.trim(),
        instructions: _instructionsController.text.trim(),
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      widget.recipeService.add(recipe);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Tarifi Düzenle' : 'Yeni Tarif Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Yemek Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Yemek adı gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Örn: Çorba, Ana Yemek, Tatlı',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Kategori gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Görsel URL (opsiyonel)',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Malzemeler',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Malzemeler gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Hazırlanışı',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Hazırlanış gerekli' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditing ? 'Güncelle' : 'Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
