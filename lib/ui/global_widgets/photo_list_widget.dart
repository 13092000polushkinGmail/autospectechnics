import 'package:flutter/material.dart';

import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';

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
                  itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        Navigator.push<MaterialPageRoute>(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return _FullScreenImage(
                                imageUrl: photosURL[index],
                                tag: photosURL[index],
                              );
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: NetworkImageWidget(url: photosURL[index]))),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

//TODO Внедрить во все места, где надо открывать картинку на весь экран
class _FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const _FullScreenImage({
    Key? key,
    required this.imageUrl,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: NetworkImageWidget(url: imageUrl),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
