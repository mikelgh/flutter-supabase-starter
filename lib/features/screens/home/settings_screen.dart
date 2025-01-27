import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_auth/core/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/supabase_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
              child: const Text('Sign Out'),
              onPressed: () async {
                await authRepository.signOut();
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
