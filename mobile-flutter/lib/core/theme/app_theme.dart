import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE4947C)),
      scaffoldBackgroundColor: const Color(0xFFFFF6EF),
    );
  }
}
