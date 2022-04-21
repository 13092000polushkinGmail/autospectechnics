import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RemainingResourceProgressBarWidget extends StatelessWidget {
  final Color color;
  final double value;
  const RemainingResourceProgressBarWidget({
    Key? key,
    required this.color,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: LinearProgressIndicator(
        value: value,
        color: color,
        backgroundColor: AppColors.progressBarBackground,
      ),
    );
  }
}
