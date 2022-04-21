import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppBoxDecorations {
  static final cardBoxDecoration = BoxDecoration(
    border: Border.all(
      color: AppColors.greyBorder,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(12),
    color: AppColors.white,
    // boxShadow: [
    //   BoxShadow(
    //     color: AppColors.black.withOpacity(0.1),
    //     offset: Offset(0, 4),
    //     blurRadius: 4,
    //   ),
    // ],
  );
}
