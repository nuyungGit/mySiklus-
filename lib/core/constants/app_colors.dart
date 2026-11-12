import 'package:flutter/material.dart';

/// Palet warna mySiklus dengan nuansa pastel kekinian (blush pink, soft lilac, dusty rose).
/// Menghilangkan elemen warna hijau dan warna gonjreng yang bertabrakan.
class AppColors {
  AppColors._();

  // Primary Palette (Dusty Rose & Blush Pink)
  static const Color dustyRose = Color(0xFFB5838D); // Status Haid & aksen hangat
  static const Color dustyRoseLight = Color(0xFFFFF0F5);
  static const Color dustyRoseDark = Color(0xFF8C5B66);

  // Secondary Palette (Transisi dari Sage Green lama ke Soft Pastel Lilac / Dusty Rose)
  static const Color sageGreen = Color(0xFFB5838D); // Dusty Rose pengganti hijau
  static const Color sageGreenLight = Color(0xFFF8EAED); // Pastel pink lembut
  static const Color sageGreenDark = Color(0xFF8C5B66); // Dusty rose pekat

  // Tertiary / Accent
  static const Color softMauve = Color(0xFF9D8189);
  static const Color softMauveLight = Color(0xFFF7ECF2);

  // Neutral Backgrounds
  static const Color background = Color(0xFFFFF5F8); // Putih dengan hint pink pudar
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFFAF2F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2926);
  static const Color textSecondary = Color(0xFF756E68);
  static const Color textMuted = Color(0xFFA59E98);

  // Borders & Dividers
  static const Color border = Color(0xFFEBE5DF);
  static const Color divider = Color(0xFFF0EBE5);

  // Status & Badges
  static const Color badgeHaidBg = Color(0xFFFDE8ED);
  static const Color badgeHaidText = Color(0xFFC75A70);

  static const Color badgeSuciBg = Color(0xFFFFF0E6); // Soft peach / pastel lembut
  static const Color badgeSuciText = Color(0xFFB5838D); // Dusty rose

  static const Color badgeIstihadahBg = Color(0xFFFFF6E5);
  static const Color badgeIstihadahText = Color(0xFFB57E12);
}
