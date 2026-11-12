// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/cycle_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Variabel penampung riwayat siklus WAJIB diawali dengan list kosong []
  List<DateTime> riwayatHaid = [];
  List<DateTime> riwayatSuci = [];

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = DateTime(now.year, now.month, now.day);
    _loadRiwayatHaid();
    Future.microtask(() => ref.read(cycleProvider.notifier).loadCycles());
  }

  /// Fungsi Load: Di dalam initState(), ambil data dengan prefs.getStringList('riwayat_haid') dan 'riwayat_suci'.
  /// Tanggal dinormalisasi tanpa jam/menit menggunakan DateTime(p.year, p.month, p.day).
  Future<void> _loadRiwayatHaid() async {
    final prefs = await SharedPreferences.getInstance();
    final listTanggalString = prefs.getStringList('riwayat_haid');
    if (listTanggalString != null) {
      riwayatHaid = listTanggalString.map((e) {
        final p = DateTime.parse(e);
        return DateTime(p.year, p.month, p.day);
      }).toList();
    } else {
      riwayatHaid = [];
    }

    final listSuciString = prefs.getStringList('riwayat_suci');
    if (listSuciString != null) {
      riwayatSuci = listSuciString.map((e) {
        final p = DateTime.parse(e);
        return DateTime(p.year, p.month, p.day);
      }).toList();
    } else if (riwayatHaid.isNotEmpty) {
      final sortedHaid = List<DateTime>.from(riwayatHaid)..sort((a, b) => a.compareTo(b));
      final hariTerakhirHaid = sortedHaid.last;
      riwayatSuci = List.generate(
        15,
        (i) => DateTime(hariTerakhirHaid.year, hariTerakhirHaid.month, hariTerakhirHaid.day + 1 + i),
      );
    } else {
      riwayatSuci = [];
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// Menambah atau menghapus tanggal haid secara interaktif dengan normalisasi waktu
  Future<void> toggleHaidDate(DateTime date) async {
    final normalized = _normalizeDate(date);
    final exists = riwayatHaid.any((d) => _isSameDay(d, normalized));
    List<DateTime> updatedHaid;
    if (exists) {
      updatedHaid = riwayatHaid.where((d) => !_isSameDay(d, normalized)).toList();
    } else {
      updatedHaid = [...riwayatHaid, normalized]..sort((a, b) => a.compareTo(b));
    }

    final prefs = await SharedPreferences.getInstance();
    final listStrings = updatedHaid.map((d) => _normalizeDate(d).toIso8601String()).toList();
    await prefs.setStringList('riwayat_haid', listStrings);

    // Hitung ulang masa suci
    List<DateTime> updatedSuci = [];
    if (updatedHaid.isNotEmpty) {
      final lastHaid = updatedHaid.last;
      updatedSuci = List.generate(
        15,
        (i) => DateTime(lastHaid.year, lastHaid.month, lastHaid.day + 1 + i),
      );
      final suciStrings = updatedSuci.map((d) => _normalizeDate(d).toIso8601String()).toList();
      await prefs.setStringList('riwayat_suci', suciStrings);
    } else {
      await prefs.remove('riwayat_suci');
    }

    setState(() {
      riwayatHaid = updatedHaid;
      riwayatSuci = updatedSuci;
    });

    ref.read(cycleProvider.notifier).loadCycles();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(cycleProvider, (previous, next) => _loadRiwayatHaid());
    final cycleState = ref.watch(cycleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Siklus & Suci'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Reset Cache',
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) => prefs.clear());
              setState(() {
                riwayatHaid = [];
                riwayatSuci = [];
              });
              ref.read(cycleProvider.notifier).loadCycles();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache data riwayat haid berhasil direset.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Legend Penjelasan Warna
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem('Hari Haid', AppColors.dustyRose),
                    _buildLegendItem('Masa Suci', const Color(0xFFD8BFD8)),
                    _buildLegendItem('Hari Ini', const Color(0xFFFFD1DC)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Komponen TableCalendar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TableCalendar(
                  firstDay: DateTime(2024, 1, 1),
                  lastDay: DateTime(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = _normalizeDate(selectedDay);
                      _focusedDay = _normalizeDate(focusedDay);
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB5838D),
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFFFD1DC), // Pink pastel
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFFB5838D), // Dusty rose
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    final current = _normalizeDate(day);
                    final List<dynamic> events = [];
                    if (riwayatHaid.any((d) => _isSameDay(d, current))) {
                      events.add('Haid');
                    } else if (riwayatSuci.any((d) => _isSameDay(d, current))) {
                      events.add('Suci');
                    }
                    return events;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildCustomDayCell(day, cycleState);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return _buildCustomDayCell(day, cycleState);
                    },
                    markerBuilder: (context, date, events) => const SizedBox(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Detail Informasi Hari yang Dipilih
              _buildSelectedDayDetail(cycleState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget? _buildCustomDayCell(DateTime day, dynamic cycleState) {
    final current = _normalizeDate(day);

    final isHaid = riwayatHaid.any((d) => _isSameDay(d, current));
    final isSuci = !isHaid && riwayatSuci.any((d) => _isSameDay(d, current));

    if (isHaid) {
      // Hari Haid (Merah / Dusty Rose)
      return Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.dustyRose.withOpacity(0.2),
            border: Border.all(color: AppColors.dustyRose, width: 1.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: const TextStyle(color: AppColors.dustyRoseDark, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else if (isSuci) {
      // Masa Suci (Soft Lilac Pastel)
      return Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE6E6FA).withValues(alpha: 0.6),
            border: Border.all(color: const Color(0xFFD8BFD8), width: 1.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: const TextStyle(color: Color(0xFF8C5B66), fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    return null;
  }

  Widget _buildSelectedDayDetail(dynamic cycleState) {
    final selectedNormalized = _normalizeDate(_selectedDay);
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(selectedNormalized);

    final isSelectedHaid = riwayatHaid.any((d) => _isSameDay(d, selectedNormalized));
    final isSelectedSuci = !isSelectedHaid && riwayatSuci.any((d) => _isSameDay(d, selectedNormalized));

    String statusTitle = 'Informasi Tanggal';
    String statusDesc =
        'Kalender ini menampilkan sinkronisasi riwayat haid dan masa suci secara read-only berdasarkan pencatatan dari Beranda.';
    Color statusColor = AppColors.softMauve;

    if (isSelectedHaid) {
      statusTitle = 'Status: Hari Haid';
      statusDesc =
          'Tanggal ini tercatat dalam periode pendarahan haid berdasarkan input yang dicatat di Beranda.';
      statusColor = AppColors.dustyRoseDark;
    } else if (isSelectedSuci) {
      statusTitle = 'Status: Masa Suci (Sah Beribadah)';
      statusDesc =
          'Tanggal ini berada dalam masa suci. Kewajiban ibadah shalat dan puasa fardhu wajib ditunaikan.';
      statusColor = const Color(0xFFB5838D);
    } else if (riwayatHaid.isNotEmpty) {
      statusTitle = 'Di Luar Siklus Terhitung';
      statusDesc =
          'Tanggal ini berada di luar rentang siklus haid dan masa suci yang tersimpan saat ini.';
      statusColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Icon(Icons.info_outline, size: 18, color: statusColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            statusTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: statusColor),
          ),
          const SizedBox(height: 4),
          Text(
            statusDesc,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sinkronisasi Murni (Read-Only): Kalender hanya menampilkan data riwayat. Input awal haid dan tanggal suci dilakukan melalui Beranda.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
