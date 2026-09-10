import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';
import '../../campagnes/campagne.dart';
import '../../../monitoring_radio/monitoring.dart';
import '../notification/notification.dart';

class AppMenuScreen extends StatelessWidget {
  const AppMenuScreen({super.key});

  // ===========================================================
  // DATA
  // ===========================================================

  static final List<_MenuItem> _mainItems = [
    _MenuItem(icon: Icons.home_outlined, label: 'Accueil'),
    _MenuItem(icon: Icons.campaign_outlined, label: 'Campagnes'),
    _MenuItem(icon: Icons.monitor_heart_outlined, label: 'Monitoring'),
    _MenuItem(icon: Icons.lightbulb_outline, label: 'Recommandations'),
    _MenuItem(icon: Icons.menu_book_outlined, label: 'Rapports'),
    _MenuItem(icon: Icons.calendar_today_outlined, label: 'Calendrier'),
  ];

  static final List<_MenuItem> _settingsItems = [
    _MenuItem(icon: Icons.notifications_none, label: 'Notifications'),
    _MenuItem(icon: Icons.help_outline, label: 'Aide'),
    _MenuItem(icon: Icons.settings_outlined, label: 'Paramètres'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            _buildHeader(context),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ..._mainItems.map((item) => _buildMenuRow(context, item)),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),

                      child: Text(
                        'PARAMÈTRES',

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray400,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ..._settingsItems.map(
                      (item) => _buildMenuRow(context, item),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // PROFIL (footer)
            // =================================================
            _buildProfileFooter(context),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.eco_outlined,
              size: 18,
              color: AppColors.white,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Menu',

              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 34,
              height: 34,

              decoration: const BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),

              child: const Icon(Icons.close, size: 18, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // LIGNE DE MENU
  // ===========================================================

  Widget _buildMenuRow(BuildContext context, _MenuItem item) {
    final bool active = item.label == 'Accueil';

    return GestureDetector(
      onTap: () => _handleTap(context, item.label),

      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFFDF4) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: active ? AppColors.green : AppColors.gray500,
            ),

            const SizedBox(width: 14),

            Text(
              item.label,

              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? AppColors.green : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // NAVIGATION
  // ===========================================================
  //
  // Chaque entrée du menu doit rester présente : d'autres écrans
  // s'appuient sur ce point d'entrée (drawer / bouton menu du header).
  // Ne pas retirer d'item sans vérifier les usages ailleurs dans l'app.

  void _handleTap(BuildContext context, String label) {
    switch (label) {
      case 'Accueil':
        Navigator.popUntil(context, (route) => route.isFirst);
        break;

      case 'Campagnes':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CampaignsScreen(
              onOpenMenu: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        break;

      case 'Monitoring':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MonitoringScreen()),
        );
        break;

      case 'Notifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        break;

      case 'Recommandations':
      case 'Rapports':
      case 'Calendrier':
      case 'Aide':
      case 'Paramètres':
        // TODO: brancher ces écrans une fois disponibles dans le Figma.
        break;
    }
  }

  // ===========================================================
  // PROFIL
  // ===========================================================

  Widget _buildProfileFooter(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: naviguer vers l'écran de profil / workspace
      },

      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.white,

              child: Icon(Icons.person, color: AppColors.gray400),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Aristide Nna',

                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    'Entreprise / Workspace',

                    style: TextStyle(fontSize: 11, color: AppColors.gray400),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 18, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// MODEL
// =============================================================

class _MenuItem {
  final IconData icon;
  final String label;

  _MenuItem({required this.icon, required this.label});
}
