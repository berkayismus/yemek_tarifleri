import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n/strings.g.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/recipe_remote_datasource.dart';
import 'data/repositories/recipe_repository_impl.dart';
import 'presentation/cubit/recipe_cubit.dart';
import 'presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeCubit(
        RecipeRepositoryImpl(RecipeRemoteDataSource()),
      ),
      child: MaterialApp(
        title: t.appTitle,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
        ],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomePage(),
      ),
    );
  }
}
