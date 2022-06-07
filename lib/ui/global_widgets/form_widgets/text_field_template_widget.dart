import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

//TODO Доделать оформление тексотового поля, как минимум рамку, когда поле активно (в нем печатают)
class TextFieldTemplateWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final void Function()? onTap;
  final int maxLines;
  final TextInputType keyboardType;
  const TextFieldTemplateWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.onTap,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      controller: controller,
      style: AppTextStyles.regular16.copyWith(color: AppColors.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.greyBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        isDense: true,
        labelText: labelText,
        hintText: hintText,
        hintStyle: AppTextStyles.regular16.copyWith(color: AppColors.greyText),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
