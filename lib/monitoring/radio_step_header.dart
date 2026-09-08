import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';

// =================================================================
// EN-TÊTE D'ÉTAPE (flow "Nouvelle campagne radio")
// =================================================================
//
// Diffère du CampaignStepDots utilisé par le flow digital : ici on a
// un badge "X/5" et une barre de progression continue plutôt que des
// ronds espacés.

class RadioStepHeader extends StatelessWidget {
  final String title;
  final int step; // 1-indexed
  final int totalSteps;
  final VoidCallback? onBack;

  const RadioStepHeader({
    super.key,
    required this.title,
    required this.step,
    this.totalSteps = 5,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = step / totalSteps;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          child: Row(
            children: [
              GestureDetector(
                onTap: onBack ?? () => Navigator.pop(context),

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

              Expanded(
                child: Center(
                  child: Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  '$step/$totalSteps',

                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.gray100,
              valueColor: const AlwaysStoppedAnimation(AppColors.green),
            ),
          ),
        ),
      ],
    );
  }
}
