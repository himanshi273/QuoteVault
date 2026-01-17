import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ThemeState holds current mode + font size + accent color
class ThemeState {
  final ThemeMode mode;
  final double fontSize;
  final Color accentColor;

  const ThemeState({
    required this.mode,
    required this.fontSize,
    required this.accentColor,
  });

  ThemeState copyWith({
    ThemeMode? mode,
    double? fontSize,
    Color? accentColor,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      fontSize: fontSize ?? this.fontSize,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
      : super(
     ThemeState(
      mode: ThemeMode.light,
      fontSize: 16,
      accentColor: Colors.blue, // ✅ default
    ),
  ) {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDark') ?? false;
    final fontSize = prefs.getDouble('fontSize') ?? 16;
    final accentValue =
        prefs.getInt('accentColor') ?? Colors.blue.value;

    state = state.copyWith(
      mode: isDark ? ThemeMode.dark : ThemeMode.light,
      fontSize: fontSize,
      accentColor: Color(accentValue),
    );
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state.mode != ThemeMode.dark;

    await prefs.setBool('isDark', isDark);
    state = state.copyWith(
      mode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    state = state.copyWith(fontSize: size);
  }

  Future<void> setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', color.value);
    state = state.copyWith(accentColor: color);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());

