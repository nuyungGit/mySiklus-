import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.sageGreenLight,
                      child: Icon(Icons.person_outline, size: 32, color: AppColors.sageGreenDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Muslimah',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'local@mysiklus.app',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: authState.isGuestMode ? AppColors.surfaceMuted : AppColors.badgeSuciBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              authState.isGuestMode ? 'Penyimpanan Lokal (Offline)' : 'Tersinkronisasi Cloud (Supabase)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: authState.isGuestMode ? AppColors.textSecondary : AppColors.badgeSuciText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Konfigurasi Syariat',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),

              // Pengaturan Mazhab
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const ListTile(
                  leading: Icon(Icons.menu_book, color: AppColors.sageGreen),
                  title: Text('Rujukan Mazhab Fiqh', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('Mazhab Syafi\'i (Min. suci 15 hari, maks. haid 15 hari)', style: TextStyle(fontSize: 12)),
                  trailing: Icon(Icons.check, color: AppColors.sageGreen, size: 20),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Tentang Aplikasi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('mySiklus Mobile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('v1.0.0 (Release Candidate)', style: TextStyle(fontSize: 12, color: AppColors.softMauve, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Aplikasi asisten pencatatan masa suci dan sistem temu kembali panduan hukum darah wanita dengan metode TF-IDF dan Cosine Similarity.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                    ),
                    Divider(height: 24, color: AppColors.divider),
                    Row(
                      children: [
                        Icon(Icons.school_outlined, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Text('Tugas Akhir / Skripsi Semester 7', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Reset / Ganti Akun
              OutlinedButton.icon(
                onPressed: () => authNotifier.signOut(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.dustyRoseDark,
                  side: const BorderSide(color: AppColors.dustyRose),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Keluar / Ganti Akun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
