///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsTr = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// tr: 'Yemek Tarifleri'
	String get appTitle => 'Yemek Tarifleri';

	late final Translations$nav$tr nav = Translations$nav$tr._(_root);
	late final Translations$discover$tr discover = Translations$discover$tr._(_root);
	late final Translations$saved$tr saved = Translations$saved$tr._(_root);
	late final Translations$common$tr common = Translations$common$tr._(_root);
	late final Translations$recipeForm$tr recipeForm = Translations$recipeForm$tr._(_root);
	late final Translations$categories$tr categories = Translations$categories$tr._(_root);
	late final Translations$categoryRecipes$tr categoryRecipes = Translations$categoryRecipes$tr._(_root);
	late final Translations$recipeDetail$tr recipeDetail = Translations$recipeDetail$tr._(_root);
}

// Path: nav
class Translations$nav$tr {
	Translations$nav$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Keşfet'
	String get discover => 'Keşfet';

	/// tr: 'Kaydedilenler'
	String get saved => 'Kaydedilenler';
}

// Path: discover
class Translations$discover$tr {
	Translations$discover$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Keşfet'
	String get title => 'Keşfet';

	/// tr: 'API'de tarif ara...'
	String get searchHint => 'API\'de tarif ara...';

	/// tr: 'Ara'
	String get searchButton => 'Ara';

	/// tr: '$query için sonuç bulunamadı.'
	String noResults({required Object query}) => '${query} için sonuç bulunamadı.';

	/// tr: 'Yemek tarifi aramak için yukarıdaki alanı kullanın'
	String get searchPrompt => 'Yemek tarifi aramak için yukarıdaki alanı kullanın';

	/// tr: '$name kaydedildi!'
	String saved({required Object name}) => '${name} kaydedildi!';

	/// tr: 'Bu tarif zaten kaydedilmiş'
	String get alreadySaved => 'Bu tarif zaten kaydedilmiş';

	/// tr: 'Kaydet'
	String get saveTooltip => 'Kaydet';

	/// tr: 'Tarif alınamadı.'
	String get fetchFailed => 'Tarif alınamadı.';
}

// Path: saved
class Translations$saved$tr {
	Translations$saved$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Kaydedilenler'
	String get title => 'Kaydedilenler';

	/// tr: 'Tariflerde ara...'
	String get searchHint => 'Tariflerde ara...';

	/// tr: 'Aramanızla eşleşen tarif bulunamadı.'
	String get noResults => 'Aramanızla eşleşen tarif bulunamadı.';

	/// tr: 'Henüz kaydedilmiş tarif yok'
	String get empty => 'Henüz kaydedilmiş tarif yok';

	/// tr: 'Keşfet sekmesinden tarif arayıp kaydedebilirsiniz'
	String get emptyHint => 'Keşfet sekmesinden tarif arayıp kaydedebilirsiniz';

	/// tr: 'Tümünü Sil'
	String get deleteAll => 'Tümünü Sil';

	/// tr: 'Tüm Tarifleri Sil'
	String get deleteAllTitle => 'Tüm Tarifleri Sil';

	/// tr: 'Tüm kaydedilmiş tarifleri silmek istediğinize emin misiniz?'
	String get deleteAllContent => 'Tüm kaydedilmiş tarifleri silmek istediğinize emin misiniz?';

	/// tr: 'Rastgele Tarif Öner'
	String get randomRecipeTooltip => 'Rastgele Tarif Öner';

	/// tr: 'Kategoriler'
	String get categoriesTooltip => 'Kategoriler';

	/// tr: 'Yeni Tarif'
	String get newRecipeTooltip => 'Yeni Tarif';

	/// tr: 'Henüz hiç tarif yok.'
	String get noRecipe => 'Henüz hiç tarif yok.';

	/// tr: 'Tarifi Sil'
	String get deleteTitle => 'Tarifi Sil';

	/// tr: '$name tarifini silmek istediğinize emin misiniz?'
	String deleteContent({required Object name}) => '${name} tarifini silmek istediğinize emin misiniz?';
}

// Path: common
class Translations$common$tr {
	Translations$common$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Sil'
	String get delete => 'Sil';
}

// Path: recipeForm
class Translations$recipeForm$tr {
	Translations$recipeForm$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Tarifi Düzenle'
	String get editTitle => 'Tarifi Düzenle';

	/// tr: 'Yeni Tarif Ekle'
	String get newTitle => 'Yeni Tarif Ekle';

	/// tr: 'Yemek Adı'
	String get nameLabel => 'Yemek Adı';

	/// tr: 'Kategori'
	String get categoryLabel => 'Kategori';

	/// tr: 'Örn: Çorba, Ana Yemek, Tatlı'
	String get categoryHint => 'Örn: Çorba, Ana Yemek, Tatlı';

	/// tr: 'Görsel URL (opsiyonel)'
	String get imageUrlLabel => 'Görsel URL (opsiyonel)';

	/// tr: 'https://...'
	String get imageUrlHint => 'https://...';

	/// tr: 'Malzemeler'
	String get ingredientsLabel => 'Malzemeler';

	/// tr: 'Hazırlanışı'
	String get instructionsLabel => 'Hazırlanışı';

	/// tr: 'Güncelle'
	String get updateButton => 'Güncelle';

	/// tr: 'Kaydet'
	String get saveButton => 'Kaydet';

	/// tr: 'Yemek adı gerekli'
	String get nameRequired => 'Yemek adı gerekli';

	/// tr: 'Kategori gerekli'
	String get categoryRequired => 'Kategori gerekli';

	/// tr: 'Malzemeler gerekli'
	String get ingredientsRequired => 'Malzemeler gerekli';

	/// tr: 'Hazırlanış gerekli'
	String get instructionsRequired => 'Hazırlanış gerekli';
}

// Path: categories
class Translations$categories$tr {
	Translations$categories$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Kategoriler'
	String get title => 'Kategoriler';

	/// tr: 'Henüz kategori yok'
	String get empty => 'Henüz kategori yok';

	/// tr: 'Yeni tarif ekleyerek kategoriler oluşturabilirsiniz'
	String get emptyHint => 'Yeni tarif ekleyerek kategoriler oluşturabilirsiniz';

	/// tr: '(one) {$count tarif} (other) {$count tarif}'
	String recipeCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(n,
		one: '${count} tarif',
		other: '${count} tarif',
	);
}

// Path: categoryRecipes
class Translations$categoryRecipes$tr {
	Translations$categoryRecipes$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Bu kategoride tarif yok'
	String get empty => 'Bu kategoride tarif yok';

	/// tr: 'Tarif Ekle'
	String get addRecipe => 'Tarif Ekle';

	/// tr: 'Yeni Tarif'
	String get newRecipeTooltip => 'Yeni Tarif';

	/// tr: 'Tarifi Sil'
	String get deleteTitle => 'Tarifi Sil';

	/// tr: '$name tarifini silmek istediğinize emin misiniz?'
	String deleteContent({required Object name}) => '${name} tarifini silmek istediğinize emin misiniz?';
}

// Path: recipeDetail
class Translations$recipeDetail$tr {
	Translations$recipeDetail$tr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Malzemeler'
	String get ingredients => 'Malzemeler';

	/// tr: 'Hazırlanışı'
	String get instructions => 'Hazırlanışı';

	/// tr: 'Tarif bulunamadı'
	String get notFound => 'Tarif bulunamadı';

	/// tr: 'Paylaş'
	String get share => 'Paylaş';

	/// tr: '$name tarifi'
	String shareSubject({required Object name}) => '${name} tarifi';

	/// tr: 'Bağlantı panoya kopyalandı'
	String get copiedToClipboard => 'Bağlantı panoya kopyalandı';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Yemek Tarifleri',
			'nav.discover' => 'Keşfet',
			'nav.saved' => 'Kaydedilenler',
			'discover.title' => 'Keşfet',
			'discover.searchHint' => 'API\'de tarif ara...',
			'discover.searchButton' => 'Ara',
			'discover.noResults' => ({required Object query}) => '${query} için sonuç bulunamadı.',
			'discover.searchPrompt' => 'Yemek tarifi aramak için yukarıdaki alanı kullanın',
			'discover.saved' => ({required Object name}) => '${name} kaydedildi!',
			'discover.alreadySaved' => 'Bu tarif zaten kaydedilmiş',
			'discover.saveTooltip' => 'Kaydet',
			'discover.fetchFailed' => 'Tarif alınamadı.',
			'saved.title' => 'Kaydedilenler',
			'saved.searchHint' => 'Tariflerde ara...',
			'saved.noResults' => 'Aramanızla eşleşen tarif bulunamadı.',
			'saved.empty' => 'Henüz kaydedilmiş tarif yok',
			'saved.emptyHint' => 'Keşfet sekmesinden tarif arayıp kaydedebilirsiniz',
			'saved.deleteAll' => 'Tümünü Sil',
			'saved.deleteAllTitle' => 'Tüm Tarifleri Sil',
			'saved.deleteAllContent' => 'Tüm kaydedilmiş tarifleri silmek istediğinize emin misiniz?',
			'saved.randomRecipeTooltip' => 'Rastgele Tarif Öner',
			'saved.categoriesTooltip' => 'Kategoriler',
			'saved.newRecipeTooltip' => 'Yeni Tarif',
			'saved.noRecipe' => 'Henüz hiç tarif yok.',
			'saved.deleteTitle' => 'Tarifi Sil',
			'saved.deleteContent' => ({required Object name}) => '${name} tarifini silmek istediğinize emin misiniz?',
			'common.cancel' => 'İptal',
			'common.delete' => 'Sil',
			'recipeForm.editTitle' => 'Tarifi Düzenle',
			'recipeForm.newTitle' => 'Yeni Tarif Ekle',
			'recipeForm.nameLabel' => 'Yemek Adı',
			'recipeForm.categoryLabel' => 'Kategori',
			'recipeForm.categoryHint' => 'Örn: Çorba, Ana Yemek, Tatlı',
			'recipeForm.imageUrlLabel' => 'Görsel URL (opsiyonel)',
			'recipeForm.imageUrlHint' => 'https://...',
			'recipeForm.ingredientsLabel' => 'Malzemeler',
			'recipeForm.instructionsLabel' => 'Hazırlanışı',
			'recipeForm.updateButton' => 'Güncelle',
			'recipeForm.saveButton' => 'Kaydet',
			'recipeForm.nameRequired' => 'Yemek adı gerekli',
			'recipeForm.categoryRequired' => 'Kategori gerekli',
			'recipeForm.ingredientsRequired' => 'Malzemeler gerekli',
			'recipeForm.instructionsRequired' => 'Hazırlanış gerekli',
			'categories.title' => 'Kategoriler',
			'categories.empty' => 'Henüz kategori yok',
			'categories.emptyHint' => 'Yeni tarif ekleyerek kategoriler oluşturabilirsiniz',
			'categories.recipeCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(n, one: '${count} tarif', other: '${count} tarif', ), 
			'categoryRecipes.empty' => 'Bu kategoride tarif yok',
			'categoryRecipes.addRecipe' => 'Tarif Ekle',
			'categoryRecipes.newRecipeTooltip' => 'Yeni Tarif',
			'categoryRecipes.deleteTitle' => 'Tarifi Sil',
			'categoryRecipes.deleteContent' => ({required Object name}) => '${name} tarifini silmek istediğinize emin misiniz?',
			'recipeDetail.ingredients' => 'Malzemeler',
			'recipeDetail.instructions' => 'Hazırlanışı',
			'recipeDetail.notFound' => 'Tarif bulunamadı',
			'recipeDetail.share' => 'Paylaş',
			'recipeDetail.shareSubject' => ({required Object name}) => '${name} tarifi',
			'recipeDetail.copiedToClipboard' => 'Bağlantı panoya kopyalandı',
			_ => null,
		};
	}
}
