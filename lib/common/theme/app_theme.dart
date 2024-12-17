import 'package:flutter/material.dart';

class AppTheme {
  static TextTheme applyFontSizeFactor(TextTheme textTheme, double factor) {
    return textTheme.copyWith(
      bodyLarge: textTheme.bodyLarge?.copyWith(
        fontSize: (textTheme.bodyLarge?.fontSize ?? 16.0) * factor,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        fontSize: (textTheme.bodyMedium?.fontSize ?? 14.0) * factor,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        fontSize: (textTheme.bodySmall?.fontSize ?? 12.0) * factor,
      ),
      // Добавьте другие стили текста по необходимости
    );
  }

  static ColorScheme createColorScheme(
    Color primaryColor,
    Brightness brightness,
  ) {
    return ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    );
  }

  static ThemeData createTheme({
    required Brightness brightness,
    required Color primaryColor,
    required double fontSizeFactor,
  }) {
    final baseTheme =
        brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();

    final adjustedTextTheme = applyFontSizeFactor(
      baseTheme.textTheme,
      fontSizeFactor,
    );

    // Коэффициенты для AppBar и BottomBar
    const appBarFontSizeMultiplier = 1.2;
    const bottomBarFontSizeMultiplier = 1.1;

    return ThemeData(
      useMaterial3: true,
      colorScheme: createColorScheme(primaryColor, brightness),
      textTheme: adjustedTextTheme,
      appBarTheme: AppBarTheme(
        titleTextStyle: adjustedTextTheme.titleLarge?.copyWith(
          color: brightness == Brightness.light ? Colors.black : Colors.white,
          fontSize: (adjustedTextTheme.titleLarge?.fontSize ?? 18.0) *
              appBarFontSizeMultiplier,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: adjustedTextTheme.bodySmall?.copyWith(
          fontSize: (adjustedTextTheme.bodySmall?.fontSize ?? 12.0) *
              bottomBarFontSizeMultiplier,
        ),
        unselectedLabelStyle: adjustedTextTheme.bodySmall?.copyWith(
          fontSize: (adjustedTextTheme.bodySmall?.fontSize ?? 12.0) *
              bottomBarFontSizeMultiplier,
        ),
      ),
    );
  }
}
