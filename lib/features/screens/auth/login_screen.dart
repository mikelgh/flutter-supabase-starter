import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/supabase_service.dart';
import '../../components/auth/auth_button.dart';
import '../../components/auth/text_field.dart';

enum SnackBarType { error, success, info }

class LoginScreen extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Snackbar
  SnackBar floatingSnackBar(String content, SnackBarType snackBarType) {
    final backgroundColor = switch (snackBarType) {
      SnackBarType.error => Colors.red,
      SnackBarType.success => Colors.green,
      SnackBarType.info => Colors.blue,
    };
    return SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(25),
      showCloseIcon: true,
      elevation: 1,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: backgroundColor,
    );
  }

  // Loading circle
  Future<dynamic> _loading() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _login() async {
    final authRepository = AuthRepository(SupabaseService.client);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar('Please fill all fields', SnackBarType.error),
      );
      return;
    }

    // Show loading circle
    _loading();

    try {
      final user = await authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      if (user != null) {
        // Navigate to home screen
        context.go('/home');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(floatingSnackBar('Login Success', SnackBarType.success));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar('Invalid credentials', SnackBarType.error),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(floatingSnackBar('An error occurred', SnackBarType.error));
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.login_rounded,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 15),

                // app name,
                Text(
                  'L O G I N',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),

                const SizedBox(height: 45),

                // email textfield,
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),

                const SizedBox(height: 10),

                // passowrd textfield,
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController,
                ),

                const SizedBox(height: 15),

                //forgot password,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                //login button,
                AuthButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  text: "Login",
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: _login,
                ),

                const SizedBox(height: 25),

                //don't have an account? Register here,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Register Here ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_circle_right_outlined, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
