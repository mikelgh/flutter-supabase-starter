import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pageController = LiquidController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        liquidController: _pageController,
        enableLoop: false,
        preferDragFromRevealedArea : true,
        pages: [
          SignInScreen(onTap: () => _pageController.animateToPage(page: 1)),
          SignUpScreen(onTap: () => _pageController.animateToPage(page: 0)),
        ],
      ),
    );
  }
}
