// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

// Colors name extracted from https://www.color-name.com
@immutable
class AppColorScheme extends ColorScheme {
  @override
  final Color onPrimary;
  @override
  final MaterialColor primary;
  @override
  final MaterialColor secondary;
  @override
  final MaterialColor surface;
  @override
  final MaterialColor onSurface;

  AppColorScheme({
    required ColorScheme colorScheme,
    required this.onPrimary,
    required this.onSurface,
    required this.secondary,
    required this.primary,
    required this.surface,
  }) : super(
          brightness: colorScheme.brightness,
          primary: colorScheme.primary,
          onPrimary: colorScheme.onPrimary,
          primaryContainer: colorScheme.primaryContainer,
          onPrimaryContainer: colorScheme.onPrimaryContainer,
          secondary: colorScheme.secondary,
          onSecondary: colorScheme.onSecondary,
          secondaryContainer: colorScheme.secondaryContainer,
          onSecondaryContainer: colorScheme.onSecondaryContainer,
          tertiary: colorScheme.tertiary,
          onTertiary: colorScheme.onTertiary,
          tertiaryContainer: colorScheme.tertiaryContainer,
          onTertiaryContainer: colorScheme.onTertiaryContainer,
          error: colorScheme.error,
          onError: colorScheme.onError,
          errorContainer: colorScheme.errorContainer,
          onErrorContainer: colorScheme.onErrorContainer,
          surface: colorScheme.surface,
          onSurface: colorScheme.onSurface,
          surfaceContainerHighest: colorScheme.surfaceContainerHighest,
          onSurfaceVariant: colorScheme.onSurfaceVariant,
          outline: colorScheme.outline,
          outlineVariant: colorScheme.outlineVariant,
          shadow: colorScheme.shadow,
          scrim: colorScheme.scrim,
          inverseSurface: colorScheme.inverseSurface,
          onInverseSurface: colorScheme.onInverseSurface,
          inversePrimary: colorScheme.inversePrimary,
          surfaceTint: colorScheme.surfaceTint,
        );

  static AppColorScheme getDefaultColorScheme() => AppColorScheme(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const MaterialColor(
            0xffFA4C56,
            <int, Color>{
              100: Color(0xffFCA5AA),
              200: Color(0xffFC949A),
              300: Color(0xffFC8289),
              400: Color(0xffFB7078),
              500: Color(0xffFB5E67),
              600: Color(0xffFA4C56),
              700: Color(0xffF91B28),
              800: Color(0xffDA0612),
              900: Color(0xffA9050E),
              1000: Color(0xff77030A),
            },
          ),
          primaryContainer: const Color(0xffFA4C56),
          onSecondary: Colors.black,
          error: const MaterialColor(
            0xfff4642c,
            <int, Color>{
              100: Color(0xfffeebd4),
              200: Color(0xfffbb37f),
              300: Color(0xfff4642c),
              400: Color(0xffd74824),
              500: Color(0xff750908),
            },
          ),
          onError: Colors.black,
          onSurface: const Color(0xffadadad),
          surface: const Color(0xffF9F9FC),
          surfaceBright: Colors.white,
        ),
        primary: const MaterialColor(
          0xffFA4C56,
          <int, Color>{
            100: Color(0xffFCA5AA),
            200: Color(0xffFC949A),
            300: Color(0xffFC8289),
            400: Color(0xffFB7078),
            500: Color(0xffFB5E67),
            600: Color(0xffFA4C56),
            700: Color(0xffF91B28),
            800: Color(0xffDA0612),
            900: Color(0xffA9050E),
            1000: Color(0xff77030A),
          },
        ),
        onPrimary: const MaterialColor(
          0xff414158,
          <int, Color>{
            100: Color(0xffffffff),
            200: Color(0xffc2c2cc),
            300: Color(0xff8a8aa8),
            400: Color(0xff414158),
            500: Color(0xff1d1616),
          },
        ),
        secondary: const MaterialColor(
          0xff00B294,
          <int, Color>{
            100: Color(0xffCCF0EA),
            200: Color(0xff99E0D4),
            300: Color(0xff66D1BF),
            400: Color(0xff33C1A9),
            500: Color(0xff00B294),
            600: Color(0xff00997F),
            700: Color(0xff00806A),
            800: Color(0xff006655),
            900: Color(0xff004D40),
            1000: Color(0xff00332A),
          },
        ),
        surface: const MaterialColor(
          0xfff7fafd,
          <int, Color>{
            100: Color(0xffffffff),
            200: Color(0xffadadad),
            300: Color(0xff707070),
            400: Color(0xff1e1e1e),
            500: Color(0xff0f0f0f),
          },
        ),
        onSurface: const MaterialColor(
          0xff5b5b5b,
          <int, Color>{
            100: Color(0xffffffff),
            200: Color(0xffadadad),
            300: Color(0xff5b5b5b),
            400: Color(0xff1e1e1e),
            500: Color(0xff0f0f0f),
          },
        ),
      );
}

extension MaterialExtensions on MaterialColor {
  Color get shade1000 => this[1000]!;
}
