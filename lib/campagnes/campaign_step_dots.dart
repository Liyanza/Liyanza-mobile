import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';

// =================================================================
// INDICATEUR D'ÉTAPES (utilisé dans tout le flow "Nouvelle campagne")
// =================================================================
//
// - Les étapes avant `currentStep` sont considérées complétées (rond
//   bleu plein avec une coche).
// - L'étape `currentStep` est le rond bleu plein (sans coche).
// - Les étapes suivantes sont des ronds vides à bordure grise.
// - Le trait entre deux ronds est bleu tant que l'étape de gauche
//   est complétée ou active.

class CampaignStepDots extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CampaignStepDots({
    super.key,
    this.totalSteps = 5,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),

      child: Row(
        children: List.generate(totalSteps * 2 - 1, (i) {
          // Index pair = un rond, index impair = un trait de liaison.
          final bool isDot = i.isEven;

          if (isDot) {
            final int stepIndex = i ~/ 2;
            return _buildDot(stepIndex);
          }

          final int lineIndex = i ~/ 2;
          return _buildLine(lineIndex);
        }),
      ),
    );
  }

  Widget _buildDot(int stepIndex) {
    final bool completed = stepIndex < currentStep;
    final bool active = stepIndex == currentStep;

    if (completed) {
      return Container(
        width: 9,
        height: 9,

        decoration: const BoxDecoration(
          color: AppColors.blue,
          shape: BoxShape.circle,
        ),

        child: const Icon(Icons.check, size: 6, color: AppColors.white),
      );
    }

    if (active) {
      return Container(
        width: 9,
        height: 9,

        decoration: const BoxDecoration(
          color: AppColors.blue,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: 9,
      height: 9,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
      ),
    );
  }

  Widget _buildLine(int lineIndex) {
    final bool active = lineIndex < currentStep;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),

        child: Container(
          height: 1.5,
          color: active ? AppColors.blue : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }
}
