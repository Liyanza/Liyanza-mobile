import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import '../core/widget/bottom_navigation.dart';
import 'scenario_details.dart';

class SimulationResultsScreen extends StatelessWidget {
  const SimulationResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      bottomNavigationBar: KiyanzaBottomNavigation(
        currentIndex: 2,
        onItemSelected: (index) {},
      ),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  children: [
                    const SizedBox(height: 18),

                    // ========================================
                    // ICON
                    // ========================================
                    Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F8FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.blue),
                      ),

                      child: const Icon(
                        Icons.auto_awesome,
                        color: AppColors.blue,
                        size: 22,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ========================================
                    // TITRE
                    // ========================================
                    const Text(
                      'Simulation terminée !',
                      style: TextStyle(
                        fontSize: AppSizes.text20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Voici les résultats pour vos scénarios.',
                      style: TextStyle(
                        fontSize: AppSizes.text12,
                        color: AppColors.gray400,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ========================================
                    // SCENARIO RECOMMANDE
                    // ========================================
                    _buildRecommendedScenario(),

                    const SizedBox(height: 18),

                    // ========================================
                    // APERCU DES SCENARIOS
                    // ========================================
                    _buildScenariosPreview(),

                    const SizedBox(height: 18),

                    // ========================================
                    // RECOMMANDATION IA
                    // ========================================
                    _buildAiRecommendation(),

                    const SizedBox(height: 12),

                    // ========================================
                    // BOUTON DETAILS
                    // ========================================
                    _buildDetailsButton(context),

                    const SizedBox(height: 10),

                    // ========================================
                    // EXPORT
                    // ========================================
                    _buildExportButton(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

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
                'Résultats de la simulation',
                style: TextStyle(
                  fontSize: AppSizes.text14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          const Icon(Icons.more_vert, color: AppColors.black),
        ],
      ),
    );
  }

  // =========================================================
  // SCENARIO RECOMMANDE
  // =========================================================

  Widget _buildRecommendedScenario() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.blue, width: 1.2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                'Scénario recommandé',

                style: TextStyle(fontSize: 10, color: AppColors.gray400),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  'Meilleur scénario',

                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                width: 32,
                height: 32,

                decoration: const BoxDecoration(
                  color: Color(0xFFE8F1FF),
                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.star, color: AppColors.blue, size: 18),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Scénario A',

                      style: TextStyle(
                        fontSize: AppSizes.text14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Acquisition clients',

                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                  ],
                ),
              ),

              const Text(
                '92',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              const Text(
                '/100',

                style: TextStyle(fontSize: 10, color: AppColors.gray400),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(),

          const SizedBox(height: 8),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _Metric(value: '125K', label: 'Portée'),

              _Metric(value: '8,4K', label: 'Clics'),

              _Metric(value: '2,1K', label: 'Conv.'),

              _Metric(value: '3,2x', label: 'ROI'),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // APERCU DES SCENARIOS
  // =========================================================

  Widget _buildScenariosPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              'Aperçu des scénarios',

              style: TextStyle(
                fontSize: AppSizes.text14,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),

            Text(
              'Comparer →',

              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _buildScenarioCard(
          name: 'Scénario A',
          score: '92 /100',
          values: const ['125K', '8,4K', '2,1K', '3,2x'],
          progress: 0.92,
          color: AppColors.green,
        ),

        const SizedBox(height: 10),

        _buildScenarioCard(
          name: 'Scénario B',
          score: '78 /100',
          values: const ['83K', '6,1K', '1,6K', '2,4x'],
          progress: 0.78,
          color: AppColors.blue,
        ),

        const SizedBox(height: 10),

        _buildScenarioCard(
          name: 'Scénario C',
          score: '68 /100',
          values: const ['72K', '4,2K', '1,1K', '1,9x'],
          progress: 0.68,
          color: const Color(0xFFFF8A00),
        ),
      ],
    );
  }

  // =========================================================
  // CARTE SCENARIO
  // =========================================================

  Widget _buildScenarioCard({
    required String name,
    required String score,
    required List<String> values,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                name,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              Text(
                'Score $score',

                style: const TextStyle(fontSize: 9, color: AppColors.gray400),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: progress,

            minHeight: 3,

            backgroundColor: const Color(0xFFE9ECEF),

            valueColor: AlwaysStoppedAnimation(color),

            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _Metric(value: values[0], label: 'Portée'),

              _Metric(value: values[1], label: 'Clics'),

              _Metric(value: values[2], label: 'Conv.'),

              _Metric(value: values[3], label: 'ROI'),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RECOMMANDATION IA
  // =========================================================

  Widget _buildAiRecommendation() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.blue),
      ),

      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(Icons.lightbulb_outline, color: AppColors.blue, size: 20),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'Le Scénario A offre le meilleur retour sur investissement pour votre campagne.',

              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOUTON DETAILS
  // =========================================================

  Widget _buildDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,

      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScenarioDetailsScreen()),
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),

        child: const Text(
          'Voir le détails des scénarios',

          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.text14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // EXPORT
  // =========================================================

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,

      child: OutlinedButton.icon(
        onPressed: () {},

        icon: const Icon(Icons.download, size: 17),

        label: const Text('Exporter le rapport'),

        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.green,

          side: const BorderSide(color: AppColors.green),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// WIDGET METRIQUE
// =============================================================

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,

          style: const TextStyle(fontSize: 8, color: AppColors.gray400),
        ),
      ],
    );
  }
}
