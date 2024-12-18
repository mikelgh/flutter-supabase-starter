// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/services/supabase_service.dart';
import '../components/auth_button.dart';
import '../components/text_field.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const SignInScreen({super.key, required this.onTap});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final authRepository = AuthRepository(SupabaseService.client);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final user = await authRepository.signInWithEmailAndPassword(
      email,
      password,
    );

    if (user != null) {
      // Navigate to home screen
      print('Signed in: ${user.email}');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.login_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 15),

              //app name,
              Text(
                'L O G I N',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Theme.of(context).colorScheme.inversePrimary,
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
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              //login button,
              AuthButton(text: "Login", onPressed: _signIn),

              const SizedBox(height: 25),

              //don't have an account? Register here,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      " Register Here",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
