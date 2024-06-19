// ignore_for_file: overridden_fields

import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const FontWeight _semiboldWeight = FontWeight.w600;

@immutable
class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  const CustomTextStyles({
    required this.tinyText,
    required this.customOverline,
    required this.buttonXLarge,
    required this.buttonLarge,
    required this.buttonMedium,
    required this.buttonSmall,
    required this.buttonXSmall,
    required this.buttonTiny,
    required this.labelXSmall,
    required this.bodyXSmall,
    required this.customColors,
  }) : super();

  final TextStyle tinyText;
  final TextStyle customOverline;
  final TextStyle buttonXLarge;
  final TextStyle buttonLarge;
  final TextStyle buttonMedium;
  final TextStyle buttonSmall;
  final TextStyle buttonXSmall;
  final TextStyle buttonTiny;
  final TextStyle bodyXSmall;
  final TextStyle labelXSmall;
  final CustomColors customColors;

  static CustomTextStyles getCustomTextStyles(CustomColors customColors) =>
      CustomTextStyles(
        tinyText: _robotoTextStyle(10, FontWeight.normal, customColors),
        customOverline: _robotoTextStyle(10, FontWeight.normal, customColors),
        buttonXLarge: _robotoTextStyle(24, _semiboldWeight, customColors),
        buttonLarge: _robotoTextStyle(20, _semiboldWeight, customColors),
        buttonMedium: _robotoTextStyle(16, _semiboldWeight, customColors),
        buttonSmall: _robotoTextStyle(14, _semiboldWeight, customColors),
        buttonXSmall: _robotoTextStyle(10, _semiboldWeight, customColors),
        bodyXSmall: _robotoTextStyle(12, _semiboldWeight, customColors),
        labelXSmall: _robotoTextStyle(12, _semiboldWeight, customColors),
        buttonTiny: _robotoTextStyle(10, _semiboldWeight, customColors),
        customColors: customColors,
      );

  static TextStyle _robotoTextStyle(
    double fontSize,
    FontWeight fontWeight,
    CustomColors customColors,
  ) =>
      GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: customColors.textColor!.getShade(500),
      );

  @override
  CustomTextStyles copyWith({MaterialColor? primary}) =>
      CustomTextStyles.getCustomTextStyles(customColors);

  @override
  CustomTextStyles lerp(CustomTextStyles? other, double t) {
    if (other is! CustomTextStyles) {
      return this;
    }
    return CustomTextStyles(
      tinyText: TextStyle.lerp(tinyText, other.tinyText, t)!,
      customOverline: TextStyle.lerp(customOverline, other.customOverline, t)!,
      buttonXLarge: TextStyle.lerp(buttonXLarge, other.buttonXLarge, t)!,
      buttonLarge: TextStyle.lerp(buttonLarge, other.buttonLarge, t)!,
      buttonMedium: TextStyle.lerp(buttonMedium, other.buttonMedium, t)!,
      buttonSmall: TextStyle.lerp(buttonSmall, other.buttonSmall, t)!,
      buttonXSmall: TextStyle.lerp(buttonXSmall, other.buttonXSmall, t)!,
      buttonTiny: TextStyle.lerp(buttonTiny, other.buttonTiny, t)!,
      bodyXSmall: TextStyle.lerp(bodyXSmall, other.bodyXSmall, t)!,
      labelXSmall: TextStyle.lerp(labelXSmall, other.labelXSmall, t)!,
      customColors: customColors,
    );
  }

  @override
  Object get type => CustomTextStyles;
}
