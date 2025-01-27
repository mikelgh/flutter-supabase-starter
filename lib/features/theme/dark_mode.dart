import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade500,
    tertiary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
    onSurface: Colors.white70,
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    error: Colors.red.shade400,
    onError: Colors.white,
  ),
);
