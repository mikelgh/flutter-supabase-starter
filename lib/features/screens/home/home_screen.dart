import 'package:flutter/material.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/supabase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(SupabaseService.client);
    final user = authRepository.currentUser;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome ${user?.email ?? 'User'}'),
          Text('Home Screen Content'),
          SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () async {
          //     final authRepository = AuthRepository(SupabaseService.client);
          //     await authRepository.signOut();
          //     context.go('/');
          //   },
          //   child: const Text('Sign Out'),
          // ),
        ],
      ),
    );
  }
}
