import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Optional actions
  final bool showBackButton;

  const CommonAppBar({super.key, required this.title, this.actions, this.showBackButton = true,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions:
          actions ??
          [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
