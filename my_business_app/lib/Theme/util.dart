import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme({
  required BuildContext context,
  required String bodyFontString,
  required String displayFontString,
  required bool isDarkMode,
}) {
  final baseTextTheme = Theme.of(context).textTheme;
  final Color textColor = isDarkMode ? Colors.white : Colors.black;

  TextStyle? applyFont(TextStyle? base, String font) {
    return GoogleFonts.getFont(
      font,
      textStyle: base?.copyWith(
        color: textColor,
        inherit: true,
      ),
    );
  }

  return TextTheme(
    displayLarge: applyFont(baseTextTheme.displayLarge, displayFontString),
    displayMedium: applyFont(baseTextTheme.displayMedium, displayFontString),
    displaySmall: applyFont(baseTextTheme.displaySmall, displayFontString),
    headlineLarge: applyFont(baseTextTheme.headlineLarge, displayFontString),
    headlineMedium: applyFont(baseTextTheme.headlineMedium, displayFontString),
    headlineSmall: applyFont(baseTextTheme.headlineSmall, displayFontString),
    titleLarge: applyFont(baseTextTheme.titleLarge, displayFontString),
    titleMedium: applyFont(baseTextTheme.titleMedium, displayFontString),
    titleSmall: applyFont(baseTextTheme.titleSmall, displayFontString),
    bodyLarge: applyFont(baseTextTheme.bodyLarge, bodyFontString),
    bodyMedium: applyFont(baseTextTheme.bodyMedium, bodyFontString),
    bodySmall: applyFont(baseTextTheme.bodySmall, bodyFontString),
    labelLarge: applyFont(baseTextTheme.labelLarge, bodyFontString),
    labelMedium: applyFont(baseTextTheme.labelMedium, bodyFontString),
    labelSmall: applyFont(baseTextTheme.labelSmall, bodyFontString),
  );
}
