import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';
//import '../../core/theme/kiyanza_sizes.dart';
import '../../IA/ia_report_analyse.dart';
import 'app_menu.dart';
import '../../campagnes/campagne.dart';
import '../../../monitoring_radio/monitoring.dart';
import '../notification/notification.dart';
import '../mon_profil/profil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ===========================================================
  // DATA
  // ===========================================================

  static final List<_StatTile> _stats = [
    _StatTile(
      icon: Icons.bar_chart,
      color: AppColors.blue,
      label: 'Dépenses',
      value: '2,45M',
      suffix: 'FCFA',
      growth: '↗ 18%',
    ),
    _StatTile(
      icon: Icons.trending_up,
      color: const Color(0xFFFF6A00),
      label: 'Conversions',
      value: '1 240',
      growth: '↗ 22%',
    ),
    _StatTile(
      icon: Icons.attach_money,
      color: AppColors.green,
      label: 'ROI estimé',
      value: '320%',
      growth: '↗ 15%',
    ),
    _StatTile(
      icon: Icons.groups_outlined,
      color: const Color(0xFF7C3AED),
      label: 'Audiences',
      value: '82,6K',
      growth: '↗ 12%',
    ),
  ];

  static final List<_QuickAction> _quickActions = [
    _QuickAction(icon: Icons.campaign_outlined, label: 'Campagnes'),
    _QuickAction(icon: Icons.monitor_heart_outlined, label: 'Monitoring'),
    _QuickAction(icon: Icons.menu_book_outlined, label: 'Rapports'),
    _QuickAction(icon: Icons.more_horiz, label: 'Voir tout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // =========================================
                // HEADER
                // =========================================

                _buildHeader(context),

                // =========================================
                // CONTENU
                // =========================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        _buildGreeting(),

                        const SizedBox(height: 20),

                        _buildOverviewCard(),

                        const SizedBox(height: 16),

                        _buildAiRecommendationCard(context),

                        const SizedBox(height: 20),

                        _buildQuickActionsSection(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =============================================
            // BOUTON IA FLOTTANT
            // =============================================
            Positioned(
              right: 16,
              bottom: 78,

              child: _buildAiFloatingButton(context),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 2)),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppMenuScreen()),
              );
            },

            child: const Icon(Icons.menu, size: 24, color: AppColors.black),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },

            child: Stack(
              clipBehavior: Clip.none,

              children: [
                Container(
                  width: 40,
                  height: 40,

                  decoration: const BoxDecoration(
                    color: AppColors.gray100,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.notifications_none,
                    size: 22,
                    color: AppColors.black,
                  ),
                ),

                Positioned(
                  top: -2,
                  right: -2,

                  child: Container(
                    width: 18,
                    height: 18,

                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6900),
                      shape: BoxShape.circle,
                    ),

                    child: const Center(
                      child: Text(
                        '3',

                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },

            child: Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: const CircleAvatar(
                backgroundColor: AppColors.gray100,

                child: Icon(Icons.person, color: AppColors.gray400, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // SALUTATION
  // ===========================================================

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'Bonjour Aristide !',

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Voici ce qui se passe aujourd'hui sur vos campagnes.",

          style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
        ),
      ],
    );
  }

  // ===========================================================
  // VUE D'ENSEMBLE
  // ===========================================================

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "Vue d'ensemble",

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: const [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: AppColors.gray400,
                    ),

                    SizedBox(width: 6),

                    Text(
                      'Cette semaine',

                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.gray400,
                      ),
                    ),

                    SizedBox(width: 4),

                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 12,
                      color: AppColors.gray400,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: _stats
                .map(
                  (stat) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildStatTile(stat),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(_StatTile stat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 32,
          height: 32,

          decoration: BoxDecoration(color: stat.color, shape: BoxShape.circle),

          child: Icon(stat.icon, size: 16, color: AppColors.white),
        ),

        const SizedBox(height: 4),

        Text(
          stat.label,

          style: const TextStyle(fontSize: 10, color: Color(0xFF99A1AF)),
        ),

        const SizedBox(height: 2),

        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,

          children: [
            Text(
              stat.value,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),

            if (stat.suffix != null) ...[
              const SizedBox(width: 3),

              Text(
                stat.suffix!,

                style: const TextStyle(fontSize: 9, color: Color(0xFF99A1AF)),
              ),
            ],
          ],
        ),

        const SizedBox(height: 2),

        Text(
          stat.growth,

          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00C950),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // RECOMMANDATION IA
  // ===========================================================

  Widget _buildAiRecommendationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, size: 18, color: Color(0xFF155DFC)),

              SizedBox(width: 8),

              Text(
                'Recommandation IA',

                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF155DFC),
                ),
              ),

              Spacer(),

              Icon(Icons.more_horiz, size: 16, color: AppColors.gray400),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                          height: 1.3,
                        ),

                        children: [
                          TextSpan(text: 'Réallouez '),
                          TextSpan(
                            text: '20%',
                            style: TextStyle(color: Color(0xFF2563EB)),
                          ),
                          TextSpan(text: ' de votre budget vers '),
                          TextSpan(
                            text: 'WhatsApp Ads',
                            style: TextStyle(color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray500,
                        ),

                        children: [
                          TextSpan(text: 'Prévision : '),
                          TextSpan(
                            text: '+28% de conversions',
                            style: TextStyle(
                              color: Color(0xFF00A63E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' avec le même budget'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 40,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AiReportAnalysisScreen(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),

                          elevation: 0,
                        ),

                        child: const Text(
                          'Voir la recommandation',

                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 64,
                height: 64,

                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.chat,
                  size: 30,
                  color: Color(0xFF25D366),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ACTIONS RAPIDES
  // ===========================================================

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'Actions rapides',

          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: List.generate(_quickActions.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == _quickActions.length - 1 ? 0 : 8,
                ),

                child: _buildQuickActionCard(context, _quickActions[index]),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(BuildContext context, _QuickAction action) {
    return GestureDetector(
      onTap: () {
        switch (action.label) {
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

          case 'Rapports':
            // TODO: brancher l'écran Rapports une fois disponible
            break;

          case 'Voir tout':
            // TODO: naviguer vers la liste complète des actions
            break;
        }
      },

      child: Container(
        padding: const EdgeInsets.all(8),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(action.icon, size: 22, color: const Color(0xFF364153)),

            const SizedBox(height: 8),

            Text(
              action.label,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF364153),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // BOUTON IA FLOTTANT
  // ===========================================================

  Widget _buildAiFloatingButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AiReportAnalysisScreen()),
        );
      },

      child: Container(
        width: 48,
        height: 48,

        decoration: BoxDecoration(
          color: AppColors.blue,
          shape: BoxShape.circle,

          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: const Icon(Icons.auto_awesome, size: 20, color: AppColors.white),
      ),
    );
  }

  // ===========================================================
  // BOTTOM NAV
  // ===========================================================

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 2)),
      ),

      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          _buildNavItem(Icons.home, 'Accueil', true),

          GestureDetector(
            onTap: () {
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
            },

            child: _buildNavItem(Icons.campaign_outlined, 'Campagnes', false),
          ),

          Transform.translate(
            offset: const Offset(0, -14),

            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MonitoringScreen()),
                );
              },

              child: Container(
                width: 48,
                height: 48,

                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.dashboard_outlined,
                  size: 22,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          _buildNavItem(Icons.lightbulb_outline, 'Recom....', false),
          _buildNavItem(Icons.search, 'Rechercher', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool selected) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Icon(
          icon,
          size: 22,
          color: selected ? AppColors.green : AppColors.gray400,
        ),

        const SizedBox(height: 3),

        Text(
          label,

          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.green : AppColors.gray400,
          ),
        ),
      ],
    );
  }
}

// =============================================================
// MODELS
// =============================================================

class _StatTile {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String? suffix;
  final String growth;

  _StatTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.suffix,
    required this.growth,
  });
}

class _QuickAction {
  final IconData icon;
  final String label;

  _QuickAction({required this.icon, required this.label});
}
