import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_provider.dart';
import '../auth/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Appearance',
            children: [
              _ThemeToggleTile(theme: theme, ref: ref),
              const SizedBox(height: 16),
              _FontSizeTile(theme: theme, ref: ref),
              const SizedBox(height: 16),
              _AccentColorPicker(theme: theme, ref: ref),
            ],
          ),

          const SizedBox(height: 24),

          _SectionCard(
            title: 'About',
            children: const [
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('App Version'),
                trailing: Text('1.0.0'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _SectionCard(
            title: '',
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ],
          ),

        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

}

//Section Wrapper
class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title.isNotEmpty?Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ):SizedBox(),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

//Dark/Light Theme Toggle
class _ThemeToggleTile extends StatelessWidget {
  final ThemeState theme;
  final WidgetRef ref;

  const _ThemeToggleTile({
    required this.theme,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      subtitle: const Text('Toggle light and dark theme'),
      value: theme.mode == ThemeMode.dark,
      onChanged: (_) {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}

//FontSize slider
class _FontSizeTile extends StatelessWidget {
  final ThemeState theme;
  final WidgetRef ref;

  const _FontSizeTile({
    required this.theme,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Font Size',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Slider(
          min: 12,
          max: 24,
          divisions: 6,
          value: theme.fontSize,
          label: theme.fontSize.toStringAsFixed(0),
          onChanged: (value) {
            ref.read(themeProvider.notifier).setFontSize(value);
          },
        ),
      ],
    );
  }
}

//Accent Color picker
class _AccentColorPicker extends StatelessWidget {
  final ThemeState theme;
  final WidgetRef ref;

  const _AccentColorPicker({
    required this.theme,
    required this.ref,
  });

  static const List<Color> colors = [
    Color(0xFF5B5FFF), // Figma primary
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accent Color',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: colors.map((color) {
            final isSelected = theme.accentColor.value == color.value;

            return GestureDetector(
              onTap: () {
                ref
                    .read(themeProvider.notifier)
                    .setAccentColor(color);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 3,
                  )
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

//