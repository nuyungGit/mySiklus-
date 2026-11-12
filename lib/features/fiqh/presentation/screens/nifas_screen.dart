import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Halaman Panduan Darah Nifas, Keguguran, Jeda Suci, dan Mandi Wiladah
/// Berdasarkan ketetapan fiqih Mazhab Syafi'i:
/// Safinatun Naja, Fathul Qorib, Hasyiyah Al-Bajuri, dan I'anatut Thalibin
class NifasScreen extends StatelessWidget {
  const NifasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Darah Nifas'),
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
                      Icons.pregnant_woman_rounded,
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
                          'Fiqh Nifas & Wiladah',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Panduan hukum pasca persalinan, keguguran, dan tata cara bersuci.',
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

            // Card 1: Pengertian Nifas & Keguguran
            _buildInfoCard(
              title: 'Pengertian Nifas & Keguguran',
              badgeText: 'Definisi',
              badgeBg: AppColors.badgeHaidBg,
              badgeColor: AppColors.dustyRoseDark,
              icon: Icons.info_outline_rounded,
              content:
                  'Darah yang keluar setelah rahim kosong dari janin. Jika seorang ibu keguguran dalam fase \'Alaqah (segumpal darah) atau Mudghah (segumpal daging) yang menurut ahli medis/bidan merupakan cikal bakal janin, maka darah yang keluar setelahnya tetap dihukumi Nifas.',
            ),

            const SizedBox(height: 12),

            // Card 2: Batas Waktu Nifas
            _buildTimeLimitCard(
              title: 'Batas Waktu Nifas',
              badgeText: 'Durasi',
              badgeBg: AppColors.badgeSuciBg,
              badgeColor: AppColors.sageGreenDark,
              icon: Icons.timer_outlined,
              minimalText: 'Minimal: Lajhah (sekejap)',
              umumText: 'Umumnya: 40 hari',
              maksimalText: 'Maksimal: 60 hari',
            ),

            const SizedBox(height: 12),

            // Card 3: Darah Sebelum Melahirkan
            _buildInfoCard(
              title: 'Darah Sebelum Melahirkan',
              badgeText: 'Bukan Nifas',
              badgeBg: AppColors.badgeHaidBg,
              badgeColor: AppColors.dustyRoseDark,
              icon: Icons.warning_amber_rounded,
              content:
                  'Darah yang keluar sebelum melahirkan, atau saat sedang kontraksi (pembukaan) namun bayi belum keluar seluruhnya, BUKAN darah nifas. Darah tersebut dihukumi Haid (jika memenuhi syarat 24 jam) atau darah Istihadah/penyakit.',
            ),

            const SizedBox(height: 12),

            // Card 4: Kasus Jeda Suci 15 Hari
            _buildInfoCard(
              title: 'Kasus Jeda Suci 15 Hari',
              badgeText: 'Haid Baru',
              badgeBg: AppColors.badgeSuciBg,
              badgeColor: AppColors.sageGreenDark,
              icon: Icons.swap_horiz_rounded,
              content:
                  'Jika setelah melahirkan darah berhenti hingga mencapai batas minimal masa suci (15 hari 15 malam), namun setelah itu darah keluar lagi, maka darah baru tersebut dihukumi HAID, bukan nifas. Masa nifasnya dianggap sudah selesai.',
            ),

            const SizedBox(height: 12),

            // Card 5: Melahirkan Anak Kembar
            _buildInfoCard(
              title: 'Melahirkan Anak Kembar',
              badgeText: 'Kelahiran Terakhir',
              badgeBg: AppColors.softMauveLight,
              badgeColor: AppColors.softMauve,
              icon: Icons.people_outline_rounded,
              content:
                  'Masa nifas baru dihitung setelah anak yang terakhir (kedua) lahir.',
            ),

            const SizedBox(height: 12),

            // Card 6: Hukum Mandi Wiladah (Melahirkan)
            _buildInfoCard(
              title: 'Hukum Mandi Wiladah (Melahirkan)',
              badgeText: 'Wiladah',
              badgeBg: AppColors.badgeSuciBg,
              badgeColor: AppColors.sageGreenDark,
              icon: Icons.clean_hands_rounded,
              content:
                  'Proses melahirkan itu sendiri mewajibkan mandi besar, meskipun bayi lahir dalam keadaan kering (tanpa keluar darah). Jika setelah melahirkan langsung mengeluarkan darah nifas, pelaksanaan Mandi Wiladah ditangguhkan dan niatnya boleh digabung sekaligus dengan Mandi Nifas ketika darah sudah benar-benar berhenti.',
              niatArab: 'نَوَيْتُ الْغُسْلَ لِرَفْعِ حَدَثِ الْوِلاَدَةِ ِللهِ تَعَالَى',
              niatLatin: 'Nawaitul ghusla liraf\'i hadatsil wilaadati lillaahi ta\'aalaa.',
            ),

            const SizedBox(height: 12),

            // Card 7: Kewajiban Mandi Nifas
            _buildInfoCard(
              title: 'Kewajiban Mandi Nifas',
              badgeText: 'Wajib Bersuci',
              badgeBg: AppColors.badgeHaidBg,
              badgeColor: AppColors.dustyRoseDark,
              icon: Icons.check_circle_outline_rounded,
              content:
                  'Wajib mandi besar dengan niat nifas segera setelah darah berhenti (suci) atau ketika sudah menembus batas maksimal 60 hari.',
              niatArab: 'نَوَيْتُ الْغُسْلَ لِرَفْعِ حَدَثِ النِّفَاسِ ِللهِ تَعَالَى',
              niatLatin: 'Nawaitul ghusla liraf\'i hadatsin nifaasi lillaahi ta\'aalaa.',
            ),

            const SizedBox(height: 20),

            // Card 8: Referensi Kitab di Bagian Paling Bawah
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
                      'Sumber Rujukan Mazhab Syafi\'i: Kitab Safinatun Naja, Fathul Qorib, Hasyiyah Al-Bajuri (untuk detail keguguran/nifas), dan I\'anatut Thalibin (untuk hukum mandi wiladah dan gabung niat).',
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

  Widget _buildInfoCard({
    required String title,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required IconData icon,
    required String content,
    String? niatArab,
    String? niatLatin,
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
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, size: 20, color: badgeColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
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
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          if (niatArab != null && niatLatin != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Niat:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    niatArab,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      height: 1.9,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Latin:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    niatLatin,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeLimitCard({
    required String title,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required IconData icon,
    required String minimalText,
    required String umumText,
    required String maksimalText,
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
                      fontSize: 14,
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
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeColumn('Minimal', 'Lajhah (sekejap)'),
                Container(width: 1, height: 32, color: AppColors.border),
                _buildTimeColumn('Umumnya', '40 hari'),
                Container(width: 1, height: 32, color: AppColors.border),
                _buildTimeColumn('Maksimal', '60 hari'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Minimal: Lajhah (sekejap). Umumnya: 40 hari. Maksimal: 60 hari.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

