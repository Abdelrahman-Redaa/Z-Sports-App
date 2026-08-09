import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFF182540);
  static const Color backgroundLight = Color(0xFF1D2E4D);
  static const Color splashTop = Color(0xFF182540);
  static const Color splashBottom = Color(0xFF0F172A);

  static const Color surface = Color(0xFF131D32);
  static const Color surfaceLight = Color(0xFF1D2C4D);
  static const Color surfaceBorder = Color(0xFF2A3C60);

  static const Color primary = Color(0xFF39FF14);
  static const Color primaryDark = Color(0xFF22C55E);
  static const Color primaryMuted = Color(0x3339FF14);

  static const Color accentOrange = Color(0xFFFF8C00);
  static const Color accentOrangeDark = Color(0xFFE67E00);

  static const Color inputWhite = Color(0xFFFFFFFF);
  static const Color inputTextDark = Color(0xFF1A1A1A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A96A3);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textLabel = Color(0xFFB0B8C4);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF39FF14);
  static const Color warning = Color(0xFFF59E0B);
  static const Color favorite = Color(0xFFEF4444);

  static const Color chatBubbleSent = Color(0xFF39FF14);
  static const Color chatBubbleReceived = Color(0xFF161B22);

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [splashTop, splashBottom],
  );
}
