import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Halaman Panduan Mandi Wajib (Ghusl) setelah haid
/// Berdasarkan ketetapan fiqih Mazhab Syafi'i (Safinatun Naja & Fathul Qorib)
class MandiWajibScreen extends StatelessWidget {
  const MandiWajibScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Mandi Wajib'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.sageGreenLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.clean_hands_rounded,
                        color: AppColors.sageGreenDark,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tata Cara Bersuci (Ghusl)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Wajib dilakukan setelah darah haid berhenti sempurna sebelum mendirikan salat atau puasa.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Card Niat Mandi Wajib
              _buildSectionCard(
                title: 'Niat Mandi Wajib',
                badgeText: 'Wajib',
                badgeColor: AppColors.dustyRose,
                badgeBg: AppColors.badgeHaidBg,
                icon: Icons.favorite_border_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Teks Arab
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'نَوَيْتُ الْغُسْلَ لِرَفْعِ الْحَدَثِ اْلاَكْبَرِ مِنَ الحَيْضِ فَرْضًا ِللهِ تَعَالَى',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 2.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Teks Latin
                    const Text(
                      'Latin:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nawaitul ghusla liraf\'il hadatsil akbari minal haidhi fardhan lillaahi ta\'aalaa.',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sageGreenDark,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Arti
                    const Text(
                      'Artinya: "Aku berniat mandi untuk mengangkat hadats besar dari haid, fardhu karena Allah Ta\'ala."',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Card Rukun Mandi (Wajib)
              _buildSectionCard(
                title: 'Rukun Mandi (Wajib)',
                badgeText: 'Syarat Sah',
                badgeColor: AppColors.dustyRoseDark,
                badgeBg: AppColors.badgeHaidBg,
                icon: Icons.check_circle_outline_rounded,
                child: Column(
                  children: [
                    _buildStepItem(
                      number: '1',
                      title: 'Niat',
                      description:
                          'Niat (diucapkan di dalam hati bersamaan dengan saat air pertama kali menyentuh bagian tubuh mana saja).',
                    ),
                    const SizedBox(height: 12),
                    _buildStepItem(
                      number: '2',
                      title: 'Meratakan Air',
                      description:
                          'Meratakan air ke seluruh bagian luar tubuh, termasuk rambut, sela-sela lipatan kulit, dan kuku.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Card Sunnah Mandi
              _buildSectionCard(
                title: 'Sunnah Mandi',
                badgeText: 'Penyempurna',
                badgeColor: AppColors.sageGreenDark,
                badgeBg: AppColors.badgeSuciBg,
                icon: Icons.stars_rounded,
                child: Column(
                  children: [
                    _buildStepItem(
                      number: '1',
                      description: 'Membaca Basmalah di awal.',
                      isSunnah: true,
                    ),
                    const SizedBox(height: 10),
                    _buildStepItem(
                      number: '2',
                      description: 'Membersihkan kotoran dan area kemaluan terlebih dahulu.',
                      isSunnah: true,
                    ),
                    const SizedBox(height: 10),
                    _buildStepItem(
                      number: '3',
                      description: 'Berwudhu dengan sempurna sebelum mulai mandi.',
                      isSunnah: true,
                    ),
                    const SizedBox(height: 10),
                    _buildStepItem(
                      number: '4',
                      description: 'Menyela-nyela pangkal rambut dengan jari.',
                      isSunnah: true,
                    ),
                    const SizedBox(height: 10),
                    _buildStepItem(
                      number: '5',
                      description:
                          'Mendahulukan anggota tubuh bagian kanan, lalu kiri (masing-masing 3 kali basuhan).',
                      isSunnah: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. Card Khusus Referensi di Bagian Paling Bawah
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 20,
                      color: AppColors.softMauve,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sumber Rujukan Mazhab Syafi\'i: Kitab Safinatun Naja (Syekh Salim bin Sumair Al-Hadhrami) dan Kitab Fathul Qorib (Syekh Muhammad bin Qasim Al-Ghazi).',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: badgeColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String number,
    String? title,
    required String description,
    bool isSunnah = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isSunnah ? AppColors.sageGreenLight : AppColors.badgeHaidBg,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSunnah ? AppColors.sageGreenDark : AppColors.dustyRoseDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

