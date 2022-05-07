import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:flutter/material.dart';

class PhotoListWidget extends StatelessWidget {
  final List<String> photosURL;
  const PhotoListWidget({
    Key? key,
    required this.photosURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return photosURL.isNotEmpty
        ? Column(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  itemCount: photosURL.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) =>
                  //TODO Подумать, нужно ли здесь кэшировтаь картинки
                      NetworkImageWidget(url: photosURL[index]),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
