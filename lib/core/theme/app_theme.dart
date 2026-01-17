import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    fontFamily: 'Inter',
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    fontFamily: 'Inter',
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
    ),
  );
}
