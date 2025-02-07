import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/supabase_service.dart';
import '../../components/auth/auth_button.dart';
import '../../components/auth/text_field.dart';

enum SnackBarType { error, success, info }

class RegisterScreen extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  ConsumerState<RegisterScreen> createState() => RegisterScreenpScreenState();
}

class RegisterScreenpScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  Future<void> _register() async {
    final authRepository = AuthRepository(SupabaseService.client);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar('Please fill all fields', SnackBarType.error),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar('Passwords do not match', SnackBarType.error),
      );
      return;
    }

    // Show loading circle
    _loading();

    try {
      await authRepository.signUpWithEmailAndPassword(email, password);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar('Successfully signed up', SnackBarType.success),
        );
        Navigator.of(context).pop();
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(floatingSnackBar(e.toString(), SnackBarType.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.app_registration_rounded,
                  size: 100,
                  color: Theme.of(context).colorScheme.tertiary,
                ),

                const SizedBox(height: 15),

                //app name,
                Text(
                  'R E G I S T E R',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),

                const SizedBox(height: 45),

                // username textfield,
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: _usernameController,
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                // confirm passowrd textfield,
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confirmPasswordController,
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
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  text: "Register",
                  color: Theme.of(context).colorScheme.onSecondary,
                  onPressed: _register,
                ),

                const SizedBox(height: 25),

                //don't have an account? Register here,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Login Here ",
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
