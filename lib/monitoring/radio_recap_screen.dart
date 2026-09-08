import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'radio_step_header.dart';
import 'radio_success_screen.dart';

class RadioRecapScreen extends StatelessWidget {
  const RadioRecapScreen({super.key});

  // ===========================================================
  // DATA (à remplacer par les vraies valeurs collectées durant le flow)
  // ===========================================================

  static final List<_RecapRow> _rows = [
    _RecapRow('Radio', 'Radio Balafon'),
    _RecapRow('Objectif', 'Notoriété'),
    _RecapRow('Budget total', '100 000 FCFA'),
    _RecapRow('Période', '25 mai 2024 – 25 juin 2024'),
    _RecapRow('Spot', 'Promo_Orange_Mai24.mp3 · 30 sec'),
    _RecapRow('Fréquence', '3 diffusions par jour'),
    _RecapRow('Créneaux', '07h00 - 09h00, 12h00 - 14h00, 17h00 - 19h00'),
    _RecapRow('Jours', 'Lun, Mar, Mer, Jeu'),
    _RecapRow('Zone', 'Nationale'),
  ];

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
              step: 5,
              totalSteps: 5,
            ),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Récapitulatif',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildRecapCard(),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOUTON CRÉER LA CAMPAGNE
            // =================================================
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // CARTE RÉCAPITULATIVE
  // ===========================================================

  Widget _buildRecapCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        children: List.generate(_rows.length, (index) {
          final row = _rows[index];
          final bool isLast = index == _rows.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),

            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: Color(0xFFF9FAFB), width: 1.2),
                    ),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  row.label,

                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray400,
                  ),
                ),

                const Spacer(),

                Flexible(
                  child: Text(
                    row.value,

                    textAlign: TextAlign.right,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================
  // BOUTON CRÉER LA CAMPAGNE
  // ===========================================================

  Widget _buildCreateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

      child: SizedBox(
        width: double.infinity,
        height: 53,

        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RadioSuccessScreen()),
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
            'Créer la campagne',

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

// =============================================================
// MODEL
// =============================================================

class _RecapRow {
  final String label;
  final String value;

  _RecapRow(this.label, this.value);
}
