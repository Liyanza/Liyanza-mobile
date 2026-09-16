import 'package:flutter/material.dart';

import '../theme/kiyanza_colors.dart';
import '../../campagnes/campaign_type_screen.dart';
import '../../simulation/simulation.dart';
import '../../../monitoring_radio/monitoring.dart';

// =================================================================
// BOTTOM SHEET — "Que souhaitez-vous faire ?"
// Ouverte par le bouton central (vert) de la bottom nav, fidèle
// à la maquette Figma "Menu 2".
// =================================================================
Future<void> showQuickActionsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (context) => const _QuickActionsSheet(),
  );
}

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // Titre + fermer
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Que souhaitez-vous faire ?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _QuickActionTile(
                    icon: Icons.campaign_outlined,
                    title: 'Nouvelle campagne',
                    subtitle: 'Créer et lancer une campagne',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CampaignTypeScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _QuickActionTile(
                    icon: Icons.lightbulb_outline,
                    title: 'Scénarios IA',
                    subtitle: 'Comparer des stratégies',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SimulationScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _QuickActionTile(
                    icon: Icons.monitor_heart_outlined,
                    title: 'Monitoring',
                    subtitle: 'Suivre vos performances',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MonitoringScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _QuickActionTile(
                    icon: Icons.menu_book_outlined,
                    title: 'Rapports',
                    subtitle: 'Générer un rapport',
                    // TODO: brancher l'écran Rapports une fois disponible
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Annuler
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
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

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 22, color: AppColors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }
}
