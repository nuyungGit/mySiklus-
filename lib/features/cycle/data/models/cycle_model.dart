class CycleModel {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? durationHaid;
  final String? notes;
  final DateTime createdAt;

  const CycleModel({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.durationHaid,
    this.notes,
    required this.createdAt,
  });

  /// Apakah saat ini pengguna sedang dalam fase haid (belum ditandai suci)
  bool get isOngoingHaid => endDate == null;

  /// Apakah siklus ini sudah selesai dan pengguna masuk ke fase masa suci
  bool get isSuci => endDate != null;

  /// Menghitung berapa hari masa suci sudah berjalan sejak `endDate` hingga hari ini
  int get purityDaysRunning {
    if (endDate == null) return 0;
    final now = DateTime.now();
    final tanggalHariIniNormal = DateTime(now.year, now.month, now.day);
    final tanggalSelesaiNormal = DateTime(endDate!.year, endDate!.month, endDate!.day);
    final diff = tanggalHariIniNormal.difference(tanggalSelesaiNormal).inDays;
    return diff >= 0 ? diff : 0;
  }

  /// Menghitung durasi hari haid aktual
  int calculateDurationHaid() {
    if (durationHaid != null) return durationHaid!;
    if (endDate == null) {
      final now = DateTime.now();
      final diff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(startDate.year, startDate.month, startDate.day))
          .inDays;
      return diff >= 0 ? diff + 1 : 1;
    }
    final diff = DateTime(endDate!.year, endDate!.month, endDate!.day)
        .difference(DateTime(startDate.year, startDate.month, startDate.day))
        .inDays;
    return diff >= 0 ? diff + 1 : 1;
  }

  factory CycleModel.fromJson(Map<String, dynamic> json) {
    final parsedStart = DateTime.parse(json['start_date'] as String);
    final parsedEnd = json['end_date'] != null
        ? DateTime.parse(json['end_date'] as String)
        : null;
    return CycleModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startDate: DateTime(parsedStart.year, parsedStart.month, parsedStart.day),
      endDate: parsedEnd != null
          ? DateTime(parsedEnd.year, parsedEnd.month, parsedEnd.day)
          : null,
      durationHaid: json['duration_haid'] as int?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_date': "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
      'end_date': endDate != null
          ? "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}"
          : null,
      'duration_haid': durationHaid,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CycleModel copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? durationHaid,
    String? notes,
    DateTime? createdAt,
  }) {
    return CycleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      durationHaid: durationHaid ?? this.durationHaid,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
