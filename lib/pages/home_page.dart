import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import 'discover_page.dart';
import 'saved_recipes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DiscoverPage(),
          SavedRecipesPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.explore),
            label: t.nav.discover,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark),
            label: t.nav.saved,
          ),
        ],
      ),
    );
  }
}
