import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../state/app_state.dart';
import 'models/property.dart';
import 'profile_screen.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/property_card.dart';

class TenantDashboardScreen extends StatefulWidget {
  const TenantDashboardScreen({super.key});

  @override
  State<TenantDashboardScreen> createState() => _TenantDashboardScreenState();
}

class _TenantDashboardScreenState extends State<TenantDashboardScreen> {
  static const _categories = ['House', 'Shortlet', 'Self-Con', 'Apartment'];
  int _selectedCategory = 0;
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppState>().dashboardTheme;
    final onProfileTab = _navIndex == 3;
    return Scaffold(
      backgroundColor: onProfileTab ? theme.background : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (onProfileTab)
              ProfileScreen(onLogOut: () => context.go('/get-started'))
            else
              _buildHomeFeed(theme),
            Positioned(
              left: 20,
              right: 20,
              bottom: 12,
              child: DashboardBottomNav(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
                theme: theme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeFeed(DashboardTheme theme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ikeja, Lagos',
                          style: AppTextStyles.body(
                            color: AppColors.navy,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.navy,
                        ),
                        const SizedBox(width: 16),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              color: AppColors.navy,
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.navy),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Search by location',
                                    style: AppTextStyles.body(
                                      color: AppColors.navy,
                                      size: 14,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Agege',
                                    style: AppTextStyles.body(
                                      color: AppColors.hintGrey,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.accent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: theme.onAccent,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Categories',
                  style: AppTextStyles.heading(color: AppColors.navy, size: 20),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = index == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? theme.accent : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow:
                          selected
                              ? []
                              : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                    ),
                    child: Text(
                      _categories[index],
                      style: AppTextStyles.body(
                        color: selected ? theme.onAccent : AppColors.navy,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          sliver: SliverList.builder(
            itemCount: mockProperties.length,
            itemBuilder:
                (context, index) =>
                    PropertyCard(property: mockProperties[index]),
          ),
        ),
      ],
    );
  }
}
