// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../presentation/providers/cycle_provider.dart';

/// Home Screen (Tab Beranda / Tracker) untuk mySiklus
/// Dirancang elegan dengan palet warna Dusty Rose, Sage Green, dan Cream Background.
class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToCalendar;
  final VoidCallback? onNavigateToFiqh;

  const HomeScreen({
    super.key,
    this.onNavigateToCalendar,
    this.onNavigateToFiqh,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String userName = "pengguna";
  List<DateTime> riwayatHaid = [];
  List<DateTime> riwayatSuci = [];
  DateTime? ongoingHaidStart;

  @override
  void initState() {
    super.initState();
    loadUserName();
    _loadRiwayatHaid();
    Future.microtask(() => ref.read(cycleProvider.notifier).loadCycles());
  }

  /// Fungsi Load: Di dalam initState(), ambil data dengan prefs.getStringList('riwayat_haid').
  /// Tanggal dinormalisasi tanpa jam/menit menggunakan DateTime(d.year, d.month, d.day).
  Future<void> _loadRiwayatHaid() async {
    final prefs = await SharedPreferences.getInstance();

    final ongoingStr = prefs.getString('ongoing_haid_start');
    if (ongoingStr != null) {
      final parsedOngoing = DateTime.tryParse(ongoingStr);
      ongoingHaidStart = parsedOngoing != null
          ? DateTime(parsedOngoing.year, parsedOngoing.month, parsedOngoing.day)
          : null;
    } else {
      ongoingHaidStart = null;
    }

    final listTanggalString = prefs.getStringList('riwayat_haid');
    if (listTanggalString != null) {
      riwayatHaid = listTanggalString.map((e) {
        final d = DateTime.parse(e);
        return DateTime(d.year, d.month, d.day);
      }).toList();
    } else {
      riwayatHaid = [];
    }

    // Jika sedang dalam periode haid aktif, pastikan hari-hari dari ongoingHaidStart s.d. hari ini masuk ke riwayat
    if (ongoingHaidStart != null) {
      final start = DateTime(ongoingHaidStart!.year, ongoingHaidStart!.month, ongoingHaidStart!.day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final setHaid = riwayatHaid.map((d) => DateTime(d.year, d.month, d.day)).toSet();
      DateTime cur = start;
      final endRange = today.isBefore(start) ? start : today;
      while (!cur.isAfter(endRange)) {
        setHaid.add(cur);
        cur = DateTime(cur.year, cur.month, cur.day + 1);
      }
      riwayatHaid = setHaid.toList()..sort((a, b) => a.compareTo(b));
    }

    final listSuciString = prefs.getStringList('riwayat_suci');
    if (listSuciString != null) {
      riwayatSuci = listSuciString.map((e) {
        final d = DateTime.parse(e);
        return DateTime(d.year, d.month, d.day);
      }).toList();
    } else if (riwayatHaid.isNotEmpty && ongoingHaidStart == null) {
      final sorted = List<DateTime>.from(riwayatHaid)..sort((a, b) => a.compareTo(b));
      final lastHaid = sorted.last;
      riwayatSuci = List.generate(
        15,
        (i) => DateTime(lastHaid.year, lastHaid.month, lastHaid.day + 1 + i),
      );
    } else {
      riwayatSuci = [];
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// Memulai siklus haid baru dari selectedDate yang diinput user dengan normalisasi DateTime
  Future<void> mulaiHaid(DateTime selectedDate) async {
    final startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final prefs = await SharedPreferences.getInstance();

    // 1. Simpan tanda haid sedang aktif mulai startDate
    await prefs.setString('ongoing_haid_start', startDate.toIso8601String());
    ongoingHaidStart = startDate;

    // 2. Kumpulkan rentang tanggal dari startDate s.d. hari ini (atau startDate jika hari ini sebelum startDate)
    final Set<DateTime> setHaid = riwayatHaid.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    DateTime cur = startDate;
    final endRange = today.isBefore(startDate) ? startDate : today;
    while (!cur.isAfter(endRange)) {
      setHaid.add(cur);
      cur = DateTime(cur.year, cur.month, cur.day + 1);
    }
    final updatedHaid = setHaid.toList()..sort((a, b) => a.compareTo(b));

    // 3. Simpan riwayat haid
    final listTanggalString = updatedHaid.map((e) => DateTime(e.year, e.month, e.day).toIso8601String()).toList();
    await prefs.setStringList('riwayat_haid', listTanggalString);

    // 4. Reset riwayat suci karena pendarahan baru dimulai
    await prefs.remove('riwayat_suci');

    setState(() {
      riwayatHaid = updatedHaid;
      riwayatSuci = [];
    });

    // 5. Beri tahu cycleProvider
    ref.read(cycleProvider.notifier).startHaid(date: startDate);
  }

  /// Menutup siklus haid dan mengaktifkan masa suci berdasarkan tanggal yang dipilih pengguna (hari terakhir haid).
  /// Menghitung seluruh rentang hari haid (startDate s.d. lastHaidDate) secara inklusif (+1) sehingga tanggal akhir tepat sesuai yang ditekan pengguna (tidak minus 1 hari).
  Future<void> catatSelesaiSuci(DateTime selectedDate) async {
    // Normalisasi tanggal yang dipilih user sebagai hari terakhir haid (inklusif, tepat sesuai pilihan)
    final lastHaidDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final prefs = await SharedPreferences.getInstance();

    // 1. Dapatkan tanggal mulai haid yang dinormalisasi
    DateTime startHaid = ongoingHaidStart != null
        ? DateTime(ongoingHaidStart!.year, ongoingHaidStart!.month, ongoingHaidStart!.day)
        : (riwayatHaid.isNotEmpty
            ? DateTime(riwayatHaid.first.year, riwayatHaid.first.month, riwayatHaid.first.day)
            : lastHaidDate);

    if (startHaid.isAfter(lastHaidDate)) {
      startHaid = lastHaidDate;
    }

    // 2. Bangun rentang tanggal haid lengkap dari startHaid s.d. lastHaidDate (inklusif tanggal yang ditekan pengguna)
    final List<DateTime> listHariHaid = [];
    DateTime cur = startHaid;
    while (!cur.isAfter(lastHaidDate)) {
      listHariHaid.add(cur);
      cur = DateTime(cur.year, cur.month, cur.day + 1);
    }

    // 3. Pertahankan riwayat haid lama yang sebelum startHaid
    final existingOldHaid = riwayatHaid
        .where((d) => DateTime(d.year, d.month, d.day).isBefore(startHaid))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toList();
    final updatedHaid = [...existingOldHaid, ...listHariHaid];

    // 4. Generate list masa suci (15 hari minimal) mulai 1 hari setelah hari terakhir haid
    final startSuciDate = DateTime(lastHaidDate.year, lastHaidDate.month, lastHaidDate.day + 1);
    final listMasaSuci = List.generate(
      15,
      (i) => DateTime(startSuciDate.year, startSuciDate.month, startSuciDate.day + i),
    );

    // 5. Simpan permanen ke SharedPreferences
    await prefs.remove('ongoing_haid_start');
    ongoingHaidStart = null;

    final listHaidString = updatedHaid.map((e) => DateTime(e.year, e.month, e.day).toIso8601String()).toList();
    final listSuciString = listMasaSuci.map((e) => DateTime(e.year, e.month, e.day).toIso8601String()).toList();

    await prefs.setStringList('riwayat_haid', listHaidString);
    await prefs.setStringList('riwayat_suci', listSuciString);

    setState(() {
      riwayatHaid = updatedHaid;
      riwayatSuci = listMasaSuci;
    });

    // 6. Simpan siklus ke cycleProvider (durasi inklusif: + 1)
    final durationHaid = lastHaidDate.difference(startHaid).inDays + 1;
    await ref.read(cycleProvider.notifier).saveCycle(
      startDate: startHaid,
      endDate: lastHaidDate,
      durationHaid: durationHaid,
    );
  }

  /// Fungsi Save: Saat user menginput data haid, konversi List<DateTime> menjadi List<String>
  /// menggunakan .map((e) => e.toIso8601String()).toList(). Simpan ke lokal dengan prefs.setStringList('riwayat_haid', listTanggalString).
  Future<void> simpanRiwayatHaid(List<DateTime> dataHaid) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = dataHaid.map((d) => DateTime(d.year, d.month, d.day)).toList();
    final listTanggalString = normalized.map((e) => e.toIso8601String()).toList();
    await prefs.setStringList('riwayat_haid', listTanggalString);
    setState(() {
      riwayatHaid = normalized;
    });
  }

  /// Menghitung hari masa suci berdasarkan riwayat haid
  int _hitungHariMasaSuci() {
    if (riwayatHaid.isNotEmpty) {
      final sorted = List<DateTime>.from(riwayatHaid)..sort((a, b) => b.compareTo(a));
      final latestDate = DateTime(sorted.first.year, sorted.first.month, sorted.first.day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final diff = today.difference(latestDate).inDays;
      return diff >= 0 ? diff : 0;
    }
    return 0;
  }

  /// Menghitung durasi hari haid jika hari ini sedang haid (inklusif: hari pertama dihitung 1 hari)
  int _hitungHariHaid() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (ongoingHaidStart != null) {
      final start = DateTime(ongoingHaidStart!.year, ongoingHaidStart!.month, ongoingHaidStart!.day);
      final diff = today.difference(start).inDays;
      return diff >= 0 ? diff + 1 : 1;
    }
    final setTanggal = riwayatHaid.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    int count = 0;
    DateTime checkDate = today;
    while (setTanggal.contains(checkDate)) {
      count++;
      checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day - 1);
    }
    return count > 0 ? count : 1;
  }

  /// Membaca data nama pengguna dari SharedPreferences saat aplikasi baru dibuka.
  /// Jika belum ada data, gunakan nilai default 'pengguna'.
  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name') ?? prefs.getString('nama_pengguna');
    if (savedName != null && savedName.trim().isNotEmpty) {
      setState(() {
        userName = savedName.trim();
      });
    } else {
      setState(() {
        userName = "pengguna";
      });
    }
  }

  /// Menyimpan nama ke SharedPreferences dan memanggil setState
  Future<void> saveUserName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    await prefs.setString('nama_pengguna', newName);
    setState(() {
      userName = newName;
    });
  }

  /// Kotak dialog untuk mengedit nama pengguna
  void _showEditNamaDialog() {
    final nameController = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Ubah Nama',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Masukkan nama pengguna',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFB5838D), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB5838D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await saveUserName(newName);
                }
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Simpan',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Dialog konfirmasi pencatatan status haid / suci
  void _showStatusActionDialog({
    required bool isCurrentlyHaid,
  }) {
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            final formattedDate =
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(selectedDate);

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header Dialog
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCurrentlyHaid
                              ? AppColors.sageGreenLight
                              : AppColors.dustyRoseLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCurrentlyHaid
                              ? Icons.cleaning_services_rounded
                              : Icons.water_drop_rounded,
                          color: isCurrentlyHaid
                              ? AppColors.sageGreenDark
                              : AppColors.dustyRoseDark,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCurrentlyHaid
                                  ? 'Tanggal Mulai Suci'
                                  : 'Catat Hari Pertama Haid',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isCurrentlyHaid
                                  ? 'Tandai darah telah tuntas berhenti dan mulai masa suci'
                                  : 'Mulai pencatatan siklus pendarahan baru',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Pemilih Tanggal
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 18, color: AppColors.softMauve),
                            const SizedBox(width: 10),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: sheetContext,
                              initialDate: selectedDate,
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 60)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: isCurrentlyHaid
                                          ? AppColors.sageGreen
                                          : AppColors.dustyRose,
                                      onPrimary: Colors.white,
                                      surface: AppColors.surface,
                                      onSurface: AppColors.textPrimary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setModalState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Ubah',
                            style: TextStyle(
                              color: isCurrentlyHaid
                                  ? AppColors.sageGreenDark
                                  : AppColors.dustyRoseDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Catatan Fiqh Singkat
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCurrentlyHaid
                          ? AppColors.badgeSuciBg
                          : AppColors.badgeHaidBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: isCurrentlyHaid
                              ? AppColors.badgeSuciText
                              : AppColors.badgeHaidText,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isCurrentlyHaid
                                ? 'Setelah darah berhenti sempurna (warna putih/kering), wajib mandi besar (ghusl) sebelum melanjutkan ibadah shalat dan puasa.'
                                : 'Selama masa haid, muslimah dilarang shalat, puasa fardhu, tawaf, dan membaca mushaf Al-Qur\'an secara langsung menurut jumhur ulama.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: isCurrentlyHaid
                                  ? AppColors.badgeSuciText
                                  : AppColors.badgeHaidText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Konfirmasi
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(bottomSheetContext);
                      if (isCurrentlyHaid) {
                        await catatSelesaiSuci(selectedDate);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.sageGreenDark,
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Alhamdulillah, status masa suci berhasil dicatat.'),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      } else {
                        await mulaiHaid(selectedDate);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.dustyRoseDark,
                              content: const Row(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Catatan awal haid berhasil disimpan. Opsi Catat Suci kini aktif.'),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sageGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                      shadowColor: (isCurrentlyHaid
                              ? AppColors.sageGreen
                              : AppColors.dustyRose)
                          .withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      isCurrentlyHaid
                          ? 'Konfirmasi Selesai & Masuk Masa Suci'
                          : 'Konfirmasi Mulai Haid',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycleState = ref.watch(cycleProvider);

    // Status haid di Beranda aktif jika haid sedang berjalan (ongoingHaidStart / cycleState.isOngoingHaid)
    // atau jika tanggal hari ini eksplisit ada di dalam list riwayat_haid.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sortedRiwayat = List<DateTime>.from(riwayatHaid)..sort((a, b) => b.compareTo(a));
    final bool isHaid = ongoingHaidStart != null ||
        cycleState.isOngoingHaid ||
        (riwayatHaid.any((d) => DateTime(d.year, d.month, d.day) == today) &&
            !riwayatSuci.any((d) => DateTime(d.year, d.month, d.day) == today));

    // Jika tidak sedang haid, tampilkan status 'Masa Suci' beserta jumlah harinya.
    final purityDays = isHaid
        ? 0
        : (riwayatHaid.isNotEmpty
            ? _hitungHariMasaSuci()
            : cycleState.purityDaysRunning);
    final haidDays = isHaid
        ? (cycleState.currentHaidDuration > 0
            ? cycleState.currentHaidDuration
            : _hitungHariHaid())
        : 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==========================================
              // 1. HEADER SECTION (Sapaan & Tanggal)
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: _showEditNamaDialog,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Halo $userName',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.edit,
                            size: 16,
                            color: Color(0xFFB5838D),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 15,
                          color: AppColors.softMauve,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('d MMM yyyy', 'id_ID')
                              .format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==========================================
              // 2. KARTU INDIKATOR UTAMA (Counter Suci/Haid)
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHaid
                        ? [
                            const Color(0xFFFFF0F0),
                            const Color(0xFFFBEAEA),
                          ]
                        : [
                            const Color(0xFFFFF0E6), // Soft peach
                            const Color(0xFFF8EAED), // Pastel pink lembut
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isHaid
                        ? AppColors.dustyRose.withOpacity(0.35)
                        : AppColors.sageGreen.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isHaid ? AppColors.dustyRose : AppColors.sageGreen)
                          .withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
                child: Column(
                  children: [
                    // Badge Status Aktif
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: isHaid
                            ? AppColors.dustyRose
                            : AppColors.sageGreen,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: (isHaid
                                    ? AppColors.dustyRose
                                    : AppColors.sageGreen)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isHaid
                                ? Icons.water_drop_rounded
                                : Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isHaid
                                ? 'Status: Sedang Haid'
                                : 'Status: Masa Suci Aktif',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Visual Ring / Indikator Lingkaran Counter
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.85),
                        border: Border.all(
                          color: (isHaid
                                  ? AppColors.dustyRose
                                  : AppColors.sageGreen)
                              .withOpacity(0.25),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isHaid
                                    ? AppColors.dustyRose
                                    : AppColors.sageGreen)
                                .withOpacity(0.1),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isHaid ? '$haidDays' : '$purityDays',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: isHaid
                                  ? AppColors.dustyRoseDark
                                  : const Color(0xFFB5838D),
                              height: 1.0,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isHaid ? 'Hari Haid' : 'Hari Suci',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Keterangan Kewajiban Ibadah Real-Time
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isHaid
                                ? Icons.bedtime_rounded
                                : Icons.wb_sunny_rounded,
                            size: 16,
                            color: isHaid
                                ? AppColors.dustyRoseDark
                                : const Color(0xFFB5838D),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isHaid
                                ? 'Kewajiban Shalat & Puasa: Tidak Boleh'
                                : 'Kewajiban Shalat & Puasa: Wajib Ditunaikan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isHaid
                                  ? AppColors.dustyRoseDark
                                  : const Color(0xFFB5838D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Ambang Batas Fiqh Mazhab Syafi'i (15 Hari)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isHaid
                                    ? 'Maksimal Haid (15 Hari)'
                                    : 'Ambang Minimal Suci (15 Hari)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                isHaid
                                    ? '$haidDays / 15 Hari'
                                    : (purityDays >= 15
                                        ? 'Terpenuhi (Sah)'
                                        : '$purityDays / 15 Hari'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isHaid
                                      ? (haidDays > 15
                                          ? AppColors.dustyRoseDark
                                          : AppColors.textPrimary)
                                      : (purityDays >= 15
                                          ? AppColors.sageGreenDark
                                          : AppColors.softMauve),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: isHaid
                                  ? (haidDays / 15).clamp(0.0, 1.0)
                                  : (purityDays / 15).clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: AppColors.surfaceMuted,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isHaid
                                    ? (haidDays > 15
                                        ? AppColors.badgeHaidText
                                        : AppColors.dustyRose)
                                    : (purityDays >= 15
                                        ? AppColors.sageGreen
                                        : AppColors.softMauve),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isHaid
                                ? (haidDays > 15
                                    ? 'Darah setelah hari ke-15 terhitung Istihadah (wajib bersuci & shalat).'
                                    : 'Menurut Mazhab Syafi\'i, batas waktu maksimal haid adalah 15 hari 15 malam.')
                                : (purityDays >= 15
                                    ? 'Masa suci minimal 15 hari terpenuhi. Pendarahan berikutnya sah dihukumi Haid.'
                                    : 'Perlu minimal 15 hari suci berturut-turut agar darah berikutnya sah menjadi Haid baru.'),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // 3. TOMBOL UTAMA BESAR (Catat Haid / Catat Suci)
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  color: isHaid ? const Color(0xFF8C5B66) : AppColors.sageGreen,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: (isHaid
                              ? AppColors.sageGreenDark
                              : AppColors.dustyRoseDark)
                          .withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _showStatusActionDialog(
                      isCurrentlyHaid: isHaid,
                    ),
                    child: Ink(
                      height: 60,
                      decoration: BoxDecoration(
                        color: isHaid ? const Color(0xFF8C5B66) : AppColors.sageGreen,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isHaid
                                ? Icons.cleaning_services_rounded
                                : Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isHaid
                                ? 'Catat Darah Berhenti (Masa Suci)'
                                : 'Catat Hari Pertama Haid',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // 4. KARTU PANDUAN FIQH RINGKAS
              // ==========================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                              Icons.menu_book_rounded,
                              size: 20,
                              color: AppColors.softMauve,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Pedoman Mazhab Syafi\'i',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        if (widget.onNavigateToFiqh != null)
                          GestureDetector(
                            onTap: widget.onNavigateToFiqh,
                            child: const Text(
                              'Pelajari →',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.sageGreenDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFiqhRuleItem(
                      title: 'Minimal Haid',
                      desc: '24 jam (sehari semalam kumulatif)',
                      icon: Icons.timelapse_rounded,
                      accentColor: AppColors.dustyRose,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: AppColors.divider, height: 1),
                    ),
                    _buildFiqhRuleItem(
                      title: 'Maksimal Haid',
                      desc: '15 hari 15 malam (selebihnya Istihadah)',
                      icon: Icons.hourglass_top_rounded,
                      accentColor: AppColors.softMauve,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: AppColors.divider, height: 1),
                    ),
                    _buildFiqhRuleItem(
                      title: 'Minimal Suci',
                      desc: '15 hari 15 malam antar dua haid',
                      icon: Icons.verified_rounded,
                      accentColor: AppColors.sageGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 5. RIWAYAT TERAKHIR SIKLUS
              // ==========================================
              if (cycleState.history.isNotEmpty || riwayatHaid.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Riwayat Siklus Terakhir',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.onNavigateToCalendar != null)
                            GestureDetector(
                              onTap: widget.onNavigateToCalendar,
                              child: const Text(
                                'Kalender →',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.sageGreenDark,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Builder(
                        builder: (context) {
                          if (cycleState.history.isNotEmpty) {
                            final latest = cycleState.history.first;
                            final startFormatted =
                                DateFormat('d MMM yyyy', 'id_ID')
                                    .format(latest.startDate);
                            final endFormatted = latest.endDate != null
                                ? DateFormat('d MMM yyyy', 'id_ID')
                                    .format(latest.endDate!)
                                : 'Masih Berlangsung';

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
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
                                    child: Icon(
                                      latest.isOngoingHaid
                                          ? Icons.water_drop_rounded
                                          : Icons.calendar_today_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          latest.isOngoingHaid
                                              ? 'Haid Sedang Berjalan'
                                              : 'Durasi Haid: ${latest.calculateDurationHaid()} Hari',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '$startFormatted - $endFormatted',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final latestDate = sortedRiwayat.first;
                            final startFormatted =
                                DateFormat('d MMM yyyy', 'id_ID')
                                    .format(latestDate);

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
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
                                    child: Icon(
                                      isHaid
                                          ? Icons.water_drop_rounded
                                          : Icons.calendar_today_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isHaid
                                              ? 'Haid Sedang Berjalan'
                                              : 'Masa Suci Hari ke-$purityDays',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'Haid Terakhir: $startFormatted',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiqhRuleItem({
    required String title,
    required String desc,
    required IconData icon,
    Color? accentColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
          child: Icon(icon, size: 18, color: Colors.white),
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
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
