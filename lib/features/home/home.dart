import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import '../../../core/widget/bottom_navigation.dart';
import '../notification/notification.dart';
import '../../campagnes/campagne.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(bottom: false, child: _buildHome()),

      bottomNavigationBar: KiyanzaBottomNavigation(
        currentIndex: _currentIndex,

        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // ===========================================================
  // HOME
  // ===========================================================

  Widget _buildHome() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =====================================================
          // HEADER
          // =====================================================

          _buildHeader(),

          const SizedBox(height: 12),

          // =====================================================
          // BIENVENUE
          // =====================================================
          const Text(
            'Bonjour Leane !',
            style: TextStyle(
              fontSize: AppSizes.text24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Voici ce qui se passe aujourd’hui \nsur vos campagnes.',
            style: TextStyle(
              fontSize: AppSizes.text14,
              color: AppColors.gray500,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 15),

          // =====================================================
          // VUE D'ENSEMBLE
          // =====================================================
          _buildOverviewCard(),

          const SizedBox(height: 14),

          // =====================================================
          // RECOMMANDATION IA
          // =====================================================
          _buildAIRecommendation(),

          const SizedBox(height: 16),

          // =====================================================
          // ACTIONS RAPIDES
          // =====================================================
          const Text(
            'Actions rapides',
            style: TextStyle(
              fontSize: AppSizes.text12,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 9),

          _buildQuickActions(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        // Menu
        IconButton(
          padding: EdgeInsets.zero,

          constraints: const BoxConstraints(minWidth: 35, minHeight: 35),

          onPressed: () {},

          icon: const Icon(Icons.menu, size: 23, color: AppColors.black),
        ),

        Row(
          children: [
            // Notifications
            Stack(
              clipBehavior: Clip.none,

              children: [
                Container(
                  width: 36,
                  height: 36,

                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,

                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      size: 21,
                      color: AppColors.gray600,
                    ),
                  ),
                ),

                Positioned(
                  right: -1,
                  top: -2,

                  child: Container(
                    width: 15,
                    height: 15,

                    decoration: const BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),

                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            // Avatar
            Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gray200,

                border: Border.all(color: AppColors.gray200, width: 1),
              ),

              child: const Icon(
                Icons.person,
                color: AppColors.gray600,
                size: 22,
              ),
            ),
          ],
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

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AppColors.gray200),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Titre + filtre
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                'Vue d’ensemble',
                style: TextStyle(
                  fontSize: AppSizes.text10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.gray500,
                    ),

                    SizedBox(width: 5),

                    Text(
                      'Cette semaine',
                      style: TextStyle(
                        fontSize: AppSizes.text10,
                        color: AppColors.gray600,
                      ),
                    ),

                    SizedBox(width: 4),

                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: AppColors.gray500,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===================================================
          // STATISTIQUES
          // ===================================================
          Row(
            children: [
              Expanded(
                child: _buildOverviewStat(
                  icon: Icons.bar_chart_rounded,
                  iconColor: AppColors.blue,
                  title: 'Dépenses',
                  value: '2,45M',
                  unit: 'FCFA',
                  evolution: '18%',
                ),
              ),

              Expanded(
                child: _buildOverviewStat(
                  icon: Icons.trending_up_rounded,
                  iconColor: AppColors.orange,
                  title: 'Conversions',
                  value: '1240',
                  unit: '',
                  evolution: '22%',
                ),
              ),

              Expanded(
                child: _buildOverviewStat(
                  icon: Icons.attach_money_rounded,
                  iconColor: AppColors.green,
                  title: 'ROI estimé',
                  value: '320%',
                  unit: '',
                  evolution: '15%',
                ),
              ),

              Expanded(
                child: _buildOverviewStat(
                  icon: Icons.groups_rounded,
                  iconColor: AppColors.blue,
                  title: 'Audiences',
                  value: '82,6K',
                  unit: '',
                  evolution: '12%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // STATISTIQUE
  // ===========================================================

  Widget _buildOverviewStat({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required String evolution,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 24,
          height: 24,

          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.10),
            shape: BoxShape.circle,
          ),

          child: Icon(icon, size: 14, color: iconColor),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: const TextStyle(
            fontSize: AppSizes.text10,
            color: AppColors.gray500,
          ),
        ),

        const SizedBox(height: 2),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: AppSizes.text12,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),

            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),

              Text(
                unit,
                style: const TextStyle(
                  fontSize: AppSizes.text10,
                  color: AppColors.gray500,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 2),

        Row(
          children: [
            const Icon(Icons.arrow_upward, size: 8, color: AppColors.green),

            Text(
              ' $evolution',
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================
  // RECOMMANDATION IA
  // ===========================================================

  Widget _buildAIRecommendation() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AppColors.gray200),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.blue, size: 12),

              const SizedBox(width: 5),

              const Text(
                'Recommandation IA',
                style: TextStyle(
                  fontSize: AppSizes.text12,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              const Icon(Icons.more_horiz, size: 15, color: AppColors.gray400),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: AppSizes.text24,
                          color: AppColors.black,
                          height: 1.2,
                        ),

                        children: [
                          TextSpan(
                            text: 'Réallouez ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),

                          TextSpan(
                            text: '20%',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          TextSpan(
                            text: ' de votre\nbudget vers ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),

                          TextSpan(
                            text: 'WhatsApp Ads',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'La campagne : +28% de conversions\navec le même budget',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.gray500,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 34,

                      child: ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: Colors.white,

                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          shape: const StadiumBorder(),

                          elevation: 0,
                        ),

                        child: const Text(
                          'Voir la recommandation',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =================================================
              // WHATSAPP
              // =================================================
              SizedBox(
                width: 82,
                height: 105,

                child: Center(
                  child: Image.asset('assets/images/whatsapp.png', width: 110),
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            padding: EdgeInsets.zero,

            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CampaignsScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.flag_outlined,
              color: AppColors.green,
              size: 24,
            ),

            color: AppColors.green,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.monitor_heart_outlined,
            title: 'Monitoring',
            color: AppColors.warning600,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.menu_book_outlined,
            title: 'Rapports',
            color: AppColors.green,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.more_horiz,
            title: 'Voir tout',
            color: AppColors.green,
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // QUICK ACTION
  // ===========================================================

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      height: 58,

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: AppColors.gray200),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, color: color, size: 19),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(fontSize: 7, color: AppColors.gray600),
          ),
        ],
      ),
    );
  }
}
