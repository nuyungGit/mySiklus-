import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/supabase_service.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF5F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB5838D),
          primary: const Color(0xFFB5838D),
          secondary: const Color(0xFFFFB6C1),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFB5838D),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFB5838D),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: Colors.white,
          shadowColor: const Color(0x14B5838D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
