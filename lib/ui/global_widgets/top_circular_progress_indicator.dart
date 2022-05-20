import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopCircularProgressIndicator extends StatelessWidget {
  const TopCircularProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 12),
      child: Align(
        alignment: Alignment.topCenter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }
}