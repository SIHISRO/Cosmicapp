import 'package:flutter/material.dart';

/// Cosmic – Lunar Image Registration System
/// Central color palette. All colors are defined here and nowhere else.
abstract final class AppColors {
  // ── Backgrounds ──────────────────────────────────────────────────────────
  /// Main scaffold / page background
  static const Color background = Color(0xFF25343F);

  /// Elevated card / panel surface
  static const Color surface = Color(0xFF2E4050);

  /// Slightly lighter surface for nested cards / hover states
  static const Color surfaceVariant = Color(0xFF364B5E);

  /// Dividers, input borders, subtle separators
  static const Color border = Color(0xFF3D5468);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// High-emphasis body & heading text
  static const Color textPrimary = Color(0xFFEAEFEF);

  /// Medium-emphasis labels, captions, secondary info
  static const Color textSecondary = Color(0xFFBFC9D1);

  /// Disabled / placeholder text
  static const Color textDisabled = Color(0xFF6B8499);

  // ── Brand / Accent ───────────────────────────────────────────────────────
  /// Primary CTA, interactive highlight (orange)
  static const Color accent = Color(0xFFFF9B51);

  /// Slightly dimmed accent for hover/pressed states
  static const Color accentDim = Color(0xFFE07A30);

  /// Very subtle accent tint for backgrounds
  static const Color accentSurface = Color(0x1AFF9B51); // 10 % opacity

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF3FB950);
  static const Color successSurface = Color(0x1A3FB950);

  static const Color error = Color(0xFFF85149);
  static const Color errorSurface = Color(0x1AF85149);

  static const Color warning = Color(0xFFD29922);
  static const Color warningSurface = Color(0x1AD29922);

  static const Color info = Color(0xFF58A6FF);
  static const Color infoSurface = Color(0x1A58A6FF);

  // ── Utility ──────────────────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF1E2D38), Color(0xFF25343F), Color(0xFF2C3E4D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF2E4050), Color(0xFF364B5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowAccent = RadialGradient(
    colors: [Color(0x33FF9B51), Color(0x00FF9B51)],
    radius: 0.8,
  );
}
