import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';
import '../../i18n/strings.g.dart';

class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe;
  final String? defaultCategory;

  const RecipeFormPage({
    super.key,
    this.recipe,
    this.defaultCategory,
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
    _categoryController = TextEditingController(
        text: widget.recipe?.category ?? widget.defaultCategory ?? '');
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
    final cubit = context.read<RecipeCubit>();

    if (isEditing) {
      final updated = widget.recipe!.copyWith(
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        ingredients: _ingredientsController.text.trim(),
        instructions: _instructionsController.text.trim(),
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      cubit.updateRecipe(widget.recipe!.id, updated);
    } else {
      final recipe = Recipe(
        id: cubit.generateId(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        ingredients: _ingredientsController.text.trim(),
        instructions: _instructionsController.text.trim(),
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      cubit.addRecipe(recipe);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEditing ? t.recipeForm.editTitle : t.recipeForm.newTitle),
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
                decoration: InputDecoration(
                  labelText: t.recipeForm.nameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? t.recipeForm.nameRequired
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: t.recipeForm.categoryLabel,
                  hintText: t.recipeForm.categoryHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? t.recipeForm.categoryRequired
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: t.recipeForm.imageUrlLabel,
                  hintText: t.recipeForm.imageUrlHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: t.recipeForm.ingredientsLabel,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? t.recipeForm.ingredientsRequired
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  labelText: t.recipeForm.instructionsLabel,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? t.recipeForm.instructionsRequired
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditing
                    ? t.recipeForm.updateButton
                    : t.recipeForm.saveButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
