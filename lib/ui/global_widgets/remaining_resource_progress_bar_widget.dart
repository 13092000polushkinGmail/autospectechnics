import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RemainingResourceProgressBarWidget extends StatelessWidget {
  final double value;
  const RemainingResourceProgressBarWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (value < 0.25) {
      color = AppColors.red;
    } else if (value < 0.75) {
      color = AppColors.yellow;
    } else {
      color = AppColors.green;
    }
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
