import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';

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
      description: 'Le rapport hebdomadaire de la campagne « Promo Orange Money » est prêt.',
      date: '10:30',
      category: "AUJOURD'HUI",
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
      description: 'Kiyanza IA a une recommandation pour optimiser votre budget Facebook Ads.',
      date: 'Hier',
      category: 'HIER',
      type: NotificationType.ai,
      isRead: false,
      isMention: true,
    ),

    NotificationItem(
      title: 'Campagne en pause',
      description: 'La campagne « Offre Spéciale Été » a été automatiquement mise en pause.',
      date: '12 Mai',
      category: '12 MAI 2024',
      type: NotificationType.campaign,
      isRead: true,
    ),

    NotificationItem(
      title: 'Mise à jour disponible',
      description: 'De nouvelles fonctionnalités KIYANZA sont disponibles. Découvrez-les !',
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.2),
        ),
      ),

      child: Row(
        children: [
          // Retour
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 32,
              height: 32,

              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.chevron_left,
                size: 20,
                color: Color(0xFF111827),
              ),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),

          // Filtre
          Container(
            width: 32,
            height: 32,

            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.tune, size: 16, color: Color(0xFF111827)),
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            final bool selected = _selectedFilter == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = index;
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: selected ? AppColors.green : const Color(0xFFF3F4F6),
                    border: selected
                        ? null
                        : Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(100),
                  ),

                  child: Text(
                    filters[index],

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.white
                          : const Color(0xFF374151),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ===========================================================
  // LISTE
  // ===========================================================

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

                child: Text(
                  notification.category,

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF9CA3AF),
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

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF9FAFB), width: 1.2),
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Icône
            _buildNotificationIcon(notification.type),

            const SizedBox(width: 12),

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

                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      Row(
                        children: [
                          if (!notification.isRead) ...[
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 4, top: 3),
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                          Text(
                            notification.date,

                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    notification.description,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF6B7280),
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
    late final Color bgColor;
    late final Widget child;

    switch (type) {
      case NotificationType.report:
        bgColor = const Color(0xFFEFF6FF);
        child = const Icon(
          Icons.description_outlined,
          size: 18,
          color: AppColors.blue,
        );
        break;

      case NotificationType.success:
        bgColor = const Color(0xFFFFFBEB);
        child = const Icon(
          Icons.check_circle_outline,
          size: 18,
          color: Color(0xFFCA8A04),
        );
        break;

      case NotificationType.ai:
        // Sur la maquette, la notif IA affiche un badge bleu plein
        // avec l'initiale "K" (Kiyanza) plutôt qu'une icône générique.
        bgColor = AppColors.blue;
        child = const Text(
          'K',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        );
        break;

      case NotificationType.campaign:
        bgColor = const Color(0xFFFFF7ED);
        child = const Icon(
          Icons.campaign_outlined,
          size: 18,
          color: Color(0xFFEA580C),
        );
        break;

      case NotificationType.update:
        bgColor = const Color(0xFFF9FAFB);
        child = const Icon(Icons.restore, size: 18, color: Color(0xFF6B7280));
        break;
    }

    return Container(
      width: 40,
      height: 40,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),

      child: child,
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
            width: 56,
            height: 56,

            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.notifications_none,
              color: Color(0xFF9CA3AF),
              size: 26,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "Aucune notification pour l'instant",

            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
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
