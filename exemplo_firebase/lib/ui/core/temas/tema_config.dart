import 'package:flutter/material.dart';

class AppTemaConfig {
  final Color corPrimaria;
  final String? fontFamily;

  const AppTemaConfig({required this.corPrimaria, this.fontFamily});

  factory AppTemaConfig.dev() {
    return const AppTemaConfig(
      corPrimaria: Colors.deepOrange,
      fontFamily: null,
    );
  }
  factory AppTemaConfig.prod() {
    return const AppTemaConfig(
      corPrimaria: Colors.deepPurple,
      fontFamily: null,
    );
  }

  //tema claro
  ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: corPrimaria,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
      ),
    );
  }

  //tema escuro
  ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: corPrimaria,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 2,
      ),
    );
  }
}
