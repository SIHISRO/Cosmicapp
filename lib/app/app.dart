import 'package:flutter/material.dart';
import 'package:cosmic/app/theme/app_theme.dart';
import 'package:cosmic/screens/dashboard_screen.dart';

/// Root application widget.
/// Applies [AppTheme.dark].
class CosmicApp extends StatelessWidget {
  const CosmicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic – Lunar Image Registration',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const DashboardScreen(),
    );
  }
}
