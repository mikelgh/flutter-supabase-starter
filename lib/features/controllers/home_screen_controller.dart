import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/common/my_appbar.dart';
import '../components/common/bottom_navigation_bar.dart'; // Import the bottom navigation bar component
import '../screens/home/home_screen.dart';
import '../screens/home/settings_screen.dart';
import '../screens/home/profile_screen.dart';

class HomeScreenController extends ConsumerStatefulWidget {
  const HomeScreenController({super.key});

  @override
  ConsumerState<HomeScreenController> createState() =>
      _HomeScreenControllerState();
}

class _HomeScreenControllerState extends ConsumerState<HomeScreenController> {
  int _selectedIndex = 0;

  final _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _title() {
    return _selectedIndex == 0
        ? "Home"
        : _selectedIndex == 1
        ? "Profile"
        : "Settings";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: Text(_title())),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: HomeBottomNavigationBar(
        // Use the imported component
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
