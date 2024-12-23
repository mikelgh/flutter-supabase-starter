import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class DatabaseRepository {
  final SupabaseClient _supabaseClient;

  DatabaseRepository(this._supabaseClient);

  Future<UserModel?> fetchUser(String userId) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } catch (e) {
      // print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _supabaseClient.from('users').insert(user.toJson());
    } catch (e) {
      // print('Error creating user: $e');
    }
  }
}
