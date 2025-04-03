import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    surface: Colors.grey.shade800,
    primary: Colors.deepPurple.shade300,
    primaryContainer: Colors.deepPurple.shade800,
    secondary: Colors.blue.shade300,
    secondaryContainer: Colors.blue.shade800,
    tertiary: Colors.deepPurple.shade200,
    tertiaryContainer: Colors.deepPurple.shade900,
    inversePrimary: Colors.grey.shade800,
    onSurface: Colors.white70,
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    error: Colors.red.shade400,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple.shade300,
      foregroundColor: Colors.black87,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade800,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade800,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white70),
  ),
);
