import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasBackButton;

  const AppBarWidget({
    Key? key,
    required this.title,
    required this.hasBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leading = hasBackButton
        ? IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () => Navigator.pop(context),
          )
        : const SizedBox.shrink();
    return AppBar(
      title: Text(title),
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
