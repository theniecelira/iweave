import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/loading_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: provider.markAllAsRead,
              child: const Text('Mark all read', style: TextStyle(fontSize: 12, color: AppColors.primary)),
            ),
        ],
      ),
      body: provider.notifications.isEmpty
        ? const EmptyStateWidget(
            title: 'No notifications yet',
            subtitle: 'We\'ll notify you about orders, tours, and special offers',
            icon: Icons.notifications_none_rounded,
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final n = provider.notifications[i];
              return GestureDetector(
                onTap: () => provider.markAsRead(n.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: n.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(
                      color: n.isRead ? AppColors.border : AppColors.primary.withOpacity(0.2),
                    ),
                    boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: _typeColor(n.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Icon(_typeIcon(n.type), color: _typeColor(n.type), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(child: Text(n.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ))),
                              if (!n.isRead)
                                Container(
                                  width: 8, height: 8,
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                ),
                            ]),
                            const SizedBox(height: 4),
                            Text(n.message,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Text(AppFormatters.timeAgo(n.createdAt),
                              style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order: return Icons.shopping_bag_rounded;
      case NotificationType.tour: return Icons.explore_rounded;
      case NotificationType.promo: return Icons.local_offer_rounded;
      case NotificationType.system: return Icons.info_rounded;
    }
  }

  Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.order: return AppColors.accent;
      case NotificationType.tour: return AppColors.primary;
      case NotificationType.promo: return AppColors.success;
      case NotificationType.system: return AppColors.info;
    }
  }
}
