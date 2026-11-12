import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Halaman Panduan Larangan & Amalan Saat Haid
/// Berdasarkan fiqih Mazhab Syafi'i (Kitab Safinatun Naja, Fathul Qorib, & Kasyifatus Saja)
class LaranganAmalanScreen extends StatelessWidget {
  const LaranganAmalanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Larangan & Amalan Haid'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      color: AppColors.softMauveLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: AppColors.softMauve,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fiqh Ibadah Wanita Haid',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Panduan praktis menjaga keabsahan syariat serta meraih pahala saat masa pendarahan.',
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

            // 2. Kategori 1: Larangan (Haram) Saat Haid
            _buildCategoryCard(
              context: context,
              title: 'Larangan (Haram) Saat Haid',
              subtitle: '8 Perkara yang diharamkan syariat selama haid',
              badgeText: 'Haram',
              badgeColor: AppColors.dustyRoseDark,
              badgeBg: AppColors.badgeHaidBg,
              icon: Icons.block_rounded,
              items: const [
                'Shalat (fardhu & sunnah)',
                'Puasa (fardhu Ramadan & sunnah)',
                'Membaca Al-Qur\'an (dengan niat tilawah)',
                'Menyentuh dan membawa Mushaf Al-Qur\'an',
                'Thawaf (di Ka\'bah)',
                'Berdiam diri (I\'tikaf) di dalam masjid',
                'Berhubungan suami istri (Jima\')',
                'Mandi wajib/bersuci sebelum darah benar-benar berhenti',
              ],
              isLarangan: true,
            ),

            const SizedBox(height: 16),

            // 3. Kategori 2: Amalan yang Dianjurkan (Boleh)
            _buildCategoryCard(
              context: context,
              title: 'Amalan yang Dianjurkan (Boleh)',
              subtitle: '8 Pintu ibadah dan pahala yang tetap terbuka',
              badgeText: 'Dianjurkan',
              badgeColor: AppColors.sageGreenDark,
              badgeBg: AppColors.badgeSuciBg,
              icon: Icons.check_circle_outline_rounded,
              items: const [
                'Berdzikir (istighfar, tasbih, tahlil)',
                'Bershalawat kepada Nabi',
                'Berdoa (kapan pun dan dalam kondisi apa pun)',
                'Mendengarkan lantunan ayat Al-Qur\'an (murottal)',
                'Bersedekah dan beramal jariyah',
                'Mendatangi majelis ilmu (di luar area masjid)',
                'Membaca Al-Qur\'an JIKA niatnya murni untuk dzikir/perlindungan (seperti ayat kursi atau doa harian)',
                'Menjaga kebersihan diri dan berpakaian rapi',
              ],
              isLarangan: false,
            ),

            const SizedBox(height: 20),

            // 4. Card Referensi di Bagian Paling Bawah
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
                      'Sumber Rujukan Mazhab Syafi\'i: Kitab Safinatun Naja (Fasal Perkara yang Haram Sebab Hadats Besar & Haid), Kitab Fathul Qorib, dan Kasyifatus Saja.',
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
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
    required IconData icon,
    required List<String> items,
    required bool isLarangan,
  }) {
    return Container(
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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: badgeColor,
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          trailing: Container(
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
          children: [
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 14),
            ...List.generate(items.length, (index) {
              final number = index + 1;
              final text = items[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

