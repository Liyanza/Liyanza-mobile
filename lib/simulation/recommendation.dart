import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';
import '../core/theme/kiyanza_sizes.dart';
import '../core/widget/bottom_navigation.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================
      bottomNavigationBar: KiyanzaBottomNavigation(
        currentIndex: 2,
        onItemSelected: (index) {
          // Navigation à gérer plus tard
        },
      ),

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
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),

                child: Column(
                  children: [
                    // Carte Kiyanza IA
                    const _KiyanzaAiCard(),

                    const SizedBox(height: 14),

                    // Recommandation Facebook
                    const _RecommendationCard(
                      icon: Icons.facebook,
                      iconColor: Color(0xFF1877F2),
                      title: 'Augmenter le budget sur Facebook Ads',
                      description: 'Augmenter de 20% votre budget Facebook pour générer plus de conversions.',
                    ),

                    const SizedBox(height: 12),

                    // Recommandation Instagram
                    const _RecommendationCard(
                      icon: Icons.camera_alt_outlined,
                      iconColor: Color(0xFFE1306C),
                      title: 'Optimiser les visuels Instagram',
                      description: 'Utilisez des visuels plus engageants pour améliorer le taux de clic.',
                    ),

                    const SizedBox(height: 12),

                    // Recommandation TikTok
                    const _RecommendationCard(
                      icon: Icons.music_note,
                      iconColor: AppColors.black,
                      title: 'Tester un nouveau canal',
                      description: 'Nous recommandons d’ajouter TikTok Ads pour toucher une nouvelle audience.',
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOUTON APPLIQUER
            // =================================================
            _buildApplyButton(context),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 17,
              color: AppColors.black,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Recommandations IA',

                style: TextStyle(
                  fontSize: AppSizes.text14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          // Pour garder le titre parfaitement centré
          const SizedBox(width: 17),
        ],
      ),
    );
  }

  // ===========================================================
  // BOUTON APPLIQUER
  // ===========================================================

  Widget _buildApplyButton(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),

      child: SizedBox(
        height: 48,

        child: ElevatedButton(
          onPressed: () {
            // TODO:
            // Appliquer les recommandations au scénario
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,

            foregroundColor: AppColors.white,

            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          child: const Text(
            'Appliquer les recommandations',

            style: TextStyle(
              fontSize: AppSizes.text12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// CARTE KIYANZA IA
// =============================================================

class _KiyanzaAiCard extends StatelessWidget {
  const _KiyanzaAiCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFF0F0F0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // Icone IA
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.12),

              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.blue,
              size: 19,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'KIYANZA IA',

                  style: TextStyle(
                    fontSize: AppSizes.text12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Voici nos recommandations pour améliorer\n'
                  'les performances de vos campagnes.',

                  style: TextStyle(
                    fontSize: AppSizes.text10,
                    height: 1.4,
                    color: AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// CARTE RECOMMANDATION
// =============================================================

class _RecommendationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _RecommendationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFF0F0F0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ===================================================
          // ICONE
          // ===================================================

          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),

              borderRadius: BorderRadius.circular(9),
            ),

            child: Icon(icon, size: 16, color: iconColor),
          ),

          const SizedBox(width: 12),

          // ===================================================
          // TEXTE
          // ===================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: AppSizes.text12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,

                  style: const TextStyle(
                    fontSize: AppSizes.text10,
                    height: 1.4,
                    color: AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
