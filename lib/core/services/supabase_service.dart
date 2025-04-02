import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static SupabaseClient? _supabaseClient;

  static Future<void> initialize() async {
    if (_supabaseClient != null) {
      return;
    }

    await dotenv.load(fileName: ".env");

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    _supabaseClient = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_supabaseClient == null) {
      throw Exception(
        'Supabase client not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _supabaseClient!;
  }
}
