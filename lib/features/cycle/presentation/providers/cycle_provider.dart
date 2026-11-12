import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/cycle_model.dart';
import '../../../../core/services/supabase_service.dart';

class CycleState {
  final List<CycleModel> history;
  final CycleModel? activeCycle;
  final bool isLoading;
  final String? errorMessage;

  const CycleState({
    this.history = const [],
    this.activeCycle,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Status apakah saat ini sedang dalam masa haid aktif
  bool get isOngoingHaid => activeCycle != null && activeCycle!.endDate == null;

  /// Jumlah hari masa suci yang sedang berjalan
  int get purityDaysRunning {
    final targetCycle = activeCycle ?? (history.isNotEmpty ? history.first : null);
    if (targetCycle == null || targetCycle.endDate == null) return 0;
    return targetCycle.purityDaysRunning;
  }

  /// Durasi hari haid saat ini atau terakhir
  int get currentHaidDuration {
    final targetCycle = activeCycle ?? (history.isNotEmpty ? history.first : null);
    if (targetCycle == null) return 0;
    return targetCycle.calculateDurationHaid();
  }

  CycleState copyWith({
    List<CycleModel>? history,
    CycleModel? activeCycle,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CycleState(
      history: history ?? this.history,
      activeCycle: activeCycle ?? this.activeCycle,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CycleNotifier extends StateNotifier<CycleState> {
  static const String _storageKey = 'riwayat_siklus_haid';

  CycleNotifier() : super(const CycleState()) {
    loadCycles();
  }

  /// Menyimpan riwayat siklus ke SharedPreferences lokal secara permanen
  Future<void> _saveToLocal(List<CycleModel> cycles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = cycles.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);

      // Sinkronkan daftar tanggal haid sebagai List<String> ISO8601 dengan key 'riwayat_haid'
      final Set<DateTime> allHaidDates = {};
      for (final c in cycles) {
        final start = DateTime(c.startDate.year, c.startDate.month, c.startDate.day);
        final end = c.endDate != null
            ? DateTime(c.endDate!.year, c.endDate!.month, c.endDate!.day)
            : DateTime.now();
        final effectiveEnd = DateTime(end.year, end.month, end.day);
        final safeEnd = effectiveEnd.isBefore(start) ? start : effectiveEnd;
        DateTime cur = start;
        while (!cur.isAfter(safeEnd)) {
          allHaidDates.add(cur);
          cur = DateTime(cur.year, cur.month, cur.day + 1);
        }
      }
      if (allHaidDates.isNotEmpty) {
        final sorted = allHaidDates.toList()..sort((a, b) => a.compareTo(b));
        final listTanggalString = sorted.map((e) => DateTime(e.year, e.month, e.day).toIso8601String()).toList();
        await prefs.setStringList('riwayat_haid', listTanggalString);
      }
    } catch (e) {
      // Abaikan jika ada error disk
    }
  }

  /// Memuat riwayat siklus pendarahan nyata dari SharedPreferences lokal & Supabase
  Future<void> loadCycles() async {
    try {
      state = state.copyWith(isLoading: true);

      // 1. Muat riwayat siklus dari SharedPreferences terlebih dahulu
      final prefs = await SharedPreferences.getInstance();
      final localData = prefs.getString(_storageKey);
      List<CycleModel> loadedCycles = [];

      if (localData != null && localData.trim().isNotEmpty) {
        final decoded = jsonDecode(localData) as List<dynamic>;
        loadedCycles = decoded
            .map((json) => CycleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Fallback jika hanya ada data riwayat_haid berupa List<String>
        final listTanggalString = prefs.getStringList('riwayat_haid');
        if (listTanggalString != null && listTanggalString.isNotEmpty) {
          final listTanggal = listTanggalString.map((e) {
            final p = DateTime.parse(e);
            return DateTime(p.year, p.month, p.day);
          }).toList();
          loadedCycles = listTanggal.map((date) => CycleModel(
            id: 'local-${date.millisecondsSinceEpoch}',
            userId: 'local-user',
            startDate: date,
            endDate: date,
            durationHaid: 1,
            createdAt: date,
          )).toList();
        }
      }

      // 2. Sinkronkan dengan Supabase jika pengguna sedang login
      final user = SupabaseService.instance.currentUser;
      if (user != null) {
        try {
          final response = await SupabaseService.instance.client
              .from(SupabaseService.tableCycles)
              .select()
              .eq('user_id', user.id)
              .order('start_date', ascending: false);

          final cloudCycles = (response as List<dynamic>)
              .map((json) => CycleModel.fromJson(json as Map<String, dynamic>))
              .toList();

          if (cloudCycles.isNotEmpty) {
            loadedCycles = cloudCycles;
            await _saveToLocal(cloudCycles);
          }
        } catch (_) {}
      }

      // Tentukan activeCycle (siklus yang masih berlangsung / endDate == null, atau siklus terbaru)
      final ongoingCycle = loadedCycles.where((c) => c.endDate == null).firstOrNull;
      final active = ongoingCycle ?? (loadedCycles.isNotEmpty ? loadedCycles.first : null);

      state = state.copyWith(
        history: loadedCycles,
        activeCycle: active,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Mulai mencatat hari pertama haid (Mulai Haid)
  Future<void> startHaid({DateTime? date}) async {
    final rawDate = date ?? DateTime.now();
    final effectiveDate = DateTime(rawDate.year, rawDate.month, rawDate.day);
    final user = SupabaseService.instance.currentUser;
    final newCycle = CycleModel(
      id: 'cycle-${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? 'local-user',
      startDate: effectiveDate,
      endDate: null,
      durationHaid: null,
      createdAt: DateTime.now(),
    );

    final updatedHistory = [newCycle, ...state.history]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    state = state.copyWith(
      activeCycle: newCycle,
      history: updatedHistory,
    );

    // Simpan permanen ke SharedPreferences lokal
    await _saveToLocal(updatedHistory);

    if (user != null) {
      try {
        await SupabaseService.instance.client
            .from(SupabaseService.tableCycles)
            .insert(newCycle.toJson());
      } catch (_) {}
    }
  }

  /// Tandai darah telah berhenti (Tandai Suci)
  Future<void> markSuci({DateTime? date}) async {
    final targetCycle = (state.activeCycle != null && state.activeCycle!.endDate == null)
        ? state.activeCycle!
        : state.history.where((c) => c.endDate == null).firstOrNull;

    if (targetCycle == null) return;

    final rawEndDate = date ?? DateTime.now();
    final effectiveEndDate = DateTime(rawEndDate.year, rawEndDate.month, rawEndDate.day);
    final startNormal = DateTime(targetCycle.startDate.year, targetCycle.startDate.month, targetCycle.startDate.day);
    final diff = effectiveEndDate.difference(startNormal).inDays;
    final calculatedDuration = diff >= 0 ? diff + 1 : 1;

    final closedCycle = targetCycle.copyWith(
      endDate: effectiveEndDate,
      durationHaid: calculatedDuration,
    );

    final updatedHistory = state.history.map((c) {
      return c.id == closedCycle.id ? closedCycle : c;
    }).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    state = state.copyWith(
      activeCycle: closedCycle,
      history: updatedHistory,
    );

    // Simpan permanen ke SharedPreferences lokal
    await _saveToLocal(updatedHistory);

    final user = SupabaseService.instance.currentUser;
    if (user != null) {
      try {
        await SupabaseService.instance.client
            .from(SupabaseService.tableCycles)
            .update(closedCycle.toJson())
            .eq('id', closedCycle.id);
      } catch (_) {}
    }
  }

  /// Simpan atau catat siklus lengkap (misal input rentang tanggal haid selesai) secara permanen
  Future<void> saveCycle({
    required DateTime startDate,
    DateTime? endDate,
    int? durationHaid,
    String? notes,
  }) async {
    final user = SupabaseService.instance.currentUser;
    final startNormal = DateTime(startDate.year, startDate.month, startDate.day);
    final endNormal = endDate != null
        ? DateTime(endDate.year, endDate.month, endDate.day)
        : null;

    int? duration = durationHaid;
    if (duration == null && endNormal != null) {
      final diff = endNormal.difference(startNormal).inDays;
      duration = diff >= 0 ? diff + 1 : 1;
    }

    final ongoing = state.history.where((c) => c.endDate == null).firstOrNull;
    final CycleModel savedCycle;
    final List<CycleModel> updated;

    if (ongoing != null) {
      savedCycle = ongoing.copyWith(
        startDate: startNormal,
        endDate: endNormal,
        durationHaid: duration,
        notes: notes ?? ongoing.notes,
      );
      updated = state.history.map((c) => c.id == ongoing.id ? savedCycle : c).toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
    } else {
      savedCycle = CycleModel(
        id: 'cycle-${DateTime.now().millisecondsSinceEpoch}',
        userId: user?.id ?? 'local-user',
        startDate: startNormal,
        endDate: endNormal,
        durationHaid: duration,
        notes: notes,
        createdAt: DateTime.now(),
      );
      updated = [savedCycle, ...state.history]
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
    }

    final ongoingCycle = updated.where((c) => c.endDate == null).firstOrNull;
    final active = ongoingCycle ?? updated.first;

    state = state.copyWith(
      history: updated,
      activeCycle: active,
    );

    // Simpan permanen ke SharedPreferences lokal
    await _saveToLocal(updated);

    if (user != null) {
      try {
        await SupabaseService.instance.client
            .from(SupabaseService.tableCycles)
            .upsert(savedCycle.toJson());
      } catch (_) {}
    }
  }
}

final cycleProvider = StateNotifierProvider<CycleNotifier, CycleState>((ref) {
  return CycleNotifier();
});
