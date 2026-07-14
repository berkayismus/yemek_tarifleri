import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../i18n/strings.g.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
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
