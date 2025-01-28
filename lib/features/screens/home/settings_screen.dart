import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_auth/core/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/supabase_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snackbar(
    BuildContext context,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('See you later!'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(25),
        showCloseIcon: true,
        elevation: 1,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Future<dynamic> _loading(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = AuthRepository(SupabaseService.client);
    final user = authRepository.currentUser;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings Screen Content'),
            Text('You logged in as ${user?.email ?? 'User'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme?.primary,
                foregroundColor:
                    Theme.of(context).buttonTheme.colorScheme?.onPrimary,
              ),
              child: const Text('Logout'),
              onPressed: () async {
                // Show loading indicator
                _loading(context);

                // Sign out and Navigate to login screen
                await authRepository.signOut();
                context.go('/');

                // Show snackbar
                _snackbar(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
