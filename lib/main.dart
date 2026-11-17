import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi koneksi Supabase
  try {
    await SupabaseService.initialize();
    debugPrint('[mySiklus] Supabase berhasil diinisialisasi.');
  } catch (e) {
    debugPrint('[mySiklus] Peringatan koneksi Supabase: $e');
  }

  runApp(
    const ProviderScope(
      child: MySiklusApp(),
    ),
  );
}

class MySiklusApp extends StatelessWidget {
  const MySiklusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mySiklus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
