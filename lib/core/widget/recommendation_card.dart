import 'package:flutter/material.dart';

import '../../data/models/dashboard/dashboard_models.dart';
import '../theme/kiyanza_colors.dart';

/// Recommandation IA : priorité (liseré et pastille), catégorie, titre, détail.
class RecommendationCard extends StatelessWidget {
  final RecommendationModel reco;

  const RecommendationCard({super.key, required this.reco});

  @override
  Widget build(BuildContext context) {
    final (bar, badgeBg, badgeFg) = switch (reco.priority) {
      RecommendationPriority.high => (const Color(0xFFEF4444), const Color(0x1ADC2626), const Color(0xFFDC2626)),
      RecommendationPriority.medium => (const Color(0xFFFB923C), const Color(0x1AF97316), const Color(0xFFEA580C)),
      RecommendationPriority.low => (const Color(0xFFCBD5E1), AppColors.gray100, AppColors.gray500),
    };
    final category = recommendationCategoryLabel(reco.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: bar,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Badge(text: recommendationPriorityLabel(reco.priority), bg: badgeBg, fg: badgeFg),
                        if (category != null) _Badge(text: category, bg: AppColors.gray100, fg: AppColors.gray600),
                      ],
                    ),
                    if (reco.title != null) ...[
                      const SizedBox(height: 8),
                      Text(reco.title!, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    ],
                    const SizedBox(height: 4),
                    Text(reco.content, style: const TextStyle(fontSize: 12.5, color: AppColors.gray600, height: 1.45)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}
