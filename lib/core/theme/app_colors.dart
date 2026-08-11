import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFF0B1220);
  static const Color backgroundOverlay = Color(0xCC0B1220);
  static const Color backgroundLight = Color(0xFF0A0F18);
  static const Color splashTop = Color(0xFF0B1220);
  static const Color splashBottom = Color(0xFF0F172A);

  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF0A0F18);
  static const Color surfaceBorder = Color(0xFF334155);
  static const Color navBorder = Color(0xFF1E293B);

  static const Color primary = Color(0xFF31F91A);
  static const Color primaryDark = Color(0xFF22C55E);
  static const Color primaryMuted = Color(0x1A31F91A);

  static const Color accentOrange = Color(0xFFFF8C00);
  static const Color accentOrangeDark = Color(0xFFE67E00);

  static const Color inputWhite = Color(0xFFFFFFFF);
  static const Color inputStroke = Color(0xFF6B7280);
  static const Color inputTextDark = Color(0xFF0F172A);
  static const Color inputHintDark = Color(0xFF475569);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLabel = Color(0xFFCBD5E1);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF31F91A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color favorite = Color(0xFFEF4444);

  static const Color chatBubbleSent = Color(0xFF31F91A);
  static const Color chatBubbleReceived = Color(0xFF161B22);

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [splashTop, splashBottom],
  );
}
