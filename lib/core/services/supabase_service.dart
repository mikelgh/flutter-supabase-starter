import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static SupabaseClient? _supabaseClient;

  static Future<void> initialize() async {
    if (_supabaseClient != null) {
      return;
    }

    try {
      await dotenv.load(fileName: ".env");

      String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

      if (kDebugMode) {
        print("Supabase URL: $supabaseUrl");
        print("Supabase Key length: ${supabaseAnonKey.length}");
      }

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception('Supabase credentials not found in .env file.');
      }

      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      _supabaseClient = Supabase.instance.client;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Supabase: $e');
      }

      // 如果无法从.env文件加载，则使用硬编码的备用值（仅用于开发目的）
      if (_supabaseClient == null) {
        const String backupUrl = 'https://emtzxsnlduqgmqzutzrz.supabase.co';
        const String backupKey =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVtdHp4c25sZHVxZ21xenV0enJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM1NTY3MDIsImV4cCI6MjA1OTEzMjcwMn0.x4OWZxtSeJDQk3iXpK2TsgpzeOuckyuhTAjDqaxa1_M';

        if (kDebugMode) {
          print('Using backup Supabase credentials');
        }

        await Supabase.initialize(url: backupUrl, anonKey: backupKey);
        _supabaseClient = Supabase.instance.client;
      }
    }
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
