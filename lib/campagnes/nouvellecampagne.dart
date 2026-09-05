import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campaign_step_dots.dart';
import 'campaign_type_screen.dart';

class NewCampaignScreen extends StatelessWidget {
  const NewCampaignScreen({super.key});

  // ===========================================================
  // DATA
  // ===========================================================

  static final List<_IntroBenefit> _benefits = [
    _IntroBenefit(
      icon: Icons.schedule,
      title: 'Simulation intelligente',
      description: 'Nous vous recommandons la meilleure stratégie',
    ),
    _IntroBenefit(
      icon: Icons.share,
      title: 'Canaux multiples',
      description: 'Touchez votre audience partout',
    ),
    _IntroBenefit(
      icon: Icons.show_chart,
      title: 'Suivi en temps réel',
      description: 'Analysez et optimisez vos performances',
    ),
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
            // STEP DOTS
            // =================================================
            const CampaignStepDots(currentStep: 0),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(child: _buildContent()),

            // =================================================
            // BOUTON COMMENCER
            // =================================================
            _buildStartButton(context),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.black,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Nouvelle campagne',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          const SizedBox(width: 22),
        ],
      ),
    );
  }

  // ===========================================================
  // CONTENU
  // ===========================================================

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Illustration
          Container(
            width: double.infinity,
            height: 160,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(Icons.insights, size: 64, color: AppColors.green),
          ),

          const SizedBox(height: 24),

          const Text(
            'Créez votre campagne\nen quelques étapes',

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Nous allons vous guider pour configurer votre campagne et obtenir les meilleurs résultats.',

            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray400,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 28),

          ..._benefits.map(_buildBenefitRow),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(_IntroBenefit benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(benefit.icon, size: 20, color: AppColors.black),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  benefit.title,

                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  benefit.description,

                  style: const TextStyle(
                    fontSize: 12,
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

  // ===========================================================
  // BOUTON COMMENCER
  // ===========================================================

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CampaignTypeScreen()),
            );
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),

            elevation: 0,
          ),

          child: const Text(
            'Commencer',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// MODEL
// =============================================================

class _IntroBenefit {
  final IconData icon;
  final String title;
  final String description;

  _IntroBenefit({
    required this.icon,
    required this.title,
    required this.description,
  });
}
