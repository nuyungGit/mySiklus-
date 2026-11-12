import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mysiklus/features/cycle/screens/home_screen.dart';
import 'package:mysiklus/features/cycle/presentation/screens/calendar_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('Riwayat Haid Local Storage & Conversion Tests', () {
    test('Simpan dan muat riwayat haid menggunakan List<String> ISO8601', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Data haid 23 hari yang lalu
      final now = DateTime.now();
      final tanggalHaid = [
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 23)),
      ];

      // 1. Fungsi Save
      final listTanggalString = tanggalHaid.map((e) => e.toIso8601String()).toList();
      await prefs.setStringList('riwayat_haid', listTanggalString);

      // Verifikasi di SharedPreferences
      final savedStrings = prefs.getStringList('riwayat_haid');
      expect(savedStrings, isNotNull);
      expect(savedStrings!.length, 1);
      expect(savedStrings.first, tanggalHaid.first.toIso8601String());

      // 2. Fungsi Load
      List<DateTime> loadedDates = [];
      final loadedStringList = prefs.getStringList('riwayat_haid');
      if (loadedStringList != null) {
        loadedDates = loadedStringList.map((e) => DateTime.parse(e)).toList();
      }

      // Verifikasi hasil konversi DateTime
      expect(loadedDates.length, 1);
      expect(loadedDates.first.year, tanggalHaid.first.year);
      expect(loadedDates.first.month, tanggalHaid.first.month);
      expect(loadedDates.first.day, tanggalHaid.first.day);

      // 3. Perhitungan 23 Hari
      final diff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(loadedDates.first.year, loadedDates.first.month, loadedDates.first.day))
          .inDays;
      expect(diff, 23);
    });

    testWidgets('HomeScreen memuat riwayat_haid 23 hari lalu dan menampilkan Masa Suci 23 hari (karena hari ini bukan haid)', (tester) async {
      final now = DateTime.now();
      final haid23HariLalu = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 23));

      // Simpan data ke SharedPreferences sebelum widget dibuka
      SharedPreferences.setMockInitialValues({
        'riwayat_haid': [haid23HariLalu.toIso8601String()],
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Memastikan status Masa Suci dan counter 23 hari muncul di Beranda
      expect(find.text('23'), findsOneWidget);
      expect(find.text('Hari Suci'), findsOneWidget);
      expect(find.text('Status: Masa Suci Aktif'), findsOneWidget);
      expect(find.text('Kewajiban Shalat & Puasa: Wajib Ditunaikan'), findsOneWidget);
    });

    testWidgets('HomeScreen HANYA menampilkan status haid jika hari ini ada di riwayat_haid', (tester) async {
      final today = DateUtils.dateOnly(DateTime.now());

      // Simpan data haid yang mencakup hari ini
      SharedPreferences.setMockInitialValues({
        'riwayat_haid': [today.toIso8601String()],
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Memastikan status Sedang Haid muncul
      expect(find.text('Status: Sedang Haid'), findsOneWidget);
      expect(find.text('Hari Haid'), findsOneWidget);
      expect(find.text('Kewajiban Shalat & Puasa: Tidak Boleh'), findsOneWidget);
    });

    testWidgets('CalendarScreen mematikan event markers bawaan secara paksa dengan const SizedBox()', (tester) async {
      final now = DateTime.now();
      final haidDate = DateTime(now.year, now.month, now.day);

      SharedPreferences.setMockInitialValues({
        'riwayat_haid': [haidDate.toIso8601String()],
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final tableCalendarFinder = find.byType(TableCalendar);
      expect(tableCalendarFinder, findsOneWidget);

      final tableCalendar = tester.widget<TableCalendar>(tableCalendarFinder);
      expect(tableCalendar.calendarBuilders.markerBuilder, isNotNull);

      // Verifikasi markerBuilder menghasilkan SizedBox kosong
      final markerResult = tableCalendar.calendarBuilders.markerBuilder!(
        tester.element(tableCalendarFinder),
        now,
        ['Haid'],
      );
      expect(markerResult, isA<SizedBox>());
    });

    testWidgets('HomeScreen: input Hari Pertama Haid memunculkan opsi Tanggal Mulai Suci dan menyimpan rentang penuh (bukan 5-5)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Awalnya belum haid, tombol bertuliskan 'Catat Hari Pertama Haid'
      expect(find.text('Catat Hari Pertama Haid'), findsOneWidget);

      // 2. Klik 'Catat Hari Pertama Haid'
      await tester.tap(find.text('Catat Hari Pertama Haid'));
      await tester.pumpAndSettle();

      // Form dialog muncul
      expect(find.text('Konfirmasi Mulai Haid'), findsOneWidget);
      await tester.tap(find.text('Konfirmasi Mulai Haid'));
      await tester.pumpAndSettle();

      // 3. Status berubah menjadi 'Status: Sedang Haid' dan tombol utama berubah menjadi 'Catat Darah Berhenti (Masa Suci)'
      expect(find.text('Status: Sedang Haid'), findsOneWidget);
      expect(find.text('Catat Darah Berhenti (Masa Suci)'), findsOneWidget);

      // 4. Klik tombol 'Catat Darah Berhenti (Masa Suci)'
      await tester.tap(find.text('Catat Darah Berhenti (Masa Suci)'));
      await tester.pumpAndSettle();

      // Form 'Tanggal Mulai Suci' muncul kembali
      expect(find.text('Tanggal Mulai Suci'), findsOneWidget);
      expect(find.text('Konfirmasi Selesai & Masuk Masa Suci'), findsOneWidget);

      await tester.tap(find.text('Konfirmasi Selesai & Masuk Masa Suci'));
      await tester.pumpAndSettle();

      // 5. Cek SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storedHaid = prefs.getStringList('riwayat_haid');
      final storedSuci = prefs.getStringList('riwayat_suci');

      expect(storedHaid, isNotNull);
      expect(storedSuci, isNotNull);
      expect(storedSuci!.length, 15);

      // Tombol kembali ke 'Catat Hari Pertama Haid'
      expect(find.text('Catat Hari Pertama Haid'), findsOneWidget);
    });

    testWidgets('CalendarScreen murni read-only: hanya membaca riwayat dan tidak memanipulasi data saat tanggal dipilih', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final haidDate = DateTime(2026, 10, 5);
      SharedPreferences.setMockInitialValues({
        'riwayat_haid': [haidDate.toIso8601String()],
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verifikasi banner read-only muncul
      expect(find.textContaining('Sinkronisasi Murni (Read-Only)'), findsOneWidget);
      expect(find.text('Tandai Tanggal Ini Sebagai Haid'), findsNothing);

      // Memilih tanggal di kalender tidak menambah data riwayat_haid secara sepihak
      final dayFinder = find.text('15');
      if (dayFinder.evaluate().isNotEmpty) {
        await tester.tap(dayFinder.first);
        await tester.pumpAndSettle();
      }

      final prefs = await SharedPreferences.getInstance();
      final storedHaid = prefs.getStringList('riwayat_haid');
      expect(storedHaid!.length, 1);
      expect(storedHaid.first, haidDate.toIso8601String());
    });

    testWidgets('Tombol Reset Cache di AppBar mengosongkan list dan cache SharedPreferences', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final today = DateUtils.dateOnly(DateTime.now());
      SharedPreferences.setMockInitialValues({
        'riwayat_haid': [today.toIso8601String()],
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Temukan IconButton delete di AppBar
      final deleteBtnFinder = find.widgetWithIcon(IconButton, Icons.delete);
      expect(deleteBtnFinder, findsOneWidget);

      await tester.tap(deleteBtnFinder);
      await tester.pumpAndSettle();

      // Pastikan cache SharedPreferences kosong
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('riwayat_haid'), isNull);
    });
  });
}
