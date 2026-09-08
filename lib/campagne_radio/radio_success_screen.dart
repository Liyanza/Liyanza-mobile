import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../monitoring_radio/monitoring_campagne.dart';

class RadioSuccessScreen extends StatelessWidget {
  const RadioSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER (simple, sans bouton retour ni progression)
            // =================================================

            _buildHeader(),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),

                child: Column(
                  children: [
                    _buildSuccessIcon(),

                    const SizedBox(height: 16),

                    const Text(
                      'Campagne radio créée !',

                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Votre campagne est prête et sera diffusée à partir du 25 mai 2024.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.gray500,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildSummaryCard(),
                  ],
                ),
              ),
            ),

            // =================================================
            // ACTIONS
            // =================================================
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.2),
        ),
      ),

      child: const Center(
        child: Text(
          'Nouvelle campagne radio',

          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // ICÔNE DE SUCCÈS
  // ===========================================================

  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,

      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBBF7D0), width: 2.4),
      ),

      child: const Icon(Icons.check, size: 36, color: AppColors.green),
    );
  }

  // ===========================================================
  // CARTE RÉSUMÉ DE LA CAMPAGNE
  // ===========================================================

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Expanded(
                child: Text(
                  'Campagne Radio Mai 2024',

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9C3),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  'Programmée',

                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF854D0E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Radio Balafon',

            style: TextStyle(fontSize: 12.5, color: AppColors.gray500),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [
                    Text(
                      'Budget',

                      style: TextStyle(fontSize: 11, color: AppColors.gray400),
                    ),

                    SizedBox(height: 2),

                    Text(
                      '100 000 FCFA',

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 32, color: const Color(0xFFE5E7EB)),

              const SizedBox(width: 16),

              Expanded(
                flex: 2,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [
                    Text(
                      'Période',

                      style: TextStyle(fontSize: 11, color: AppColors.gray400),
                    ),

                    SizedBox(height: 2),

                    Text(
                      '25 mai 2024 – 25 juin 2024',

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ACTIONS
  // ===========================================================

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 53,

            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MonitoringCampaignScreen(),
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
                'Aller au monitoring',

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 53,

            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MonitoringCampaignScreen(),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gray100,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),

                elevation: 0,
              ),

              child: const Text(
                'Voir la campagne',

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
