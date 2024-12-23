import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository(this._supabaseClient);

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return UserModel(id: response.user!.id, email: response.user!.email);
      }
      return null;
    } catch (e) {
      // print('Error signing in: $e');
      return null;
    }
  }

  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return UserModel(id: response.user!.id, email: response.user!.email);
      }
      return null;
    } catch (e) {
      // print('Error signing up: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  User? get currentUser => _supabaseClient.auth.currentUser;
}
