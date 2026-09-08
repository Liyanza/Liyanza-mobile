import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  double _progress = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (_progress < 100) {
          _progress += 1;
        } else {
          _timer?.cancel();

          // Plus tard :
          // Navigation vers l'écran de résultat
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ============================================
            // HEADER
            // ============================================

            _buildHeader(context),

            // ============================================
            // CONTENU
            // ============================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),

                child: Column(
                  children: [
                    const Spacer(),

                    // ======================================
                    // TITRE
                    // ======================================
                    const Text(
                      'Nous analysons et simulons\nvos scénarios...',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: AppSizes.text20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Notre IA compare les performances prévisionnelles\npour vous proposer la meilleure stratégie.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: AppSizes.text12,
                        color: AppColors.gray400,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ======================================
                    // PROGRESSION CIRCULAIRE
                    // ======================================
                    _buildProgressCircle(),

                    const SizedBox(height: 32),

                    // ======================================
                    // ETAPES
                    // ======================================
                    _buildAnalysisSteps(),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // HEADER
  // ======================================================

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
                'Simulation',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          // Pour équilibrer le titre
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  // ======================================================
  // CERCLE DE PROGRESSION
  // ======================================================

  Widget _buildProgressCircle() {
    return SizedBox(
      width: 100,
      height: 100,

      child: Stack(
        alignment: Alignment.center,

        children: [
          SizedBox(
            width: 90,
            height: 90,

            child: CircularProgressIndicator(
              value: _progress / 100,

              strokeWidth: 9,

              backgroundColor: const Color(0xFFF1F1F1),

              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1F2937),
              ),

              strokeCap: StrokeCap.round,
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                '${_progress.toInt()}%',

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Analyse en cours',

                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ======================================================
  // ETAPES DE L'ANALYSE
  // ======================================================

  Widget _buildAnalysisSteps() {
    return Column(
      children: [
        _buildStep(
          title: 'Analyse de l’audience',
          isCompleted: _progress >= 25,
        ),

        const SizedBox(height: 12),

        _buildStep(
          title: 'Performance par canal',
          isCompleted: _progress >= 50,
        ),

        const SizedBox(height: 12),

        _buildStep(
          title: 'Optimisation du budget',
          isCompleted: _progress >= 75,
        ),

        const SizedBox(height: 12),

        _buildStep(title: 'Recommandations IA', isCompleted: _progress >= 100),
      ],
    );
  }

  // ======================================================
  // UNE ETAPE
  // ======================================================

  Widget _buildStep({required String title, required bool isCompleted}) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          width: 16,
          height: 16,

          decoration: BoxDecoration(
            color: isCompleted ? AppColors.green : const Color(0xFFF1F3F5),

            shape: BoxShape.circle,

            border: Border.all(
              color: isCompleted ? AppColors.green : const Color(0xFFDDE1E6),
            ),
          ),

          child: isCompleted
              ? const Icon(Icons.check, size: 10, color: Colors.white)
              : null,
        ),

        const SizedBox(width: 10),

        Text(
          title,

          style: TextStyle(
            fontSize: AppSizes.text12,

            color: isCompleted ? AppColors.black : AppColors.gray400,

            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
