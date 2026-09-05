import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Nouveau rapport disponible',
      description:
          'Le rapport hebdomadaire de la campagne Promo Orange Money est prêt.',
      date: '10:30',
      category: 'AUJOURD’HUI',
      type: NotificationType.report,
      isRead: false,
    ),

    NotificationItem(
      title: 'Objectif atteint',
      description:
          'Félicitations ! Vous avez atteint 80 % de votre objectif mensuel.',
      date: 'Hier',
      category: 'HIER',
      type: NotificationType.success,
      isRead: true,
    ),

    NotificationItem(
      title: 'Suggestion IA',
      description: 'Kiyanza a une recommandation pour optimiser votre budget Facebook Ads.',
      date: 'Hier',
      category: 'HIER',
      type: NotificationType.ai,
      isRead: false,
      isMention: true,
    ),

    NotificationItem(
      title: 'Campagne en pause',
      description: 'La campagne « Offre Spéciale été » a été automatiquement mise en pause.',
      date: '12 Mai',
      category: '12 MAI 2024',
      type: NotificationType.campaign,
      isRead: true,
    ),

    NotificationItem(
      title: 'Mise à jour disponible',
      description: 'De nouvelles fonctionnalités Kiyanza sont disponibles. Découvrez-les !',
      date: '12 Mai',
      category: '12 MAI 2024',
      type: NotificationType.update,
      isRead: true,
    ),
  ];

  // ===========================================================
  // FILTRAGE
  // ===========================================================

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 1) {
      return _notifications
          .where((notification) => !notification.isRead)
          .toList();
    }

    if (_selectedFilter == 2) {
      return _notifications
          .where((notification) => notification.isMention)
          .toList();
    }

    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            _buildHeader(),

            // =================================================
            // FILTRES
            // =================================================
            _buildFilters(),

            const SizedBox(height: 10),

            // =================================================
            // NOTIFICATIONS
            // =================================================
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(notifications),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),

      child: Row(
        children: [
          // Retour
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.chevron_left,
                size: 19,
                color: AppColors.white,
              ),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: AppSizes.text12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          // Filtre
          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.tune, size: 15, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // FILTRES
  // ===========================================================

  Widget _buildFilters() {
    final filters = ['Toutes', 'Non lues', 'Mentions'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: Row(
        children: List.generate(filters.length, (index) {
          final bool selected = _selectedFilter == index;

          return Padding(
            padding: const EdgeInsets.only(right: 7),

            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = index;
                });
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: selected ? AppColors.green : AppColors.gray100,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  filters[index],

                  style: TextStyle(
                    fontSize: 8,

                    fontWeight: FontWeight.w600,

                    color: selected
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================
  // LISTE
  // ===========================================================

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),

      itemCount: notifications.length,

      itemBuilder: (context, index) {
        final notification = notifications[index];

        final bool showCategory =
            index == 0 ||
            notifications[index - 1].category != notification.category;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            if (showCategory)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),

                child: Text(
                  notification.category,

                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray500,
                  ),
                ),
              ),

            _buildNotificationCard(notification),
          ],
        );
      },
    );
  }

  // ===========================================================
  // NOTIFICATION
  // ===========================================================

  Widget _buildNotificationCard(NotificationItem notification) {
    return GestureDetector(
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
      },

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.only(bottom: 6),

        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 7),

        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.white : AppColors.gray500,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Icône
            _buildNotificationIcon(notification.type),

            const SizedBox(width: 9),

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          notification.title,

                          style: TextStyle(
                            fontSize: 9,

                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,

                            color: AppColors.black,
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        notification.date,

                        style: const TextStyle(
                          fontSize: 6,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    notification.description,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 7,
                      height: 1.3,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // ICÔNE NOTIFICATION
  // ===========================================================

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.report:
        icon = Icons.description_outlined;
        color = AppColors.blue;
        break;

      case NotificationType.success:
        icon = Icons.check_circle_outline;
        color = AppColors.green;
        break;

      case NotificationType.ai:
        icon = Icons.auto_awesome;
        color = AppColors.blue;
        break;

      case NotificationType.campaign:
        icon = Icons.campaign_outlined;
        color = AppColors.green;
        break;

      case NotificationType.update:
        icon = Icons.system_update_alt;
        color = AppColors.blue;
        break;
    }

    return Container(
      width: 28,
      height: 28,

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        shape: BoxShape.circle,
      ),

      child: Icon(icon, size: 14, color: color),
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.notifications_none,
              color: AppColors.gray400,
              size: 22,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Aucune notification pour l’instant',

            style: TextStyle(fontSize: 9, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// MODEL
// =============================================================

enum NotificationType { report, success, ai, campaign, update }

class NotificationItem {
  final String title;
  final String description;
  final String date;
  final String category;
  final NotificationType type;

  bool isRead;
  bool isMention;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.type,
    required this.isRead,
    this.isMention = false,
  });
}
