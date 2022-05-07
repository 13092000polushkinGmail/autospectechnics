import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//TODO Падает ошибка, когда отключаешь интернет во время загрузки изображения (Так было до использования кэширования, с кэшированием не проверял)
class NetworkImageWidget extends StatelessWidget {
  final String? url;
  const NetworkImageWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url == null
        ? const DecoratedBox(
            decoration: BoxDecoration(color: AppColors.greyBorder),
            child: Icon(Icons.image_not_supported_outlined),
          )
        : CachedNetworkImage(
            imageUrl: url!,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress),
            ),
            errorWidget: (context, url, dynamic error) =>
                const Icon(Icons.image_not_supported_outlined),
          );
  }
}
//Способ до использования кэширования
// Image.network(
//                 url!,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (BuildContext context, Widget child,
//                     ImageChunkEvent? loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                           : null,
//                     ),
//                   );
//                 },
//               ),