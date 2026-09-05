import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campaign_step_dots.dart';

class CampaignAudienceScreen extends StatefulWidget {
  const CampaignAudienceScreen({super.key});

  @override
  State<CampaignAudienceScreen> createState() =>
      _CampaignAudienceScreenState();
}

class _CampaignAudienceScreenState extends State<CampaignAudienceScreen> {
  String _age = '18 - 35 ans';
  String _gender = 'Tous';
  String _location = 'Yaoundé, Douala';

  final List<String> _interests = ['Technologie', 'Mode', 'Sport'];

  // ===========================================================
  // ACTIONS
  // ===========================================================

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

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

            const CampaignStepDots(currentStep: 2),

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
                      'Qui souhaitez-vous atteindre ?',

                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildSectionLabel('Démographie'),

                    const SizedBox(height: 10),

                    _buildDemographicsCard(),

                    const SizedBox(height: 20),

                    _buildSectionLabel('Intérêts'),

                    const SizedBox(height: 10),

                    _buildInterestsCard(),
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
                'Votre audience',

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
  // LABEL DE SECTION
  // ===========================================================

  Widget _buildSectionLabel(String label) {
    return Text(
      label,

      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: AppColors.gray500,
      ),
    );
  }

  // ===========================================================
  // CARTE DÉMOGRAPHIE
  // ===========================================================

  Widget _buildDemographicsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        children: [
          _buildDemographicsRow('Âge', _age, showBorder: true),
          _buildDemographicsRow('Genre', _gender, showBorder: true),
          _buildDemographicsRow('Localisation', _location, showBorder: false),
        ],
      ),
    );
  }

  Widget _buildDemographicsRow(
    String label,
    String value, {
    required bool showBorder,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: ouvrir le sélecteur correspondant (âge, genre, localisation)
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          border: showBorder
              ? const Border(
                  bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.2),
                )
              : null,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              label,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.gray500,
              ),
            ),

            Row(
              children: [
                Text(
                  value,

                  style: const TextStyle(fontSize: 13, color: AppColors.gray400),
                ),

                const SizedBox(width: 6),

                const Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // CARTE INTÉRÊTS
  // ===========================================================

  Widget _buildInterestsCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Ajouter des centres d’intérêt',

            style: TextStyle(fontSize: 12, color: AppColors.gray400),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,

            children: [
              ..._interests.map(_buildInterestChip),
              _buildAddInterestButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            interest,

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray500,
            ),
          ),

          const SizedBox(width: 6),

          GestureDetector(
            onTap: () => _removeInterest(interest),

            child: const Icon(Icons.close, size: 12, color: AppColors.gray400),
          ),
        ],
      ),
    );
  }

  Widget _buildAddInterestButton() {
    return GestureDetector(
      onTap: () {
        // TODO: ouvrir le sélecteur de centres d'intérêt
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
            width: 1.2,
            style: BorderStyle.solid,
          ),
        ),

        child: const Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.add, size: 11, color: AppColors.gray400),

            SizedBox(width: 4),

            Text(
              'Ajouter',

              style: TextStyle(fontSize: 12, color: AppColors.gray400),
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
            // TODO: navigation vers l'étape suivante (budget / récapitulatif)
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
