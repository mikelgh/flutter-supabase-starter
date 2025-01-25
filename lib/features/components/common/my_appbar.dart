import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  const MyAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: title);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
