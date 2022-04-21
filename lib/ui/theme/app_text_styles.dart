import 'package:autospectechnics/ui/theme/app_font_families.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static const semiBold = TextStyle(
    fontFamily: AppFontFamilies.openSans,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 24 / 20,
  );

  static const regular16 = TextStyle(
    fontFamily: AppFontFamilies.openSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 20 / 16,
  );

  static const regular20 = TextStyle(
    fontFamily: AppFontFamilies.openSans,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 24 / 20,
  );

  static const hint = TextStyle(
    fontFamily: AppFontFamilies.openSans,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 16 / 12,
  );

  static const button = TextStyle(
    fontFamily: AppFontFamilies.openSans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 20 / 16,
  );

  static const smallLabels = TextStyle(
    fontFamily: AppFontFamilies.openSans,
    fontSize: 9,
    fontWeight: FontWeight.w400,
    height: 12 / 9,
  );
}