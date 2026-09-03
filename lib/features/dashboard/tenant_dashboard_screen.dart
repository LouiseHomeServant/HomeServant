import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../state/app_state.dart';
import 'messages_screen.dart';
import 'models/property.dart';
import 'notifications_screen.dart';
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

  final _searchController = TextEditingController();
  String _searchQuery = '';
  double _minRating = 0;
  bool _sortTopRatedFirst = false;
  bool _hasUnreadNotifications = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Property> get _filteredProperties {
    final query = _searchQuery.trim().toLowerCase();
    final selectedCategory = _categories[_selectedCategory];
    final filtered = mockProperties.where((property) {
      final matchesQuery = query.isEmpty ||
          property.title.toLowerCase().contains(query) ||
          property.location.toLowerCase().contains(query);
      final matchesCategory = property.category == selectedCategory;
      final matchesRating = property.rating >= _minRating;
      return matchesQuery && matchesCategory && matchesRating;
    }).toList();
    if (_sortTopRatedFirst) {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return filtered;
  }

  Future<void> _openFilterSheet(DashboardTheme theme) async {
    var minRating = _minRating;
    var sortTopRatedFirst = _sortTopRatedFirst;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filters', style: AppTextStyles.heading(color: theme.onSurface, size: 18)),
                  const SizedBox(height: 18),
                  Text('Minimum rating', style: AppTextStyles.body(color: theme.onSurface, weight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final option in const [0.0, 4.0, 4.5])
                        ChoiceChip(
                          label: Text(option == 0 ? 'Any' : '${option.toStringAsFixed(1)}+'),
                          selected: minRating == option,
                          onSelected: (_) => setSheetState(() => minRating = option),
                          selectedColor: theme.accent,
                          labelStyle: AppTextStyles.body(
                            color: minRating == option ? theme.onAccent : theme.onSurface,
                            weight: FontWeight.w600,
                          ),
                          backgroundColor: theme.onSurface.withValues(alpha: 0.06),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: sortTopRatedFirst,
                    onChanged: (value) => setSheetState(() => sortTopRatedFirst = value),
                    activeColor: theme.accent,
                    title: Text('Sort by top rated', style: AppTextStyles.body(color: theme.onSurface, weight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      onPressed: () {
                        setState(() {
                          _minRating = minRating;
                          _sortTopRatedFirst = sortTopRatedFirst;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Apply', style: AppTextStyles.button(color: theme.onAccent)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                          color: theme.locationPinColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ikeja, Lagos',
                          style: AppTextStyles.body(
                            color: theme.foreground,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => MessagesScreen(theme: theme)),
                          ),
                          child: Icon(
                            Icons.mail_outline_rounded,
                            color: theme.foreground,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() => _hasUnreadNotifications = false);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => NotificationsScreen(theme: theme)),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                color: theme.foreground,
                              ),
                              if (_hasUnreadNotifications)
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
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
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
                            const Icon(Icons.search, color: AppColors.navy, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) => setState(() => _searchQuery = value),
                                style: AppTextStyles.body(color: AppColors.navy, size: 16, weight: FontWeight.w600),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: 'Search by location or property',
                                  hintStyle: AppTextStyles.body(color: AppColors.hintGrey, size: 15),
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                child: const Icon(Icons.close_rounded, color: AppColors.hintGrey, size: 20),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _openFilterSheet(theme),
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: theme.accent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: theme.onAccent,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Categories',
                  style: AppTextStyles.heading(color: theme.foreground, size: 20),
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
        if (_filteredProperties.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  'No properties match your search',
                  style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6)),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList.builder(
              itemCount: _filteredProperties.length,
              itemBuilder:
                  (context, index) =>
                      PropertyCard(property: _filteredProperties[index], theme: theme),
            ),
          ),
      ],
    );
  }
}
