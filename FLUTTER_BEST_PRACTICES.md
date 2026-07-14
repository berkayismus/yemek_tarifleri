# Flutter Clean Architecture & Best Practices

## Klasör Yapısı (Clean Architecture)

```
lib/
├── main.dart                  # Uygulama giriş noktası (DI, storage init)
├── app.dart                   # MaterialApp + Provider kurulumu
├── core/                      # Uygulama geneli yardımcılar
│   └── theme/
│       └── app_theme.dart     # Tema sabitleri
├── data/                      # Veri katmanı
│   ├── datasources/           # API, DB, cache kaynakları
│   ├── models/                # DTO'lar (toJson/fromJson)
│   └── repositories/          # Repository implementasyonları
├── domain/                    # İş mantığı katmanı
│   ├── entities/              # Saf entity sınıfları
│   └── repositories/          # Soyut repository arayüzleri
├── presentation/              # UI katmanı
│   ├── cubit/                 # State management
│   └── pages/                 # Sayfalar
└── i18n/                      # Çeviri dosyaları (slang)
```

## Katmanlar Arası Bağımlılık Kuralları

```
presentation ──→ domain ←── data
    │                          │
    └──────────────────────────┘
         (DI için app katmanı)
```

- **domain**: Hiçbir katmana bağımlı değil (pure Dart)
- **data**: Sadece domain'e bağımlı
- **presentation**: Domain'e bağımlı, DI için data'ya da erişebilir
- **app** (main.dart): Tüm katmanları birleştirir

## Entity vs Model

### Entity (`domain/entities/`)
- Saf iş nesnesi, immutable (`final` alanlar)
- `copyWith` metodu ile güncelleme
- Serializasyon bilgisi içermez

### Model (`data/models/`)
- Entity'den türetilir
- `fromJson` / `toJson` içerir
- `fromEntity` factory ile dönüşüm

```dart
// Entity
class Recipe {
  final String id;
  final String name;
  const Recipe({required this.id, required this.name});
  Recipe copyWith({String? name}) => Recipe(id: id, name: name ?? this.name);
}

// Model
class RecipeModel extends Recipe {
  const RecipeModel({required super.id, required super.name});
  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(...);
  Map<String, dynamic> toJson() => {...};
}
```

## State Management (Cubit + HydratedBloc)

- Cubit sadece presentation katmanında bulunur
- `HydratedCubit` ile otomatik persist
- Repository'leri constructor injection ile alır

```dart
class RecipeCubit extends HydratedCubit<List<Recipe>> {
  final RecipeRepository _repository;
  RecipeCubit(this._repository) : super([]);

  void addRecipe(Recipe recipe) => emit([...state, recipe]);
}
```

## Dependency Injection

`main.dart` veya `app.dart` içinde manuel DI:

```dart
BlocProvider(
  create: (_) => RecipeCubit(
    RecipeRepositoryImpl(RecipeRemoteDataSource()),
  ),
  child: MaterialApp(...),
)
```

## Immutability

- Entity alanları `final`, güncelleme `copyWith` ile
- Cubit state'i her seferinde yeni liste oluşturarak emit edilir

```dart
// Doğru
emit([...state, newRecipe]);

// Yanlış
state.add(newRecipe);
emit(state);
```

## Çeviri (slang)

- `lib/i18n/*.i18n.json` dosyalarında tanımlanır
- `dart run build_runner build` ile type-safe kod üretilir
- `t.xxx` getter'ı ile erişilir
- Parametreli: `t.recipeList.added(name: recipe.name)`
- Çoğul: `t.categories.recipeCount(n: count, count: count)`

## Dosya Adlandırma

- Dosyalar: `snake_case.dart`
- Sınıflar: `PascalCase`
- Değişkenler/metotlar: `camelCase`
- Sayfalar: `*_page.dart`
- Cubit: `*_cubit.dart`

## Sayfa Yapısı

```dart
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      builder: (context, state) {
        return Scaffold(...);
      },
    );
  }
}
```

## Hata Yönetimi

- API çağrıları try-catch ile sarılır
- Kullanıcıya SnackBar ile bilgi verilir
- Cubit metodları senkron (state emit), repository metodları asenkron

## Performans

- `const` constructor'lar her yerde kullanılır
- `IndexedStack` ile sayfalar arası geçişte state korunur
- Liste operasyonlarında yeni liste oluşturulur (immutable)

## Test

- Widget test: `testWidgets` ile UI testi
- `HydratedBloc.storage` test öncesi initialize edilmeli
