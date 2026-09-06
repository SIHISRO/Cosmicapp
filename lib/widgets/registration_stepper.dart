import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme/app_colors.dart';

class RegistrationStepper extends StatelessWidget {
  const RegistrationStepper({
    super.key,
    required this.currentStep,
  });

  /// 1-indexed current step (1 to 5)
  final int currentStep;

  static const List<String> _steps = [
    'Images',
    'Config',
    'Process',
    'Verify',
    'Export',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_steps.length, (index) {
          final stepNumber = index + 1;
          final isCompleted = stepNumber < currentStep;
          final isActive = stepNumber == currentStep;
          final isLast = stepNumber == _steps.length;

          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Circle + Line
                      Row(
                        children: [
                          // Left line
                          Expanded(
                            child: index == 0
                                ? const SizedBox()
                                : Container(
                                    height: 1,
                                    color: stepNumber <= currentStep
                                        ? AppColors.success
                                        : AppColors.border,
                                  ),
                          ),
                          // Circle
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? AppColors.success
                                  : AppColors.transparent,
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.success
                                    : isActive
                                        ? AppColors.accent
                                        : AppColors.textDisabled,
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  )
                                : Text(
                                    stepNumber.toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isActive
                                          ? AppColors.accent
                                          : AppColors.textDisabled,
                                    ),
                                  ),
                          ),
                          // Right line
                          Expanded(
                            child: isLast
                                ? const SizedBox()
                                : Container(
                                    height: 1,
                                    color: isCompleted
                                        ? AppColors.success
                                        : AppColors.border,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Text
                      Text(
                        _steps[index],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive
                              ? AppColors.accent
                              : (isCompleted
                                  ? AppColors.textPrimary
                                  : AppColors.textDisabled),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
