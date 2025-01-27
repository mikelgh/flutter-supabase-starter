import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const HomeBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: 'Home',
          activeIcon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: 'Profile',
          activeIcon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: 'Settings',
          activeIcon: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
