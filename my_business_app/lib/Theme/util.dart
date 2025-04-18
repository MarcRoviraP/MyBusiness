import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(BuildContext context, String bodyFontString,
    String displayFontString, bool isDarkMode) {
  final baseTextTheme = Theme.of(context).textTheme;

  final Color textColor = isDarkMode ? Colors.white : Colors.black;

  return TextTheme(
    displayLarge: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.displayLarge?.copyWith(color: textColor)),
    displayMedium: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.displayMedium?.copyWith(color: textColor)),
    displaySmall: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.displaySmall?.copyWith(color: textColor)),
    headlineLarge: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.headlineLarge?.copyWith(color: textColor)),
    headlineMedium: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.headlineMedium?.copyWith(color: textColor)),
    headlineSmall: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.headlineSmall?.copyWith(color: textColor)),
    titleLarge: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.titleLarge?.copyWith(color: textColor)),
    titleMedium: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.titleMedium?.copyWith(color: textColor)),
    titleSmall: GoogleFonts.getFont(displayFontString,
        textStyle: baseTextTheme.titleSmall?.copyWith(color: textColor)),
    bodyLarge: GoogleFonts.getFont(bodyFontString,
        textStyle: baseTextTheme.bodyLarge?.copyWith(color: textColor)),
    bodyMedium: GoogleFonts.getFont(bodyFontString,
        textStyle: baseTextTheme.bodyMedium?.copyWith(color: textColor)),
    bodySmall: GoogleFonts.getFont(bodyFontString,
        textStyle: baseTextTheme.bodySmall?.copyWith(color: textColor)),
    labelLarge: GoogleFonts.getFont(bodyFontString,
        textStyle: baseTextTheme.labelLarge?.copyWith(color: textColor)),
    labelMedium: GoogleFonts.getFont(bodyFontString,
        textStyle: baseTextTheme.labelMedium?.copyWith(color: textColor)),
    labelSmall: GoogleFonts.getFont(bodyFontString,
        textStyle: baseTextTheme.labelSmall?.copyWith(color: textColor)),
  );
}
