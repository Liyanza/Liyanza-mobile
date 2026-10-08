import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/campagnes/campagne_detail.dart';
import 'package:liyanza_mobile/data/models/campagnes/campagne_models.dart';
import 'package:liyanza_mobile/data/models/campagnes/campaign_detail_models.dart';

void main() {
  test('actual performance is null when no Facebook Ads campaign is linked', () {
    expect(ActualPerformanceModel.fromResponse({'linked': false}), isNull);
  });

  test('actual performance reads the comparison and open alerts', () {
    final actual = ActualPerformanceModel.fromResponse({
      'linked': true,
      'link': {'metaCampaignId': 'm1', 'metaCampaignName': 'Rentrée FB'},
      'comparison': {
        'spendXaf': 90000,
        'spendProgress': 0.6,
        'timeProgress': 0.4,
        'tooEarly': false,
        'metrics': [
          {'key': 'cpc', 'kind': 'cost', 'expected': 45, 'actual': 300, 'status': 'behind'},
          {'key': 'reach', 'kind': 'volume', 'expected': null, 'actual': 9000, 'status': 'unknown'},
        ],
      },
      'alerts': [
        {'id': 'a1', 'type': 'CPC_HIGH', 'severity': 'CRITICAL', 'data': {}},
      ],
    })!;

    expect(actual.metaCampaignName, 'Rentrée FB');
    expect(actual.spendXaf, 90000);
    expect(actual.openAlerts, 1);
    expect(actual.metrics.first.status, MetricStatus.behind);
    expect(formatMetric(actual.metrics.first.kind, actual.metrics.first.actual), '300 FCFA');
    expect(formatMetric('volume', actual.metrics.last.expected), '—');
  });

  test('simulation summary keeps the recommended scenario and prefers the AI summary', () {
    final sim = SimulationSummaryModel.fromJson({
      'id': 's1',
      'simulatedAt': '2026-10-01T10:00:00.000Z',
      'predictedReach': 4900,
      'predictedCtr': 1.2,
      'avgCpc': 600,
      'costPerAcquisition': 6000,
      'narrativeSummary': 'Texte du moteur.',
      'warnings': ['Budget serré'],
      'scenarios': [
        {'id': 'A', 'strategy': 'balanced', 'isRecommended': false, 'predictedClicks': 90, 'predictedConversions': 8},
        {'id': 'C', 'strategy': 'focused', 'isRecommended': true, 'predictedClicks': 100, 'predictedConversions': 10},
      ],
      'aiAnalysis': {'summary': 'Résumé IA.'},
    });

    expect(sim.recommendedStrategy, 'focused');
    expect(scenarioStrategyLabel(sim.recommendedStrategy), 'Ciblage resserré');
    expect(sim.predictedClicks, 100);
    expect(sim.summary, 'Résumé IA.');
    expect(sim.warnings, ['Budget serré']);
  });

  test('conformity report maps the French field names', () {
    final report = ConformityReportModel.fromJson({
      'totalDiffusions': 10,
      'diffusionsDiffusees': 7,
      'diffusionsManquees': 1,
      'diffusionsEnAttente': 2,
      'diffusionsAnnulees': 0,
      'tauxConformite': 0.875,
    });
    expect(report.broadcasted, 7);
    expect(report.rate, 0.875);
  });

  test('digital details read channels and default gender', () {
    final details = DigitalDetailsModel.fromJson({
      'objective': 'MESSAGES',
      'ageMin': 25,
      'ageMax': 45,
      'targetLocations': ['Douala'],
      'targetInterests': [],
      'budgetAllocation': 'DAILY',
      'channels': [
        {'platform': 'FACEBOOK', 'socialAccountId': null},
      ],
    });
    expect(digitalObjectiveLabel(details.objective), 'Conversations WhatsApp / Messenger');
    expect(targetGenderLabel(details.targetGender), 'Tous');
    expect(details.platforms, ['FACEBOOK']);
  });

  test('lifecycle offers the next step only while a campaign can move forward', () {
    expect(nextTransition(CampaignStatus.draft)!.$1, CampaignStatus.planned);
    expect(nextTransition(CampaignStatus.planned)!.$1, CampaignStatus.inProgress);
    expect(nextTransition(CampaignStatus.inProgress)!.$1, CampaignStatus.completed);
    expect(nextTransition(CampaignStatus.completed), isNull);
    expect(nextTransition(CampaignStatus.cancelled), isNull);
  });

  test('formatInt groups thousands with narrow spaces', () {
    expect(formatInt(1234567.8), '1 234 568');
    expect(formatInt(950), '950');
  });
}
