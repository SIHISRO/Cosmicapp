import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme/app_colors.dart';

enum RegistrationStatus { completed, processing, review, failed }

extension _RegistrationStatusExt on RegistrationStatus {
  String get label {
    switch (this) {
      case RegistrationStatus.completed:
        return '✓ Completed';
      case RegistrationStatus.processing:
        return '● Processing';
      case RegistrationStatus.review:
        return 'Review';
      case RegistrationStatus.failed:
        return 'Failed';
    }
  }

  Color get badgeColor {
    switch (this) {
      case RegistrationStatus.completed:
        return AppColors.success;
      case RegistrationStatus.processing:
        return AppColors.warning;
      case RegistrationStatus.review:
        return AppColors.error;
      case RegistrationStatus.failed:
        return AppColors.error;
    }
  }

  Color get badgeSurface {
    switch (this) {
      case RegistrationStatus.completed:
        return AppColors.successSurface;
      case RegistrationStatus.processing:
        return AppColors.warningSurface;
      case RegistrationStatus.review:
        return AppColors.errorSurface;
      case RegistrationStatus.failed:
        return AppColors.errorSurface;
    }
  }
}

/// Data model for a single registration session.
class RegistrationSession {
  const RegistrationSession({
    required this.id,
    required this.filename,
    required this.sensor,
    required this.date,
    required this.status,
    this.rmse,
    this.ir,
  });

  final String id;
  final String filename;
  final String sensor;
  final String date;
  final RegistrationStatus status;
  final String? rmse;
  final String? ir;
}

/// Card that renders one row in the "Recent Sessions" list.
class RecentRegistrationCard extends StatelessWidget {
  const RecentRegistrationCard({
    super.key,
    required this.session,
    this.thumbnailAsset,
    this.onTap,
  });

  final RegistrationSession session;

  /// Optional asset path; if null, a placeholder moon icon is shown.
  final String? thumbnailAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = session.status;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Thumbnail ──────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: thumbnailAsset != null
                    ? Image.asset(
                        thumbnailAsset!,
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                      )
                    : _MoonPlaceholder(),
              ),
              const SizedBox(width: 12),
              // ── Info ───────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID row + badge
                    Row(
                      children: [
                        Text(
                          session.id,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const Spacer(),
                        _StatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Filename
                    Text(
                      session.filename,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Sensor
                    Text(
                      '↳ ${session.sensor}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textDisabled,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Date + metrics row
                    Row(
                      children: [
                        Text(
                          session.date,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        if (session.rmse != null) ...[
                          const SizedBox(width: 10),
                          _MetricChip(
                            label: 'RMSE',
                            value: '${session.rmse} px',
                            color: AppColors.accent,
                          ),
                        ],
                        if (session.ir != null) ...[
                          const SizedBox(width: 8),
                          _MetricChip(
                            label: 'IR',
                            value: '${session.ir}%',
                            color: AppColors.info,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private helpers ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final RegistrationStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.badgeSurface,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: status.badgeColor.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        status.label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: status.badgeColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textDisabled,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoonPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.brightness_3_rounded,
        color: AppColors.textDisabled,
        size: 28,
      ),
    );
  }
}
