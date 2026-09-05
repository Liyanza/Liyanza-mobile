import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campaign_audience_screen.dart';
import 'campaign_step_dots.dart';

class CampaignObjectiveScreen extends StatefulWidget {
  const CampaignObjectiveScreen({super.key});

  @override
  State<CampaignObjectiveScreen> createState() =>
      _CampaignObjectiveScreenState();
}

class _CampaignObjectiveScreenState extends State<CampaignObjectiveScreen> {
  int _selectedIndex = 0; // 'Notoriété' sélectionné par défaut

  final List<_ObjectiveOption> _objectives = [
    _ObjectiveOption(
      icon: Icons.campaign_outlined,
      title: 'Notoriété',
      description: 'Faire connaître ma marque à un large public',
    ),
    _ObjectiveOption(
      icon: Icons.person_add_alt_outlined,
      title: 'Génération de prospects',
      description: 'Attirer de nouveaux clients potentiels',
    ),
    _ObjectiveOption(
      icon: Icons.call_made,
      title: 'Conversions',
      description: 'Inciter à une action spécifique (achat, inscription, etc.)',
    ),
    _ObjectiveOption(
      icon: Icons.favorite_border,
      title: 'Fidélisation',
      description: 'Renforcer la relation avec mes clients existants',
    ),
    _ObjectiveOption(
      icon: Icons.favorite_border,
      title: 'Autres',
      description: 'Decrivez votre objectifs',
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

            const CampaignStepDots(currentStep: 1),

            // =================================================
            // CONTENU
            // =================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Quel est l’objectif principal\nde votre campagne ?',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ...List.generate(_objectives.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildObjectiveCard(index),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOUTON CONTINUER
            // =================================================

            _buildContinueButton(context),
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
                'Objectif de la campagne',

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
  // CARTE OBJECTIF
  // ===========================================================

  Widget _buildObjectiveCard(int index) {
    final objective = _objectives[index];
    final bool selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: selected ? AppColors.blue : const Color(0xFFE5E7EB),
            width: 1.2,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(objective.icon, size: 20, color: AppColors.black),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    objective.title,

                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    objective.description,

                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.gray400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 20,
              height: 20,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.blue : AppColors.white,
                border: Border.all(
                  color: selected ? AppColors.blue : const Color(0xFFD1D5DB),
                  width: 1.2,
                ),
              ),

              child: selected
                  ? const Icon(Icons.circle, size: 8, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // BOUTON CONTINUER
  // ===========================================================

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CampaignAudienceScreen(),
              ),
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
            'Continuer',

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

class _ObjectiveOption {
  final IconData icon;
  final String title;
  final String description;

  _ObjectiveOption({
    required this.icon,
    required this.title,
    required this.description,
  });
}
