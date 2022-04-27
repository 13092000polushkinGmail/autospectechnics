import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  //final String imageName;
  final String? url;
  const ImageWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: SizedBox(
        height: 108,
        width: 116,
        child: url == null
            ? const DecoratedBox(
                decoration: BoxDecoration(color: AppColors.greyBorder),
                child: Icon(Icons.image_not_supported_outlined),
              )
            : Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
      ),
      //TODO Вариант до подключения загрузки картинок с сервера
      // child: Image.asset(
      //   imageName,
      //   height: 108,
      //   width: 116,
      //   fit: BoxFit.fill,
      // ),
    );
  }
}
