import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/account_providers.dart';
import '../../data/models/account/account_models.dart';

import '../../core/theme/kiyanza_colors.dart';
import '../../monitoring_radio/monitoring.dart';
import '../../features/notification/notification.dart';
import '../../features/mon_profil/profil.dart';

// =================================================================
// TIROIR LATÉRAL (Drawer) — fidèle à la maquette Figma "Menu"
//
// Utilisation : posé comme `drawer:` du Scaffold de
// MainNavigationScreen, ouvert via un GlobalKey<ScaffoldState>
// depuis le bouton central de la bottom nav et depuis les icônes
// ☰ de chaque écran (HomeScreen, CampaignsScreen...).
// =================================================================
class KiyanzaDrawer extends StatelessWidget {
  // Index de l'onglet actif dans MainNavigationScreen
  // (0 Accueil, 1 Campagnes, 2 Recommandations) pour surligner
  // le bon item, comme "Accueil" en vert sur la maquette.
  final int currentIndex;

  // Permet de changer d'onglet dans MainNavigationScreen.
  final void Function(int index) onSelectTab;

  const KiyanzaDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.sizeOf(context).width * 0.84;

    return Drawer(
      width: drawerWidth.clamp(280.0, 320.0),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Accueil',
                    selected: currentIndex == 0,
                    pill: true,
                    onTap: () {
                      Navigator.pop(context);
                      onSelectTab(0);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.campaign_outlined,
                    label: 'Campagnes',
                    selected: currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      onSelectTab(1);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.monitor_heart_outlined,
                    label: 'Monitoring',
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MonitoringScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.lightbulb_outline,
                    label: 'Recommandations',
                    selected: currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      onSelectTab(2);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
                    child: Text(
                      'PARAMÈTRES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: AppColors.gray400,
                      ),
                    ),
                  ),

                  _DrawerItem(
                    icon: Icons.notifications_none,
                    label: 'Notifications',
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    label: 'Mon profil',
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5),
        ),
      ),

      child: Row(
        children: [
          // Logo — si l'asset n'existe pas encore, repli automatique.
          Image.asset(
            'assets/images/logo_couleur.png',
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, size: 18, color: AppColors.white),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // CARTE PROFIL (pied du tiroir)
  // ===========================================================

  Widget _buildProfileFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border.all(color: const Color(0xFFF0F0F0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.gray100,
                child: Icon(Icons.person, color: AppColors.gray400, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final account = ref.watch(accountProvider).valueOrNull;
                    final profile = account?.profile;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile == null
                              ? 'Mon profil'
                              : (profile.fullName.isNotEmpty ? profile.fullName : profile.email),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF101828),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          account?.company?.name ?? (profile != null ? userRoleLabel(profile.role) : ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: AppColors.gray400),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// ITEM DE LISTE DU TIROIR
// =================================================================
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool selected;
  final bool pill;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.selected,
    this.pill = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = selected
        ? const Color(0xFF16A34A)
        : const Color(0xFF374151);

    final double radius = pill && selected ? 100 : 12;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected ? const Color(0xFFF0FDF4) : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  selected && activeIcon != null ? activeIcon : icon,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
