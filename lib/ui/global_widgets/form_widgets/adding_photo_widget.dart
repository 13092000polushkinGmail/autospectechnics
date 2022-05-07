import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddingPhotoWidget extends StatelessWidget {
  final double width;
  final double height;
  final Function() onTap;
  const AddingPhotoWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: SizedBox(
            width: width,
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.blue,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}