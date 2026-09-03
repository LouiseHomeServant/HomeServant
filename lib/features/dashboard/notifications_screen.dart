import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';

class NotificationItem {
  const NotificationItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
}

const _mockNotifications = [
  NotificationItem(
    icon: Icons.check_circle_rounded,
    title: 'Application approved',
    body: 'Your application for 4 Bedroom Apartment in Opebi was approved.',
    time: '2h ago',
  ),
  NotificationItem(
    icon: Icons.payments_rounded,
    title: 'Rent reminder',
    body: 'Your rent for Studio Self-Con is due in 5 days.',
    time: '1d ago',
  ),
  NotificationItem(
    icon: Icons.chat_bubble_rounded,
    title: 'New message',
    body: 'The landlord for 2 Bedroom Flat replied to your enquiry.',
    time: '2d ago',
  ),
  NotificationItem(
    icon: Icons.home_work_rounded,
    title: 'New listing near you',
    body: 'A Cozy Shortlet Studio just went live in Lekki, Lagos.',
    time: '4d ago',
  ),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text(
          'Notifications',
          style: AppTextStyles.heading(color: theme.foreground, size: 18),
        ),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: _mockNotifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _mockNotifications[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.surface,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.accent.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: theme.accent, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: AppTextStyles.body(
                                    color: theme.onSurface,
                                    size: 15,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                item.time,
                                style: AppTextStyles.body(
                                  color: theme.onSurface.withValues(alpha: 0.5),
                                  size: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.body,
                            style: AppTextStyles.body(
                              color: theme.onSurface.withValues(alpha: 0.75),
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
