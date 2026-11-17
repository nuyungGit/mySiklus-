// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/cycle_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleState = ref.watch(cycleProvider);
    final authState = ref.watch(authProvider);
    final cycleNotifier = ref.read(cycleProvider.notifier);

    // Variabel dinamis nama pengguna dari state management/profil, atau fallback ke dummy
    final String namaPengguna = authState.user?.name ?? 'Nama Kamu';
    final isHaid = cycleState.isOngoingHaid;
    final purityDays = cycleState.purityDaysRunning;
    final haidDays = cycleState.currentHaidDuration;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header Sapaan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        namaPengguna,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.softMauve),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('d MMM yyyy', 'id_ID').format(DateTime.now()),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2. Kartu Status Utama Real-Time (Masa Suci vs Haid)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHaid
                        ? [const Color(0xFFFDE8E8), const Color(0xFFFFF5F5)]
                        : [const Color(0xFFEAF5EF), const Color(0xFFF7FAF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isHaid ? AppColors.dustyRose.withOpacity(0.3) : AppColors.sageGreen.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isHaid ? AppColors.dustyRose : AppColors.sageGreen).withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Badge Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isHaid ? AppColors.dustyRose : AppColors.sageGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isHaid ? 'Status: Sedang Haid' : 'Status: Masa Suci Aktif',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Counter Besar
                    Text(
                      isHaid ? 'Hari ke-$haidDays' : 'Hari ke-$purityDays',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: isHaid ? AppColors.dustyRoseDark : AppColors.sageGreenDark,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Copywriting Netral Berbasis Fiqh
                    Text(
                      isHaid
                          ? 'Kamu sedang berada dalam periode haid'
                          : 'Kamu sedang berada di masa suci sejak catatan terakhir',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Indikator Kemajuan Batas Minimal 15 Hari Suci (Mazhab Syafi'i)
                    if (!isHaid) ...[
                      const Divider(color: AppColors.divider, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ambang Jeda Suci (Min. 15 Hari)',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            purityDays >= 15 ? 'Terpenuhi (Sah)' : '$purityDays / 15 Hari',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: purityDays >= 15 ? AppColors.sageGreenDark : AppColors.softMauve,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (purityDays / 15).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            purityDays >= 15 ? AppColors.sageGreen : AppColors.softMauve,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Tombol Interaktif Pencatatan Cepat
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isHaid
                          ? null
                          : () => _confirmAction(
                                context,
                                title: 'Catat Mulai Haid?',
                                message: 'Sistem akan membuka siklus baru mulai hari ini.',
                                confirmText: 'Ya, Mulai Haid',
                                onConfirm: () => cycleNotifier.startHaid(),
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sageGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.border,
                        disabledForegroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.water_drop_outlined, size: 18),
                      label: const Text('Mulai Haid'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: !isHaid
                          ? null
                          : () => _confirmAction(
                                context,
                                title: 'Tandai Darah Berhenti (Suci)?',
                                message: 'Sistem akan menghitung durasi haid dan mengaktifkan hitungan masa suci.',
                                confirmText: 'Ya, Sudah Bersih',
                                onConfirm: () => cycleNotifier.markSuci(),
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sageGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.border,
                        disabledForegroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Tandai Suci'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 4. Kartu Pengingat Ibadah & Edukasi Cerdas
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.softMauveLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.mosque_outlined, color: AppColors.softMauve, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHaid ? 'Amalan Saat Masa Haid' : 'Kewajiban Ibadah Harian',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isHaid
                                ? 'Perbanyak dzikir, istighfar, mendengarkan lantunan Al-Qur\'an, dan bersedekah.'
                                : 'Tetap istiqamah menjaga salat fardhu tepat waktu dan puasa wajib/sunnah.',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. Riwayat Siklus Terakhir
              const Text(
                'Riwayat Terakhir',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              if (cycleState.history.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text(
                      'Belum ada catatan siklus tersimpan.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                )
              else
                ...cycleState.history.take(3).map((cycle) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 6,
                              backgroundColor: cycle.endDate == null ? AppColors.dustyRose : AppColors.sageGreen,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('d MMMM yyyy', 'id_ID').format(cycle.startDate),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cycle.endDate != null
                                      ? 'Selesai: ${DateFormat('d MMM yyyy', 'id_ID').format(cycle.endDate!)}'
                                      : 'Masih berlangsung',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cycle.endDate != null ? '${cycle.durationHaid ?? 1} Hari Haid' : 'Sedang Haid',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text(message, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sageGreen,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
