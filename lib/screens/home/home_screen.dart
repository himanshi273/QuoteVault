import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../collections/collections_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/setting_screens.dart';
import 'home_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  final _tabs = const [
    HomeTab(),
    FavoritesScreen(),
    CollectionsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      appBar: _index==0?AppBar(
        title: const Text('QuoteVault'),
        actions: [
          IconButton(
            icon: Icon(theme.mode == ThemeMode.dark?Icons.light_mode_outlined:Icons.dark_mode_outlined),
            onPressed: () {
              // toggle theme provider
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // optional: open profile / drawer
            },
          ),
        ],
      ):AppBar(),
      body: _tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
