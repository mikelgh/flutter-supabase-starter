import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _supabaseClient;

  static Future<void> initialize() async {
    if (_supabaseClient != null) {
      return;
    }
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUT_SUPABASEA_ANON_KEY',
    );
    _supabaseClient = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_supabaseClient == null) {
      throw Exception('Supabase client not initialized. Call SupabaseService.initialize() first.');
    }
    return _supabaseClient!;
  }
}
