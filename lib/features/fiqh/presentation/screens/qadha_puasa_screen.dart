import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';

/// Halaman Fitur Interaktif Tracker Qadha Puasa
/// Membantu muslimah mencatat hutang puasa Ramadhan (karena haid/nifas)
/// dan memantau perkembangan puasa yang telah ditunaikan.
class QadhaPuasaScreen extends StatefulWidget {
  const QadhaPuasaScreen({super.key});

  @override
  State<QadhaPuasaScreen> createState() => _QadhaPuasaScreenState();
}

class _QadhaPuasaScreenState extends State<QadhaPuasaScreen> {
  static const String _keyTotalHutang = 'qadha_total_hutang';
  static const String _keyTotalDibayar = 'qadha_total_dibayar';

  int _totalHutang = 0;
  int _totalDibayar = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Memuat data hutang dan pembayaran dari SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalHutang = prefs.getInt(_keyTotalHutang) ?? 0;
      _totalDibayar = prefs.getInt(_keyTotalDibayar) ?? 0;
      // Normalisasi jika dibayar melebihi hutang
      if (_totalDibayar > _totalHutang) {
        _totalDibayar = _totalHutang;
      }
      _isLoading = false;
    });
  }

  /// Menyimpan nilai terbaru ke SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalHutang, _totalHutang);
    await prefs.setInt(_keyTotalDibayar, _totalDibayar);
  }

  /// Menambah atau mengurangi total hutang puasa
  void _updateHutang(int delta) {
    setState(() {
      final updated = _totalHutang + delta;
      _totalHutang = updated < 0 ? 0 : updated;
      if (_totalDibayar > _totalHutang) {
        _totalDibayar = _totalHutang;
      }
    });
    _savePreferences();
  }

  /// Menambah atau mengurangi total puasa yang sudah dibayar
  void _updateDibayar(int delta) {
    setState(() {
      final updated = _totalDibayar + delta;
      if (updated < 0) {
        _totalDibayar = 0;
      } else if (updated > _totalHutang) {
        _totalDibayar = _totalHutang;
      } else {
        _totalDibayar = updated;
      }
    });
    _savePreferences();
  }

  /// Sisa hutang puasa yang harus ditunaikan
  int get _sisaHutang {
    final sisa = _totalHutang - _totalDibayar;
    return sisa < 0 ? 0 : sisa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker Qadha Puasa'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.sageGreen),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // 1. Banner Sisa Hutang Puasa (Besar & Mencolok)
                  _buildSisaHutangCard(),

                  const SizedBox(height: 20),

                  // 2. Bagian Pengaturan Catatan
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pengaturan Catatan Puasa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Card (a): Total Hutang Puasa
                  _buildCounterCard(
                    title: 'Total Hutang Puasa',
                    subtitle: 'Jumlah hari puasa yang ditinggalkan saat Ramadhan',
                    icon: Icons.calendar_today_rounded,
                    iconBgColor: AppColors.badgeHaidBg,
                    iconColor: AppColors.badgeHaidText,
                    value: _totalHutang,
                    onMinus: () => _updateHutang(-1),
                    onPlus: () => _updateHutang(1),
                    minusEnabled: _totalHutang > 0,
                    plusEnabled: true,
                  ),

                  const SizedBox(height: 14),

                  // Card (b): Puasa Yang Sudah Dibayar
                  _buildCounterCard(
                    title: 'Puasa Yang Sudah Dibayar',
                    subtitle: 'Jumlah hari qadha yang sudah berhasil ditunaikan',
                    icon: Icons.task_alt_rounded,
                    iconBgColor: AppColors.badgeSuciBg,
                    iconColor: AppColors.badgeSuciText,
                    value: _totalDibayar,
                    onMinus: () => _updateDibayar(-1),
                    onPlus: () => _updateDibayar(1),
                    minusEnabled: _totalDibayar > 0,
                    plusEnabled: _totalDibayar < _totalHutang,
                  ),

                  const SizedBox(height: 20),

                  // 3. Panduan Singkat Fiqih Qadha Puasa
                  _buildFiqhGuideCard(),

                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  /// Card Utama: Menampilkan Sisa Hutang Puasa secara besar & mencolok
  Widget _buildSisaHutangCard() {
    final isLunas = _totalHutang > 0 && _sisaHutang == 0;
    final isKosong = _totalHutang == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLunas
              ? const [
                  AppColors.badgeSuciBg,
                  Color(0xFFFFF5F8),
                ]
              : const [
                  AppColors.sageGreenLight,
                  Color(0xFFFFF5F8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLunas ? const Color(0x50B5838D) : const Color(0x35B5838D),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLunas
                  ? AppColors.badgeSuciText.withValues(alpha: 0.12)
                  : AppColors.sageGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLunas
                      ? Icons.check_circle_rounded
                      : Icons.hourglass_top_rounded,
                  size: 16,
                  color: isLunas
                      ? AppColors.badgeSuciText
                      : AppColors.sageGreenDark,
                ),
                const SizedBox(width: 6),
                Text(
                  'SISA HUTANG PUASA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isLunas
                        ? AppColors.badgeSuciText
                        : AppColors.sageGreenDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_sisaHutang',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                  color: isLunas
                      ? AppColors.badgeSuciText
                      : AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Hari',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isKosong
                ? 'Belum ada catatan hutang puasa. Gunakan tombol di bawah untuk mulai mencatat.'
                : isLunas
                    ? '🎉 Alhamdulillah! Seluruh kewajiban hutang puasa Anda telah lunas.'
                    : 'Segera tunaikan qadha sebelum datangnya bulan Ramadhan berikutnya.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isLunas ? FontWeight.w600 : FontWeight.normal,
              color: isLunas
                  ? AppColors.badgeSuciText
                  : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Card Pengaturan Counter (Plus / Minus)
  Widget _buildCounterCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required bool minusEnabled,
    required bool plusEnabled,
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Minus (-)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: minusEnabled ? onMinus : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: minusEnabled
                          ? AppColors.surfaceMuted
                          : const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: minusEnabled
                            ? AppColors.border
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Icon(
                      Icons.remove_rounded,
                      size: 24,
                      color: minusEnabled
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),

              // Tampilan Angka
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Hari',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Tombol Plus (+)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: plusEnabled ? onPlus : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: plusEnabled
                          ? AppColors.sageGreen
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: plusEnabled
                          ? [
                              BoxShadow(
                                color: AppColors.sageGreen.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card Panduan Fiqih Singkat & Niat Qadha Puasa
  Widget _buildFiqhGuideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 18,
                color: AppColors.softMauve,
              ),
              SizedBox(width: 8),
              Text(
                'Niat & Ketentuan Qadha Puasa',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'نَوَيْتُ صَوْمَ غَدٍ عَنْ قَضَاءِ فَرْضِ شَهْرِ رَمَضَانَ ِللهِ تَعَالَى',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Nawaitu shauma ghadin \'an qadha\'i fardhi syahri Ramadhaana lillaahi ta\'aalaa.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: AppColors.sageGreenDark,
              height: 1.4,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '(Niat: Saya berniat puasa esok hari untuk mengqadha fardhu bulan Ramadhan karena Allah Ta\'ala)',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 10),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: 10),
          Text(
            'Catatan Fiqih: Wanita haid wajib mengqadha puasa yang ditinggalkan sebelum tiba Ramadhan berikutnya. Niat qadha wajib dilakukan pada malam hari (Tabyit an-Niyyah).',
            style: TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
