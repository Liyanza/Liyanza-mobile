import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'radio_spot_screen.dart';
import 'radio_step_header.dart';

class RadioCampaignDetailsScreen extends StatefulWidget {
  const RadioCampaignDetailsScreen({super.key});

  @override
  State<RadioCampaignDetailsScreen> createState() =>
      _RadioCampaignDetailsScreenState();
}

class _RadioCampaignDetailsScreenState
    extends State<RadioCampaignDetailsScreen> {
  final TextEditingController _budgetController = TextEditingController(
    text: '100 000',
  );

  String _objective = 'Notoriété';
  String _zone = 'Nationale';
  String _target = 'Hommes et Femmes, 18-45 ans';
  String _startDate = '25 mai 2024';
  String _endDate = '25 juin 2024';

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER + PROGRESSION
            // =================================================

            const RadioStepHeader(
              title: 'Nouvelle campagne radio',
              step: 2,
              totalSteps: 5,
            ),

            // =================================================
            // FORMULAIRE
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _buildFieldLabel('Objectif de la campagne'),
                    const SizedBox(height: 6),
                    _buildSelectField(
                      value: _objective,
                      highlighted: true,
                      onTap: () {
                        // TODO: ouvrir le sélecteur d'objectif
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildFieldLabel('Budget total'),
                    const SizedBox(height: 6),
                    _buildBudgetField(),

                    const SizedBox(height: 16),

                    _buildFieldLabel('Période de diffusion'),
                    const SizedBox(height: 6),
                    _buildDateRangeField(),

                    const SizedBox(height: 16),

                    _buildFieldLabel('Zone de diffusion'),
                    const SizedBox(height: 6),
                    _buildSelectField(
                      value: _zone,
                      highlighted: true,
                      onTap: () {
                        // TODO: ouvrir le sélecteur de zone
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildFieldLabel('Cible principale'),
                    const SizedBox(height: 6),
                    _buildSelectField(
                      value: _target,
                      highlighted: false,
                      onTap: () {
                        // TODO: ouvrir le sélecteur de cible
                      },
                    ),
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
  // LABEL DE CHAMP
  // ===========================================================

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),

      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: AppColors.gray400,
        letterSpacing: 0.3,
      ),
    );
  }

  // ===========================================================
  // CHAMP SÉLECTION (dropdown-style)
  // ===========================================================

  Widget _buildSelectField({
    required String value,
    required bool highlighted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: highlighted
                ? const Color(0xFF7EA6E7)
                : const Color(0xFFE5E7EB),
            width: 1.2,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              value,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // CHAMP BUDGET
  // ===========================================================

  Widget _buildBudgetField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7EA6E7), width: 1.2),
      ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),

          const Text(
            'FCFA',

            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // CHAMP PÉRIODE (Du / Au)
  // ===========================================================

  Widget _buildDateRangeField() {
    return Row(
      children: [
        Expanded(child: _buildDateBox('Du', _startDate)),
        const SizedBox(width: 8),
        Expanded(child: _buildDateBox('Au', _endDate)),
      ],
    );
  }

  Widget _buildDateBox(String label, String date) {
    return GestureDetector(
      onTap: () {
        // TODO: ouvrir le sélecteur de date
      },

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF7EA6E7), width: 1.2),
        ),

        child: Row(
          children: [
            Text(
              label,

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.gray400,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                date,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

      child: SizedBox(
        width: double.infinity,
        height: 53,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RadioSpotScreen()),
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
