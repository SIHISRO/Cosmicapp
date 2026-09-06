import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme/app_colors.dart';
import '../widgets/recent_registration_card.dart';
import '../widgets/statistics_card.dart';
import '../widgets/system_status_card.dart';
import 'configuration_screen.dart';
import 'image_upload_screen.dart';
import 'processing_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // ── Sample data ──────────────────────────────────────────────────────────
  static const _sessions = [
    RegistrationSession(
      id: 'REG-2847',
      filename: 'CH2_TMC2_ORB2847_W.tif',
      sensor: 'LROC_NAC_M181732946LE',
      date: '2026-08-29',
      status: RegistrationStatus.completed,
      rmse: '8.42',
      ir: '79.4',
    ),
    RegistrationSession(
      id: 'REG-2846',
      filename: 'CH2_TMC2_ORB2846_W.tif',
      sensor: 'LROC_NAC_M182809934LE',
      date: '2026-08-27',
      status: RegistrationStatus.processing,
    ),
    RegistrationSession(
      id: 'REG-2841',
      filename: 'CH2_TMC2_ORB2841_S.tif',
      sensor: 'SELENE_TC_S018_D139.tif',
      date: '2026-08-22',
      status: RegistrationStatus.review,
      rmse: '1.87',
      ir: '53.2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildCurrentView(),
            ),

            // ── Bottom Nav ───────────────────────────────────────────────
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── Builder helpers ───────────────────────────────────────────────────────
  
  Widget _buildCurrentView() {
    switch (_selectedIndex) {
      case 1:
        return ImageUploadScreen(
          onNext: () => setState(() => _selectedIndex = 2),
        );
      case 2:
        return ConfigurationScreen(
          onBack: () => setState(() => _selectedIndex = 1),
          onNext: () => setState(() => _selectedIndex = 3),
        );
      case 3:
        return ProcessingScreen(
          onCancel: () => setState(() => _selectedIndex = 0),
        );
      case 0:
      case 4:
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── App Bar ─────────────────────────────────────────────
        SliverToBoxAdapter(child: _buildHeader()),

        // ── System Status ────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          sliver: SliverToBoxAdapter(
            child: SystemStatusCard(
              isBackendOnline: true,
              gpuLabel: 'GPU: RTX 3090',
              version: 'v1.4.2',
            ),
          ),
        ),

        // ── Stats Row ────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          sliver: SliverToBoxAdapter(child: _buildStatsRow()),
        ),

        // ── Avg RMSE / Inlier row ────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverToBoxAdapter(child: _buildMetricsRow()),
        ),

        // ── New Registration CTA ─────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverToBoxAdapter(child: _buildNewRegistrationBtn()),
        ),

        // ── Recent Sessions header ───────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          sliver: SliverToBoxAdapter(child: _buildSectionHeader('RECENT SESSIONS')),
        ),

        // ── Session list ─────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => RecentRegistrationCard(
                session: _sessions[i],
                onTap: () {},
              ),
              childCount: _sessions.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          // Target / compass icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.accentSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4), width: 1),
            ),
            child: const Icon(Icons.adjust_rounded, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LUNARALIGN',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                  letterSpacing: 1.4,
                ),
              ),
              Text(
                'CHANDRAYAAN-2 REGISTRATION',
                style: GoogleFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDisabled,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Notification bell
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.accentDim,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'RS',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: StatisticsCard(
            value: '24',
            label: 'Total',
            valueColor: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatisticsCard(
            value: '19',
            label: 'Success',
            valueColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatisticsCard(
            value: '3',
            label: 'Review',
            valueColor: AppColors.warning,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatisticsCard(
            value: '2',
            label: 'Failed',
            valueColor: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(child: _MetricInfoCard(
          icon: Icons.adjust_rounded,
          value: '0.58 px',
          label: 'AVG RMSE',
        )),
        const SizedBox(width: 10),
        Expanded(child: _MetricInfoCard(
          icon: Icons.grid_view_rounded,
          value: '74.8%',
          label: 'AVG INLIER',
        )),
      ],
    );
  }

  Widget _buildNewRegistrationBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.30),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'New Registration',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.6,
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.upload_rounded, label: 'Upload'),
      _NavItem(icon: Icons.tune_rounded, label: 'Config'),
      _NavItem(icon: Icons.play_arrow_rounded, label: 'Process'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Results'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == _selectedIndex;
              return _NavBarItem(
                item: items[i],
                selected: selected,
                hasIndicator: i == 0,
                onTap: () => setState(() => _selectedIndex = i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Supplementary widgets ──────────────────────────────────────────────────────

class _MetricInfoCard extends StatelessWidget {
  const _MetricInfoCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textDisabled, size: 16),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDisabled,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
    this.hasIndicator = false,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool hasIndicator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: selected ? AppColors.accent : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            if (hasIndicator && selected)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
