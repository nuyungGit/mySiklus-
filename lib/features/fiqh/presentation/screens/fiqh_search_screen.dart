import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'mandi_wajib_screen.dart';
import 'larangan_amalan_screen.dart';
import 'nifas_screen.dart';
import 'istihadah_screen.dart';
import 'karakteristik_darah_screen.dart';
import 'qadha_puasa_screen.dart';

/// Model data representasi Tanya Jawab (FAQ) Fiqh
class FiqhFaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final String reference;
  final List<String> keywords;

  const FiqhFaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.reference,
    this.keywords = const [],
  });
}

class FiqhSearchScreen extends StatefulWidget {
  const FiqhSearchScreen({super.key});

  @override
  State<FiqhSearchScreen> createState() => _FiqhSearchScreenState();
}

class _FiqhSearchScreenState extends State<FiqhSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// Daftar FAQ Fiqih & Studi Kasus:
  /// (a) Beda darah haid dan istihadah
  /// (b) Hukum flek sebelum haid
  /// (c) Batas waktu maksimal masa haid
  /// (d) Studi Kasus: Hukum Darah Putus-Nyambung (Talfiq)
  /// (e) Studi Kasus: Keluar Darah > 15 Hari Beda Warna (Tamyiz)
  final List<FiqhFaqItem> _initialFaqList = const [
    FiqhFaqItem(
      id: 'faq-1',
      category: 'Haid & Istihadah',
      question: 'Beda darah haid dan istihadah',
      reference: 'Kitab Safinatun Najah & Al-Majmu\' Syarah Al-Muhadzdzab',
      answer:
          'Perbedaan mendasar antara darah haid dan istihadah menurut Mazhab Syafi\'i:\n\n'
          '1. Karakteristik Darah:\n'
          '• Darah haid umumnya berwarna merah tua/kehitaman, kental, dan keluar secara alami dari rahim wanita dalam kondisi sehat.\n'
          '• Darah istihadah adalah darah penyakit (fasad) akibat pembuluh darah pecah, umumnya berwarna merah segar dan lebih cair.\n\n'
          '2. Durasi Waktu:\n'
          '• Haid minimal 24 jam (akumulatif dalam 15 hari) dan maksimal 15 hari 15 malam.\n'
          '• Jika darah mengalir melebihi batas 15 hari 15 malam, kelebihannya dihukumi sebagai darah istihadah.\n\n'
          '3. Status Hukum Ibadah:\n'
          '• Wanita haid diharamkan salat, puasa, thawaf, dan menyentuh mushaf Al-Qur\'an.\n'
          '• Wanita mustahadhah (istihadah) dihukumi TETAP SUCI, wajib mendirikan salat dan berpuasa setelah membersihkan diri, memakai pembalut, dan berwudhu setiap kali masuk waktu salat fardhu.',
    ),
    FiqhFaqItem(
      id: 'faq-2',
      category: 'Hukum Flek (Kudrah/Shufrah)',
      question: 'Hukum flek sebelum haid',
      reference: 'Kitab Fathul Wahhab & Nihayatul Muhtaj',
      answer:
          'Hukum cairan keruh kecokelatan (kudrah) atau kekuningan (shufrah) sebelum haid dalam Mazhab Syafi\'i:\n\n'
          '1. Sebelum Darah Haid Keluar:\n'
          'Apabila flek keluar mendahului masa haid dan belum bersambung dengan darah haid utama (atau belum mencapai 24 jam), flek tersebut TIDAK DIHUKUMI SEBAGAI HAID. Status wanita masih suci sehingga tetap wajib salat dan puasa (cukup bersihkan najisnya dan berwudhu).\n\n'
          '2. Bersambung dengan Darah Haid:\n'
          'Jika flek tersebut langsung tersambung dengan keluarnya darah haid dalam rentang 15 hari, maka menurut Qaul Sahb (pendapat mu\'tamad), flek tersebut terhitung sebagai bagian dari masa haid.',
    ),
    FiqhFaqItem(
      id: 'faq-3',
      category: 'Batas Waktu Haid',
      question: 'Batas waktu maksimal masa haid',
      reference: 'Kitab Fathul Qorib & Al-Fiqh Al-Manhaji',
      answer:
          'Batasan durasi masa haid menurut Mazhab Syafi\'i:\n\n'
          '1. Batas Minimal: 1 hari 1 malam (24 jam akumulatif pendarahan).\n'
          '2. Batas Kebiasaan (Adat): Umumnya 6 hingga 7 hari.\n'
          '3. Batas Maksimal: 15 hari 15 malam (360 jam).\n\n'
          'Ketentuan Syariat:\n'
          'Apabila darah terus keluar melebihi batas 15 hari 15 malam, maka pada hari ke-15 wanita tersebut WAJIB mandi wajib (ghusl) dan mulai melaksanakan salat serta puasa. Darah yang keluar setelah hari ke-15 tersebut berstatus sebagai darah istihadah.',
    ),
    FiqhFaqItem(
      id: 'faq-4',
      category: 'Studi Kasus (Talfiq)',
      question: 'Hukum Darah Putus-Nyambung (Talfiq)',
      reference: 'Kitab Fathul Qorib & Tuhfatul Muhtaj (Qaul Sahb)',
      keywords: [
        'terputus',
        'berhenti',
        'nyambung',
        'suci sebentar',
        'jeda',
      ],
      answer:
          'Jika darah berhenti lalu keluar lagi, dan rentang waktu dari darah pertama hingga darah terakhir masih dalam batas 15 hari, maka seluruhnya (termasuk masa bersih di antaranya) dihukumi Haid.',
    ),
    FiqhFaqItem(
      id: 'faq-5',
      category: 'Studi Kasus (Tamyiz)',
      question: 'Keluar Darah > 15 Hari Beda Warna (Tamyiz)',
      reference: 'Kitab Fathul Qorib & Risalatul Mahid',
      keywords: [
        'lebih 15 hari',
        'terus menerus',
        'warna beda',
        'berbeda',
        'darah beda',
      ],
      answer:
          'Jika darah melebihi 15 hari dan memiliki warna/sifat berbeda, ini dihukumi Istihadah. Darah yang sifatnya kuat (hitam/kental) dihukumi masa Haid, dan darah yang lemah (merah/cair) dihukumi Istihadah (wajib shalat).',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Memfilter daftar FAQ secara real-time berdasarkan teks dan kata kunci tersembunyi (case-insensitive)
  List<FiqhFaqItem> get _filteredFaqList {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _initialFaqList;
    }
    return _initialFaqList.where((item) {
      final matchesQuestion = item.question.toLowerCase().contains(query);
      final matchesAnswer = item.answer.toLowerCase().contains(query);
      final matchesCategory = item.category.toLowerCase().contains(query);
      final matchesKeywords = item.keywords.any((kw) {
        final k = kw.toLowerCase();
        return k.contains(query) || query.contains(k);
      });
      final queryWords = query.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
      final matchesWordsInKeywords = queryWords.any(
        (w) => item.keywords.any((kw) => kw.toLowerCase().contains(w)),
      );
      return matchesQuestion ||
          matchesAnswer ||
          matchesCategory ||
          matchesKeywords ||
          matchesWordsInKeywords;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredFaqList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Fiqih'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Kolom Pencarian Real-Time dengan setState
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari pertanyaan fiqih (mis: haid, flek, maksimal)...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFB5838D)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),

            // 2. Banner Edukasi Ringkas
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Color(0xFFB5838D)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tanya jawab fiqh praktis darah wanita berdasar Mazhab Syafi\'i.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Header Info Hasil Pencarian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isEmpty
                        ? 'Daftar Tanya Jawab (${filteredList.length})'
                        : 'Hasil Pencarian (${filteredList.length})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'FAQ Interaktif',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.softMauve,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 4. Daftar FAQ dengan ListView.builder dan ExpansionTile
            Expanded(
              child: filteredList.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 54,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Pertanyaan tidak ditemukan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tidak ada FAQ yang cocok dengan kata kunci "$_searchQuery". Coba cari kata kunci lain seperti "haid", "istihadah", atau "flek".',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 18),
                              ElevatedButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB5838D),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Tampilkan Semua FAQ'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildNavigationGrid(context),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filteredList.length + 1,
                      itemBuilder: (context, index) {
                        // Posisi Paling Bawah: Grid Navigasi Panduan Terkait (2x2)
                        if (index == filteredList.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 20),
                            child: _buildNavigationGrid(context),
                          );
                        }

                        final faq = filteredList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
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
                              key: PageStorageKey(faq.id),
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB3CDE0),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFB3CDE0).withValues(alpha: 0.35),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.help_outline_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                faq.question,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  faq.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFB5838D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              iconColor: const Color(0xFFB5838D),
                              collapsedIconColor: AppColors.textMuted,
                              children: [
                                const Divider(color: AppColors.divider, height: 1),
                                const SizedBox(height: 12),
                                Text(
                                  faq.answer,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.bookmark_outline,
                                        size: 14,
                                        color: AppColors.softMauve,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          faq.reference,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.softMauve,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget Grid Navigasi untuk Panduan Fiqih Terkait
  Widget _buildNavigationGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                size: 16,
                color: Color(0xFFB5838D),
              ),
              SizedBox(width: 8),
              Text(
                'Panduan Fiqih Terkait',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB5838D),
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: [
            _buildGridMenuItem(
              context: context,
              title: 'Mandi Wajib',
              subtitle: 'Tata Cara & Niat',
              icon: Icons.shower_rounded,
              cardGradient: const [
                Color(0xFFFFF7F9),
                Colors.white,
              ],
              borderColor: const Color(0x35B5838D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MandiWajibScreen(),
                  ),
                );
              },
            ),
            _buildGridMenuItem(
              context: context,
              title: 'Larangan & Amalan',
              subtitle: 'Panduan Saat Haid',
              icon: Icons.menu_book_rounded,
              cardGradient: const [
                Color(0xFFFFF7FA),
                Colors.white,
              ],
              borderColor: const Color(0x35B5838D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LaranganAmalanScreen(),
                  ),
                );
              },
            ),
            _buildGridMenuItem(
              context: context,
              title: 'Panduan Nifas',
              subtitle: 'Pasca Melahirkan',
              icon: Icons.child_care_rounded,
              cardGradient: const [
                Color(0xFFFAF5FC),
                Colors.white,
              ],
              borderColor: const Color(0x35B5838D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NifasScreen(),
                  ),
                );
              },
            ),
            _buildGridMenuItem(
              context: context,
              title: 'Darah Istihadah',
              subtitle: 'Hukum & Bersuci',
              icon: Icons.healing_rounded,
              cardGradient: const [
                Color(0xFFFFF8FA),
                Colors.white,
              ],
              borderColor: const Color(0x35B5838D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IstihadahScreen(),
                  ),
                );
              },
            ),
            _buildGridMenuItem(
              context: context,
              title: 'Karakteristik Darah',
              subtitle: 'Warna & Sifat',
              icon: Icons.water_drop_rounded,
              cardGradient: const [
                Color(0xFFFFF6F8),
                Colors.white,
              ],
              borderColor: const Color(0x35B5838D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KarakteristikDarahScreen(),
                  ),
                );
              },
            ),
            _buildGridMenuItem(
              context: context,
              title: 'Tracker Qadha Puasa',
              subtitle: 'Hitung Hutang Puasa',
              icon: Icons.calculate_rounded,
              cardGradient: const [
                Color(0xFFFAF5FC),
                Colors.white,
              ],
              borderColor: const Color(0x35B5838D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QadhaPuasaScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Item Card untuk masing-masing kotak pada Grid Navigasi
  Widget _buildGridMenuItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> cardGradient,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: cardGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0AB5838D),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon dalam Container lingkaran biru pastel
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3CDE0), // Biru pastel sangat soft dan estetik
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB3CDE0).withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
