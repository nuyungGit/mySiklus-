import 'package:flutter/material.dart';
import 'features/main_navigation_screen.dart';

/// Halaman SplashScreen aplikasi mySiklus
/// Menampilkan identitas visual estetik dan mengarahkan ke halaman utama
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F6),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF4F3F6),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Bagian Tengah: Logo & Judul Aplikasi
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO SINTETIS: Lingkaran berdiameter 110 dengan gradien dan bayangan
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFB5838D), // Deep Dusty Rose
                            Color(0xFFE5989B), // Warm Pink
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            spreadRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.water_drop_rounded,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Teks Judul 'mySiklus'
                    const Text(
                      'mySiklus',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB5838D),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Sub-judul
                    Text(
                      'Harmoni Siklus & Fiqh Wanita',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Bagian Bawah: Loading Indicator Halus & Status
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFB6C1), // Pastel pink
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Memuat data aman...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

