import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_photo_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddingSeveralPhotosWidget extends StatelessWidget {
  final List<Image> imageList;
  final Function() onAddingTap;
  final void Function(BuildContext context, int index) onDeletePhotoTap;
  const AddingSeveralPhotosWidget({
    Key? key,
    required this.imageList,
    required this.onAddingTap,
    required this.onDeletePhotoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return AddingPhotoWidget(
              width: 120,
              height: 120,
              onTap: onAddingTap,
            );
          } else {
            return SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                children: [
                  Positioned(
                      top: 12, right: 12, child: imageList[index - 1]),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircleAvatar(
                        backgroundColor: AppColors.blue,
                        foregroundColor: AppColors.white,
                        child: IconButton(
                          onPressed: () => onDeletePhotoTap(context, index - 1),
                          icon: const Icon(Icons.close_rounded),
                          iconSize: 12,
                          padding: const EdgeInsets.all(0),
                          splashRadius: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}
