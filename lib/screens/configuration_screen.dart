import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme/app_colors.dart';
import '../widgets/registration_stepper.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  // Switch states
  bool _illuNorm = true;
  bool _shadowAware = true;
  bool _localContrast = false;
  
  bool _multiScale = true;
  bool _viewpoint = true;
  bool _noiseReduction = false;
  
  bool _spatialUniformity = true;
  bool _subPixelRefine = true;

  double _rmseTarget = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar Area
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  onPressed: widget.onBack,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration Config',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'STEP 2 OF 5 · ALGORITHM PARAMETERS',
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

        // Stepper
        const RegistrationStepper(currentStep: 2),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('ILLUMINATION PROCESSING'),
                _ConfigCard(
                  children: [
                    _SwitchRow(
                      title: 'Illumination Normalization',
                      value: _illuNorm,
                      onChanged: (v) => setState(() => _illuNorm = v),
                    ),
                    const Divider(height: 1),
                    _SwitchRow(
                      title: 'Shadow-Aware Processing',
                      value: _shadowAware,
                      onChanged: (v) => setState(() => _shadowAware = v),
                    ),
                    const Divider(height: 1),
                    _SwitchRow(
                      title: 'Local Contrast Enhancement',
                      value: _localContrast,
                      onChanged: (v) => setState(() => _localContrast = v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('GEOMETRIC CORRECTION'),
                _ConfigCard(
                  children: [
                    _SwitchRow(
                      title: 'Multi-Scale Processing',
                      value: _multiScale,
                      onChanged: (v) => setState(() => _multiScale = v),
                    ),
                    const Divider(height: 1),
                    _SwitchRow(
                      title: 'Viewpoint Correction',
                      value: _viewpoint,
                      onChanged: (v) => setState(() => _viewpoint = v),
                    ),
                    const Divider(height: 1),
                    _SwitchRow(
                      title: 'Noise Reduction (Gaussian)',
                      value: _noiseReduction,
                      onChanged: (v) => setState(() => _noiseReduction = v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('FEATURE DETECTION'),
                _ConfigCard(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildDropdownRow('Detection Algorithm', 'SIFT', ['SIFT', 'ORB', 'SURF']),
                    const SizedBox(height: 16),
                    _buildDropdownRow('Feature Matcher', 'KNN + Ratio Test', ['KNN + Ratio Test', 'Brute Force']),
                    const SizedBox(height: 16),
                    _buildDropdownRow('Outlier Rejection', 'RANSAC', ['RANSAC', 'LMeDS', 'MAGSAC']),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('ACCURACY TARGET'),
                _ConfigCard(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Text(
                          'Sub-Pixel Accuracy Target',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.info_outline, size: 14, color: AppColors.textDisabled),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RMSE target',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${_rmseTarget.toStringAsFixed(1)} px',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _rmseTarget,
                      min: 0.1,
                      max: 2.0,
                      divisions: 19,
                      onChanged: (v) => setState(() => _rmseTarget = v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0.1 px', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textDisabled)),
                        Text('2.0 px', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textDisabled)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '← Sub-pixel regime · requires ECC/LK refinement',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('QUALITY CONTROLS'),
                _ConfigCard(
                  children: [
                    _SwitchRow(
                      title: 'Enforce Spatial Uniformity',
                      value: _spatialUniformity,
                      onChanged: (v) => setState(() => _spatialUniformity = v),
                    ),
                    const Divider(height: 1),
                    _SwitchRow(
                      title: 'Sub-pixel Refinement (ECC)',
                      value: _subPixelRefine,
                      onChanged: (v) => setState(() => _subPixelRefine = v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('QUALITY THRESHOLDS'),
                _ConfigCard(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('500', 'Min Inliers'),
                        _buildStat('60%', 'Min Inlier %'),
                        _buildStat('1.5 px', 'Max RMSE'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Bottom Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          onPressed: widget.onBack,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border, width: 1.5),
                            foregroundColor: AppColors.textSecondary,
                          ),
                          child: const Text('← Back'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: widget.onNext,
                          child: const Text('Run Registration →'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDropdownRow(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.info_outline, size: 14, color: AppColors.textDisabled),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surfaceVariant,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textDisabled,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({required this.children, this.padding});
  
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.info_outline, size: 14, color: AppColors.textDisabled),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
