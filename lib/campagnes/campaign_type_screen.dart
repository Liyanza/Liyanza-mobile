import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campaign_objective_screen.dart';

class CampaignTypeScreen extends StatelessWidget {
  const CampaignTypeScreen({super.key});

  // ===========================================================
  // DATA
  // ===========================================================

  static final List<_CampaignTypeOption> _types = [
    _CampaignTypeOption(
      icon: Icons.desktop_windows_outlined,
      title: 'Campagne Digitale',
      description: 'Facebook, Instagram, Google Ads & Email',
    ),
    _CampaignTypeOption(
      icon: Icons.radio_outlined,
      title: 'Campagne Radio',
      description: 'Diffusion sur les radios locales et nationales',
    ),
    _CampaignTypeOption(
      icon: Icons.desktop_windows_outlined,
      title: 'Supports Publicitaires',
      description: 'Affiches, bâches, roll-ups, street marketing',
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
            // CONTENU
            // =================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Quel type de campagne souhaitez-vous créer ?',

                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.gray500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ..._types.map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildTypeCard(context, type),
                      ),
                    ),

                    const SizedBox(height: 8),

                    _buildComboHint(),
                  ],
                ),
              ),
            ),
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 32,
              height: 32,

              decoration: const BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: AppColors.black,
              ),
            ),
          ),

          const SizedBox(width: 12),

          const Text(
            'Nouvelle campagne',

            style: TextStyle(
              fontSize: AppSizes.text16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // CARTE TYPE DE CAMPAGNE
  // ===========================================================

  Widget _buildTypeCard(BuildContext context, _CampaignTypeOption type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CampaignObjectiveScreen()),
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gray100, width: 1),
              ),

              child: Icon(type.icon, size: 24, color: AppColors.black),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    type.title,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    type.description,

                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.gray500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              size: 14,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // ENCART D'INFO
  // ===========================================================

  Widget _buildComboHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue, width: 1.2),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 28,
            height: 28,

            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.info_outline,
              size: 14,
              color: AppColors.blue,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Combinez plusieurs types de campagnes pour maximiser votre impact. Une campagne radio + supports publicitaires crée une présence forte.',

              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// MODEL
// =============================================================

class _CampaignTypeOption {
  final IconData icon;
  final String title;
  final String description;

  _CampaignTypeOption({
    required this.icon,
    required this.title,
    required this.description,
  });
}
