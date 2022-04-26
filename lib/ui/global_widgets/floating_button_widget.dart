import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class FloatingButtonWidget extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const FloatingButtonWidget({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: child,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        primary: AppColors.white,
        backgroundColor: AppColors.blue,
        fixedSize: const Size(296, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.button,
      ),
    );
  }
}
