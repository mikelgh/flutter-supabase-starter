import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/services/supabase_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = AuthRepository(SupabaseService.client);
    final user = authRepository.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${user?.email ?? 'User'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authRepository.signOut();
                // Navigate to auth screen
                print('Signed out');
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
