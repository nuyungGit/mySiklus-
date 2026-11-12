import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Halaman Panduan Lengkap Darah Istihadah dan Tata Cara Bersuci
/// Berdasarkan fiqih Mazhab Syafi'i (Kitab Safinatun Naja dan Fathul Qorib)
class IstihadahScreen extends StatelessWidget {
  const IstihadahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Darah Istihadah'),
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
                      color: AppColors.badgeIstihadahBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.healing_rounded,
                      color: AppColors.badgeIstihadahText,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fiqh Darah Istihadah',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Panduan bersuci (thaharah) dan pelaksanaan ibadah bagi wanita beristihadah.',
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

            // 2. Card 1: Pengertian Istihadah
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
                            Icons.info_outline_rounded,
                            size: 20,
                            color: AppColors.badgeIstihadahText,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pengertian Istihadah',
                            style: TextStyle(
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
                          color: AppColors.badgeSuciBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Tetap Suci',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.badgeSuciText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),
                  const Text(
                    'Darah penyakit yang keluar di luar batas haid/nifas. Wanita istihadah tetap SUCI dan WAJIB melaksanakan shalat serta puasa.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Card 2: Tata Cara Bersuci
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
                            Icons.clean_hands_rounded,
                            size: 20,
                            color: AppColors.sageGreenDark,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Tata Cara Bersuci',
                            style: TextStyle(
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
                          color: AppColors.sageGreenLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '1 Wudhu = 1 Shalat',
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
                    'Wajib dilakukan SETIAP KALI masuk waktu shalat fardhu (1 wudhu hanya sah untuk 1 shalat fardhu):',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 14),

                  // Poin 1: Bersihkan
                  _buildStepItem(
                    number: '1',
                    title: 'Bersihkan',
                    content: 'Bersihkan area kemaluan dari darah.',
                  ),
                  const SizedBox(height: 14),

                  // Poin 2: Balut
                  _buildStepItem(
                    number: '2',
                    title: 'Balut',
                    content:
                        'Gunakan kapas terlebih dahulu, kemudian gunakan pembalut untuk meminimalisir tetesan darah. Perlu digarisbawahi bahwa penggunaan kapas ini dilakukan JIKA TIDAK menyakiti wanita tersebut. Apabila timbul rasa sakit (atau membahayakan) ketika menggunakan kapas, maka diperbolehkan langsung menggunakan pembalut saja.',
                  ),
                  const SizedBox(height: 14),

                  // Poin 3: Wudhu Segera
                  _buildStepItem(
                    number: '3',
                    title: 'Wudhu Segera',
                    content:
                        'Lakukan wudhu secara Muwalah (terus-menerus/tidak terputus) setelah masuk waktu shalat (adzan).',
                  ),
                  const SizedBox(height: 14),

                  // Poin 4: Niat Wudhu Khusus
                  _buildNiatWudhuItem(),
                  const SizedBox(height: 14),

                  // Poin 5: Segera Shalat
                  _buildStepItem(
                    number: '5',
                    title: 'Segera Shalat',
                    content:
                        'Setelah bersuci/melaksanakan wudhu\' maka hendaknya segera laksanakan shalat tanpa jeda/menunda, kecuali untuk kemaslahatan shalat (seperti menjawab adzan atau merapatkan shaf).',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Card 3: Referensi Kitab di Bagian Paling Bawah
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
                      'Sumber Rujukan Mazhab Syafi\'i: Kitab Safinatun Naja dan Fathul Qorib.',
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

  Widget _buildStepItem({
    required String number,
    required String title,
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNiatWudhuItem() {
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
          child: const Text(
            '4',
            style: TextStyle(
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
              const Text(
                'Niat Wudhu Khusus',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'نَوَيْتُ الْوُضُوْءَ لِاسْتِبَاحَةِ فَرْضِ الصَّلاَةِ للهِ تَعَالَى',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Latin:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Nawaitul wudhu\'a li-istibaahati fardhish shalaati lillaahi ta\'aalaa',
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sageGreenDark,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '(Niat berwudhu agar diperbolehkan shalat fardhu)',
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
      ],
    );
  }
}

