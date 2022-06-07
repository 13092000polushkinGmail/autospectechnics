import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SeveralPhotosFromServerWidget extends StatelessWidget {
  final Map<String, String> imageIdURLs;
  final void Function(BuildContext context, String imageId) onDeletePhotoTap;
  const SeveralPhotosFromServerWidget({
    Key? key,
    required this.imageIdURLs,
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
        itemCount: imageIdURLs.length,
        itemBuilder: (_, index) {
          return SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: SizedBox(
                    height: 96,
                    width: 96,
                    child: NetworkImageWidget(
                      url: imageIdURLs.values.toList()[index],
                    ),
                  ),
                ),
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
                        onPressed: () => onDeletePhotoTap(
                            context, imageIdURLs.keys.toList()[index]),
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
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}
