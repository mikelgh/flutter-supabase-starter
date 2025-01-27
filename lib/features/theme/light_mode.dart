import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade500,
    tertiary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade100,
    onSurface: Colors.black87,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red.shade700,
    onError: Colors.white,
  ),
);
