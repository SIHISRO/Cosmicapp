import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme/app_colors.dart';

/// A card that shows a row of status indicators (backend, GPU, version).
class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({
    super.key,
    this.isBackendOnline = true,
    this.gpuLabel = 'GPU: RTX 3090',
    this.version = 'v1.4.2',
  });

  final bool isBackendOnline;
  final String gpuLabel;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          _StatusDot(
            label: isBackendOnline ? 'Backend Online' : 'Backend Offline',
            color: isBackendOnline ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 18),
          _StatusDot(
            label: gpuLabel,
            color: AppColors.success,
          ),
          const Spacer(),
          Text(
            version,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.textDisabled,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 4)],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
