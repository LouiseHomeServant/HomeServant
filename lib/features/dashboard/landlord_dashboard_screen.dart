import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../state/app_state.dart';
import '../../widgets/home_servant_logo.dart';
import 'models/property.dart';
import 'profile_screen.dart';
import 'widgets/bottom_nav.dart';

class LandlordDashboardScreen extends StatefulWidget {
  const LandlordDashboardScreen({super.key});

  @override
  State<LandlordDashboardScreen> createState() =>
      _LandlordDashboardScreenState();
}

class _LandlordDashboardScreenState extends State<LandlordDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppState>().dashboardTheme;
    final onProfileTab = _navIndex == 3;
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Stack(
          children: [
            if (onProfileTab)
              ProfileScreen(onLogOut: () => context.go('/get-started'))
            else
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HomeServantLogo(
                                role: UserRole.landlord,
                                iconSize: 40,
                                color: theme.foreground,
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Icons.notifications_none_rounded,
                                    color: theme.foreground,
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
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'My Properties',
                                style: AppTextStyles.heading(
                                  color: theme.foreground,
                                  size: 22,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.navy,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: AppColors.gold,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Add',
                                      style: AppTextStyles.body(
                                        color: AppColors.gold,
                                        weight: FontWeight.w700,
                                        size: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                        sliver: SliverList.builder(
                          itemCount: mockProperties.length,
                          itemBuilder:
                              (context, index) => _LandlordPropertyTile(
                                property: mockProperties[index],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 12,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: DashboardBottomNav(
                    currentIndex: _navIndex,
                    onTap: (i) => setState(() => _navIndex = i),
                    theme: theme,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandlordPropertyTile extends StatelessWidget {
  const _LandlordPropertyTile({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              property.imageAsset,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: AppTextStyles.body(
                    color: AppColors.navy,
                    size: 15,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  property.location,
                  style: AppTextStyles.body(
                    color: AppColors.hintGrey,
                    size: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Active',
                    style: AppTextStyles.body(
                      color: AppColors.goldDark,
                      size: 11,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
        ],
      ),
    );
  }
}
