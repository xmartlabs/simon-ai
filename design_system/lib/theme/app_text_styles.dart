//ignore_for_file: unused-files, unused-code

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const FontWeight _semiboldWeight = FontWeight.w600;

class AppTextStyles extends TextTheme {
  const AppTextStyles({
    super.headlineLarge,
    super.headlineMedium,
    super.headlineSmall,
    super.bodyLarge,
    super.bodyMedium,
    super.bodySmall,
    super.titleLarge,
    super.titleMedium,
    super.titleSmall,
    super.labelLarge,
    super.labelMedium,
    super.labelSmall,
  });

  factory AppTextStyles.fromTextTheme({
    required TextTheme textTheme,
  }) =>
      AppTextStyles(
        headlineSmall: textTheme.headlineSmall,
        headlineMedium: textTheme.headlineMedium,
        headlineLarge: textTheme.headlineLarge,
        bodyLarge: textTheme.bodyLarge,
        bodyMedium: textTheme.bodyMedium,
        bodySmall: textTheme.bodySmall,
        titleLarge: textTheme.titleLarge,
        titleMedium: textTheme.titleMedium,
        titleSmall: textTheme.titleSmall,
        labelLarge: textTheme.labelLarge,
        labelMedium: textTheme.labelMedium,
        labelSmall: textTheme.labelSmall,
      );

  static TextStyle _sourceSansTextStyle(
    double fontSize,
    FontWeight fontWeight,
  ) =>
      GoogleFonts.sourceSans3(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );

  static AppTextStyles getDefaultAppStyles() => AppTextStyles.fromTextTheme(
        textTheme: GoogleFonts.sourceSans3TextTheme().copyWith(
          labelLarge: _sourceSansTextStyle(20, FontWeight.normal),
          labelMedium: _sourceSansTextStyle(16, FontWeight.normal),
          labelSmall: _sourceSansTextStyle(14, FontWeight.normal),
          headlineMedium: _sourceSansTextStyle(20, FontWeight.bold),
          headlineLarge: _sourceSansTextStyle(24, FontWeight.bold),
        ),
      );

  TextTheme getThemeData() => getDefaultAppStyles();
}

extension TextStyleExtensions on TextStyle {
  TextStyle links() => copyWith(
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.underline,
        decorationColor: color,
      );

  TextStyle semibold() => copyWith(fontWeight: _semiboldWeight);

  TextStyle bold() => copyWith(fontWeight: FontWeight.bold);

  TextStyle regular() => copyWith(fontWeight: FontWeight.normal);
}
