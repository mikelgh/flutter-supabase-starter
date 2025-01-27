import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color color;
  final void Function()? onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 18.0, color: color)),
      ),
    );
  }
}
