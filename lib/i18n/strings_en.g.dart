///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'Food Recipes';
	@override late final _Translations$nav$en nav = _Translations$nav$en._(_root);
	@override late final _Translations$discover$en discover = _Translations$discover$en._(_root);
	@override late final _Translations$saved$en saved = _Translations$saved$en._(_root);
	@override late final _Translations$common$en common = _Translations$common$en._(_root);
	@override late final _Translations$recipeForm$en recipeForm = _Translations$recipeForm$en._(_root);
	@override late final _Translations$categories$en categories = _Translations$categories$en._(_root);
	@override late final _Translations$categoryRecipes$en categoryRecipes = _Translations$categoryRecipes$en._(_root);
	@override late final _Translations$recipeDetail$en recipeDetail = _Translations$recipeDetail$en._(_root);
}

// Path: nav
class _Translations$nav$en implements Translations$nav$tr {
	_Translations$nav$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get discover => 'Discover';
	@override String get saved => 'Saved';
}

// Path: discover
class _Translations$discover$en implements Translations$discover$tr {
	_Translations$discover$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Discover';
	@override String get searchHint => 'Search recipes in API...';
	@override String get searchButton => 'Search';
	@override String noResults({required Object query}) => 'No results found for ${query}.';
	@override String get searchPrompt => 'Use the search field above to find recipes';
	@override String saved({required Object name}) => '${name} saved!';
	@override String get alreadySaved => 'This recipe is already saved';
	@override String get saveTooltip => 'Save';
	@override String get fetchFailed => 'Could not fetch recipe.';
}

// Path: saved
class _Translations$saved$en implements Translations$saved$tr {
	_Translations$saved$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Saved Recipes';
	@override String get searchHint => 'Search recipes...';
	@override String get noResults => 'No recipes match your search.';
	@override String get empty => 'No saved recipes yet';
	@override String get emptyHint => 'Use the Discover tab to search and save recipes';
	@override String get randomRecipeTooltip => 'Suggest Random Recipe';
	@override String get categoriesTooltip => 'Categories';
	@override String get newRecipeTooltip => 'New Recipe';
	@override String get noRecipe => 'No recipes yet.';
	@override String get deleteTitle => 'Delete Recipe';
	@override String deleteContent({required Object name}) => 'Are you sure you want to delete ${name}?';
}

// Path: common
class _Translations$common$en implements Translations$common$tr {
	_Translations$common$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
}

// Path: recipeForm
class _Translations$recipeForm$en implements Translations$recipeForm$tr {
	_Translations$recipeForm$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get editTitle => 'Edit Recipe';
	@override String get newTitle => 'Add New Recipe';
	@override String get nameLabel => 'Recipe Name';
	@override String get categoryLabel => 'Category';
	@override String get categoryHint => 'e.g. Soup, Main Course, Dessert';
	@override String get imageUrlLabel => 'Image URL (optional)';
	@override String get imageUrlHint => 'https://...';
	@override String get ingredientsLabel => 'Ingredients';
	@override String get instructionsLabel => 'Instructions';
	@override String get updateButton => 'Update';
	@override String get saveButton => 'Save';
	@override String get nameRequired => 'Recipe name is required';
	@override String get categoryRequired => 'Category is required';
	@override String get ingredientsRequired => 'Ingredients are required';
	@override String get instructionsRequired => 'Instructions are required';
}

// Path: categories
class _Translations$categories$en implements Translations$categories$tr {
	_Translations$categories$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Categories';
	@override String get empty => 'No categories yet';
	@override String get emptyHint => 'You can create categories by adding new recipes';
	@override String recipeCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${count} recipe',
		other: '${count} recipes',
	);
}

// Path: categoryRecipes
class _Translations$categoryRecipes$en implements Translations$categoryRecipes$tr {
	_Translations$categoryRecipes$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get empty => 'No recipes in this category';
	@override String get addRecipe => 'Add Recipe';
	@override String get newRecipeTooltip => 'New Recipe';
	@override String get deleteTitle => 'Delete Recipe';
	@override String deleteContent({required Object name}) => 'Are you sure you want to delete ${name}?';
}

// Path: recipeDetail
class _Translations$recipeDetail$en implements Translations$recipeDetail$tr {
	_Translations$recipeDetail$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get ingredients => 'Ingredients';
	@override String get instructions => 'Instructions';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Food Recipes',
			'nav.discover' => 'Discover',
			'nav.saved' => 'Saved',
			'discover.title' => 'Discover',
			'discover.searchHint' => 'Search recipes in API...',
			'discover.searchButton' => 'Search',
			'discover.noResults' => ({required Object query}) => 'No results found for ${query}.',
			'discover.searchPrompt' => 'Use the search field above to find recipes',
			'discover.saved' => ({required Object name}) => '${name} saved!',
			'discover.alreadySaved' => 'This recipe is already saved',
			'discover.saveTooltip' => 'Save',
			'discover.fetchFailed' => 'Could not fetch recipe.',
			'saved.title' => 'Saved Recipes',
			'saved.searchHint' => 'Search recipes...',
			'saved.noResults' => 'No recipes match your search.',
			'saved.empty' => 'No saved recipes yet',
			'saved.emptyHint' => 'Use the Discover tab to search and save recipes',
			'saved.randomRecipeTooltip' => 'Suggest Random Recipe',
			'saved.categoriesTooltip' => 'Categories',
			'saved.newRecipeTooltip' => 'New Recipe',
			'saved.noRecipe' => 'No recipes yet.',
			'saved.deleteTitle' => 'Delete Recipe',
			'saved.deleteContent' => ({required Object name}) => 'Are you sure you want to delete ${name}?',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'recipeForm.editTitle' => 'Edit Recipe',
			'recipeForm.newTitle' => 'Add New Recipe',
			'recipeForm.nameLabel' => 'Recipe Name',
			'recipeForm.categoryLabel' => 'Category',
			'recipeForm.categoryHint' => 'e.g. Soup, Main Course, Dessert',
			'recipeForm.imageUrlLabel' => 'Image URL (optional)',
			'recipeForm.imageUrlHint' => 'https://...',
			'recipeForm.ingredientsLabel' => 'Ingredients',
			'recipeForm.instructionsLabel' => 'Instructions',
			'recipeForm.updateButton' => 'Update',
			'recipeForm.saveButton' => 'Save',
			'recipeForm.nameRequired' => 'Recipe name is required',
			'recipeForm.categoryRequired' => 'Category is required',
			'recipeForm.ingredientsRequired' => 'Ingredients are required',
			'recipeForm.instructionsRequired' => 'Instructions are required',
			'categories.title' => 'Categories',
			'categories.empty' => 'No categories yet',
			'categories.emptyHint' => 'You can create categories by adding new recipes',
			'categories.recipeCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} recipe', other: '${count} recipes', ), 
			'categoryRecipes.empty' => 'No recipes in this category',
			'categoryRecipes.addRecipe' => 'Add Recipe',
			'categoryRecipes.newRecipeTooltip' => 'New Recipe',
			'categoryRecipes.deleteTitle' => 'Delete Recipe',
			'categoryRecipes.deleteContent' => ({required Object name}) => 'Are you sure you want to delete ${name}?',
			'recipeDetail.ingredients' => 'Ingredients',
			'recipeDetail.instructions' => 'Instructions',
			_ => null,
		};
	}
}
