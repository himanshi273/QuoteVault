import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static const primary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.primaryStart,
      AppColors.primaryEnd,
    ],
  );
}
