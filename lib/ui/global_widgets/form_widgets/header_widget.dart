import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String text;
  const HeaderWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
