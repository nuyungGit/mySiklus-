import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk mengelola koneksi dan instance Supabase
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  // Konfigurasi Supabase Project
  static const String supabaseUrl = 'https://meshfykkuxztzscsmrzwj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1lc2hmeWtrdXh0enNjc21yendqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5NzQxOTcsImV4cCI6MjEwODU1MDE5N30.olG-946hJkhSBVTEA4c89jBdZRgLXHs5w5z62yqibMM';

  /// Supabase Client instance
  SupabaseClient get client => Supabase.instance.client;

  /// User yang sedang login saat ini
  User? get currentUser {
    try {
      return client.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Cek apakah pengguna sudah terautentikasi
  bool get isAuthenticated => currentUser != null;

  // Nama-nama tabel database Supabase
  static const String tableUsers = 'users';
  static const String tableCycles = 'cycles';
  static const String tableFiqhArticles = 'fiqh_articles';
  static const String tableSearchLogs = 'search_logs';

  /// Inisialisasi koneksi Supabase saat aplikasi dimulai
  static Future<void> initialize({
    String url = supabaseUrl,
    String anonKey = supabaseAnonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      // ignore: deprecated_member_use
      anonKey: anonKey,
    );
  }
}
