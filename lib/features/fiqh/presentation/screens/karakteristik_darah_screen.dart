import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Halaman Panduan Karakteristik & Tingkatan Darah (Fiqih Mazhab Syafi'i)
/// Berdasarkan Kitab Fathul Qorib dan Risalatul Mahid
class KarakteristikDarahScreen extends StatelessWidget {
  const KarakteristikDarahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karakteristik & Tingkatan Darah'),
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
                      color: AppColors.badgeHaidBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: AppColors.badgeHaidText,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Karakteristik Darah Kewanitaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mengenal 5 warna, kondisi sifat darah, dan penentuan hukum saat istihadah.',
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

            // 2. Card 1: 5 Warna Darah (Urutan Terkuat ke Lemah)
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.palette_outlined,
                            size: 20,
                            color: AppColors.badgeHaidText,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '5 Warna Darah',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.badgeHaidBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Terkuat → Lemah',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.badgeHaidText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Urutan tingkatan kekuatan darah berdasarkan warnanya dalam Mazhab Syafi\'i:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),

                  _buildColorItem(
                    number: '1',
                    colorName: 'Hitam (Aswad)',
                    level: 'Paling Kuat',
                    levelColor: const Color(0xFF212121),
                    levelBgColor: const Color(0xFFEEEEEE),
                    dotColor: const Color(0xFF1A1A1A),
                    desc: 'Darah berwarna paling pekat dan menjadi tingkatan warna tertinggi.',
                  ),
                  const SizedBox(height: 12),

                  _buildColorItem(
                    number: '2',
                    colorName: 'Merah (Ahmar)',
                    level: 'Kuat',
                    levelColor: const Color(0xFFC62828),
                    levelBgColor: const Color(0xFFFFEBEE),
                    dotColor: const Color(0xFFC62828),
                    desc: 'Warna darah umum yang lebih lemah dari hitam namun lebih kuat dari pirang.',
                  ),
                  const SizedBox(height: 12),

                  _buildColorItem(
                    number: '3',
                    colorName: 'Merah Kekuningan / Pirang (Asyqar)',
                    level: 'Sedang',
                    levelColor: const Color(0xFFD84315),
                    levelBgColor: const Color(0xFFFBE9E7),
                    dotColor: const Color(0xFFD84315),
                    desc: 'Campuran warna merah dan kuning kecoklatan.',
                  ),
                  const SizedBox(height: 12),

                  _buildColorItem(
                    number: '4',
                    colorName: 'Kuning (Asfar / Shufrah)',
                    level: 'Lemah',
                    levelColor: const Color(0xFFB57E12),
                    levelBgColor: const Color(0xFFFFF6E5),
                    dotColor: const Color(0xFFE6A117),
                    desc: 'Cairan menyerupai nanah yang berwarna kekuning-kuningan.',
                  ),
                  const SizedBox(height: 12),

                  _buildColorItem(
                    number: '5',
                    colorName: 'Keruh / Kecoklatan (Kadir / Kudrah)',
                    level: 'Paling Lemah',
                    levelColor: const Color(0xFF6D4C41),
                    levelBgColor: const Color(0xFFEFEBE9),
                    dotColor: const Color(0xFF795548),
                    desc: 'Cairan keruh seperti air cucian daging atau air kotor.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Card 2: Sifat (Kondisi) Darah
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.opacity_rounded,
                            size: 20,
                            color: AppColors.sageGreenDark,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sifat (Kondisi) Darah',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreenLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Kekentalan & Aroma',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.sageGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selain warna, darah juga dinilai dari sifatnya. Tingkatan kekuatan sifat darah:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),

                  _buildSifatItem(
                    number: '1',
                    title: 'Kental berbau busuk',
                    rank: 'Paling Kuat',
                    rankColor: AppColors.badgeHaidText,
                    rankBgColor: AppColors.badgeHaidBg,
                    content: 'Memiliki dua unsur kekuatan sekaligus (kental dan berbau busuk/menyengat).',
                  ),
                  const SizedBox(height: 12),

                  _buildSifatItem(
                    number: '2',
                    title: 'Kental',
                    rank: 'Lebih Kuat',
                    rankColor: const Color(0xFFC62828),
                    rankBgColor: const Color(0xFFFFEBEE),
                    content: 'Kekentalan darah menjadikannya lebih kuat daripada darah yang cair (meskipun tidak berbau).',
                  ),
                  const SizedBox(height: 12),

                  _buildSifatItem(
                    number: '3',
                    title: 'Berbau busuk',
                    rank: 'Lebih Kuat',
                    rankColor: const Color(0xFFB57E12),
                    rankBgColor: const Color(0xFFFFF6E5),
                    content: 'Aroma busuk lebih kuat daripada darah yang tidak berbau sama sekali.',
                  ),
                  const SizedBox(height: 12),

                  _buildSifatItem(
                    number: '4',
                    title: 'Tidak kental & tidak berbau busuk',
                    rank: 'Paling Lemah',
                    rankColor: AppColors.textSecondary,
                    rankBgColor: AppColors.surfaceMuted,
                    content: 'Darah cair dan tidak memiliki aroma khas/menyengat.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Card 3: Fungsi Mengetahui Karakteristik
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 20,
                        color: AppColors.softMauve,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Fungsi Mengetahui Karakteristik',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mengapa mengetahui tingkatan warna dan sifat darah ini sangat penting?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),

                  // Poin 1: Penentuan Istihadah vs Haid
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softMauveLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x309B7E8C)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: AppColors.softMauve,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Pembeda Darah Saat Istihadah',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Jika seorang wanita mengalami Istihadah (darah keluar >15 hari), ia bisa menentukan masa haidnya berdasarkan darah "lebih kuat" (misal: hitam/kental dihukumi Haid, merah/cair dihukumi Istihadah).',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Poin 2: Darah Kuat Setelah Darah Lemah ≥15 Hari
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F7F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppColors.dustyRoseDark,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Kaidah Urutan Darah',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Apabila darah kuat keluar setelah darah lemah yang mencapai 15 hari atau lebih, maka darah lemah di awal dihukumi Istihadah dan darah kuat yang keluar setelahnya dihukumi Haid.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5. Card 4: Hukum Khusus Flek
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 20,
                            color: AppColors.badgeIstihadahText,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Hukum Khusus Flek',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.badgeIstihadahBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Kuning / Coklat',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.badgeIstihadahText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.badgeIstihadahBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0x40B57E12),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: AppColors.badgeIstihadahText,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Flek kuning atau coklat tetap dihukumi sebagai darah Haid JIKA keluar masih dalam rentang waktu maksimal haid (15 hari 15 malam).',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B4800),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 6. Card 5: Referensi Kitab di Bagian Paling Bawah
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
                      'Sumber Rujukan: Kitab Fathul Qorib dan Risalatul Mahid.',
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

  Widget _buildColorItem({
    required String number,
    required String colorName,
    required String level,
    required Color levelColor,
    required Color levelBgColor,
    required Color dotColor,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x20000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      colorName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: levelBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      level,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: levelColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSifatItem({
    required String number,
    required String title,
    required String rank,
    required Color rankColor,
    required Color rankBgColor,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.sageGreenLight,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.sageGreenDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: rankBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rank,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: rankColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

