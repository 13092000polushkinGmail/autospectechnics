import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageName;
  const ImageWidget({
    Key? key,
    required this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Image.asset(
        imageName,
        height: 108,
        width: 116,
        fit: BoxFit.fill,
      ),
    );
  }
}