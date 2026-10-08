import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/data/models/auth/auth_models.dart';
import 'package:liyanza_mobile/data/models/campagnes/campagne_models.dart';
import 'package:liyanza_mobile/data/models/dashboard/dashboard_models.dart';
import 'package:liyanza_mobile/features/home/home.dart';

void main() {
  group('formatCompactAmount', () {
    test('abbreviates thousands, millions and billions', () {
      expect(formatCompactAmount(0), '0');
      expect(formatCompactAmount(950), '950');
      expect(formatCompactAmount(82600), '82,6K');
      expect(formatCompactAmount(150000), '150K');
      expect(formatCompactAmount(2450000), '2,45M');
      expect(formatCompactAmount(3000000), '3M');
      expect(formatCompactAmount(1200000000), '1,2Md');
    });
  });

  group('MeModel', () {
    test('greets by first name, else by the email local part', () {
      final named = MeModel.fromJson({
        'userId': 'u1',
        'email': 'awa@kiyanza.com',
        'role': 'ADMIN',
        'companyId': 'c1',
        'firstName': 'Awa',
      });
      expect(named.displayName, 'Awa');
      expect(named.hasCompany, isTrue);
      expect(named.role, UserRole.admin);

      final unnamed = MeModel.fromJson({
        'userId': 'u2',
        'email': 'jean.ndi@kiyanza.com',
        'role': 'COMMUNITY_MANAGER',
        'companyId': null,
      });
      expect(unnamed.displayName, 'jean.ndi');
      expect(unnamed.hasCompany, isFalse);
    });
  });

  test('DashboardSummary reads the /dashboard payload', () {
    final summary = DashboardSummary.fromJson({
      'companyId': 'c1',
      'totalCampaigns': 3,
      'campaignsByStatus': {'IN_PROGRESS': 2, 'DRAFT': 1},
      'totalPlannedBudget': 450000,
      'totalActualBudget': 120000.5,
      'budgetDeviation': 329999.5,
      'complianceRate': 0.75,
      'installationRate': 0,
      'unreadNotifications': 4,
      'campaignsSummary': [
        {'id': 'k1', 'name': 'Promo rentrée', 'status': 'IN_PROGRESS', 'plannedBudget': 150000, 'actualBudget': 90000},
      ],
    });

    expect(summary.countOf(CampaignStatus.inProgress), 2);
    expect(summary.countOf(CampaignStatus.completed), 0);
    expect(summary.totalActualBudget, 120000.5);
    expect(summary.complianceRate, 0.75);
    expect(summary.unreadNotifications, 4);
    expect(summary.campaigns.single.name, 'Promo rentrée');
  });

  test('RecommendationModel tolerates older recommendations without title or category', () {
    final reco = RecommendationModel.fromJson({
      'id': 'r1',
      'content': 'Resserrez le ciblage.',
      'priority': 'HIGH',
      'generatedAt': '2026-10-08T10:00:00.000Z',
      'campaignId': 'k1',
    });
    expect(reco.title, isNull);
    expect(reco.priority, RecommendationPriority.high);
    expect(recommendationCategoryLabel(reco.category), isNull);
    expect(recommendationCategoryLabel('creative'), 'Message et visuels');
  });
}
