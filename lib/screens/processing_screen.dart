import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme/app_colors.dart';

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Processing',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'REGISTRATION PIPELINE RUNNING',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDisabled,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Circular Progress
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background ticks and circle (simplified with Container)
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                      ),
                      // Progress Arc
                      const SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: 0.68,
                          strokeWidth: 6,
                          backgroundColor: Colors.transparent,
                          color: AppColors.accent,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Inner Text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '68',
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PERCENT',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDisabled,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ETA 44s',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Stats Row
                Row(
                  children: [
                    Expanded(child: _buildStatBox('24,831', 'FEATURES')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatBox('8,429', 'MATCHES', isAccent: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatBox('4s', 'ELAPSED')),
                  ],
                ),
                const SizedBox(height: 32),

                // Pipeline Section
                Text(
                  'PROCESSING PIPELINE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Pipeline Items
                _PipelineItem(
                  title: 'Image Validation',
                  subtitle: 'Format check · metadata extraction',
                  state: _PipelineState.done,
                ),
                _PipelineItem(
                  title: 'Pre-processing',
                  subtitle: 'Illumination normalize · CLAHE',
                  state: _PipelineState.done,
                ),
                _PipelineItem(
                  title: 'Multi-scale Analysis',
                  subtitle: '4-level pyramid · coarse alignment',
                  state: _PipelineState.done,
                ),
                _PipelineItem(
                  title: 'Feature Detection',
                  subtitle: 'SIFT · 24,831 keypoints found',
                  state: _PipelineState.done,
                ),
                _PipelineItem(
                  title: 'Feature Matching',
                  subtitle: 'KNN + ratio test · matching in progress...',
                  state: _PipelineState.inProgress,
                ),
                _PipelineItem(
                  title: 'Outlier Rejection',
                  state: _PipelineState.pending,
                ),
                _PipelineItem(
                  title: 'Transformation Est.',
                  state: _PipelineState.pending,
                ),
                const SizedBox(height: 24),

                // Overall Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overall Progress',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '75%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.75,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 24),

                // Hardware Stats
                Row(
                  children: [
                    Expanded(child: _buildHardwareStat('GPU UTIL', '84%', 0.84, AppColors.accent)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildHardwareStat('VRAM', '6.2 GB', 0.6, AppColors.error)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildHardwareStat('RAM', '12.4 GB', 0.4, AppColors.success)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildHardwareStat('PROCESSING', 'GPU Mode', 1.0, AppColors.accent)),
                  ],
                ),
                const SizedBox(height: 24),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel Registration'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Cancellation will not affect original image data',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String value, String label, {bool isAccent = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAccent ? AppColors.accent.withValues(alpha: 0.5) : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isAccent ? AppColors.accent : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textDisabled,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHardwareStat(String label, String value, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDisabled,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

enum _PipelineState { done, inProgress, pending }

class _PipelineItem extends StatelessWidget {
  const _PipelineItem({
    required this.title,
    this.subtitle,
    required this.state,
  });

  final String title;
  final String? subtitle;
  final _PipelineState state;

  @override
  Widget build(BuildContext context) {
    final bool isDone = state == _PipelineState.done;
    final bool isInProgress = state == _PipelineState.inProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isInProgress ? AppColors.accentSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isInProgress ? AppColors.accent.withValues(alpha: 0.5) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone ? AppColors.success : (isInProgress ? AppColors.accent : AppColors.border),
                width: 1.5,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: AppColors.success)
                  : (isInProgress
                      ? const Icon(Icons.arrow_drop_down_rounded, size: 20, color: AppColors.accent)
                      : const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.border)),
            ),
          ),
          const SizedBox(width: 16),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDone || isInProgress ? AppColors.textPrimary : AppColors.textDisabled,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isInProgress ? AppColors.accent : AppColors.textDisabled,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Trailing Icon
          if (isDone)
            const Icon(Icons.check, size: 16, color: AppColors.success)
          else if (isInProgress)
            const Text(
              '•••',
              style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }
}
