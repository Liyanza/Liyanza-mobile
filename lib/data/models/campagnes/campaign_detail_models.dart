// Données du détail d'une campagne : paramètres digitaux, simulation,
// résultats réels Facebook Ads et conformité des diffusions radio. Mêmes
// routes que la page Résultats du site.

double? _toDoubleOrNull(Object? value) => value is num ? value.toDouble() : null;
double _toDouble(Object? value) => _toDoubleOrNull(value) ?? 0;
List<String> _strings(Object? value) =>
    value is List ? value.map((e) => e.toString()).toList() : const [];

// ===========================================================
// PARAMÈTRES DIGITAUX (GET /campagnes/:id/digital-details)
// ===========================================================

String digitalObjectiveLabel(String objective) => switch (objective) {
      'AWARENESS' => 'Notoriété',
      'ENGAGEMENT' => 'Engagement',
      'TRAFFIC' => 'Trafic',
      'LEADS' => 'Prospects',
      'CONVERSION' => 'Conversions',
      'SALES' => 'Ventes',
      'MESSAGES' => 'Conversations WhatsApp / Messenger',
      _ => objective,
    };

String targetGenderLabel(String gender) => switch (gender) {
      'MALE' => 'Hommes',
      'FEMALE' => 'Femmes',
      _ => 'Tous',
    };

String platformLabel(String platform) => switch (platform) {
      'FACEBOOK' => 'Facebook',
      'INSTAGRAM' => 'Instagram',
      _ => platform,
    };

class DigitalDetailsModel {
  final String objective;
  final String? customObjective;
  final int ageMin;
  final int ageMax;
  final String targetGender;
  final List<String> locations;
  final List<String> interests;

  /// TOTAL ou DAILY.
  final String budgetAllocation;
  final List<String> platforms;

  const DigitalDetailsModel({
    required this.objective,
    this.customObjective,
    required this.ageMin,
    required this.ageMax,
    required this.targetGender,
    required this.locations,
    required this.interests,
    required this.budgetAllocation,
    required this.platforms,
  });

  factory DigitalDetailsModel.fromJson(Map<String, dynamic> json) => DigitalDetailsModel(
        objective: json['objective'] as String,
        customObjective: json['customObjective'] as String?,
        ageMin: (json['ageMin'] as num).toInt(),
        ageMax: (json['ageMax'] as num).toInt(),
        targetGender: json['targetGender'] as String? ?? 'ALL',
        locations: _strings(json['targetLocations']),
        interests: _strings(json['targetInterests']),
        budgetAllocation: json['budgetAllocation'] as String? ?? 'TOTAL',
        platforms: (json['channels'] as List? ?? const [])
            .map((c) => (c as Map<String, dynamic>)['platform'].toString())
            .toList(),
      );
}

// ===========================================================
// SIMULATION (GET /campagnes/:id/simulations-digitales)
// ===========================================================

String scenarioStrategyLabel(String? strategy) => switch (strategy) {
      'balanced' => 'Équilibré',
      'broad' => 'Audience élargie',
      'focused' => 'Ciblage resserré',
      _ => 'Recommandé',
    };

class SimulationSummaryModel {
  final String id;
  final DateTime simulatedAt;
  final double? predictedReach;
  final double? predictedClicks;
  final double? predictedConversions;
  final double? predictedCtr;
  final double? avgCpc;
  final double? costPerAcquisition;

  /// Stratégie du scénario recommandé (balanced, broad, focused).
  final String? recommendedStrategy;

  /// Résumé de l'analyse IA, sinon texte du moteur.
  final String? summary;
  final List<String> warnings;

  const SimulationSummaryModel({
    required this.id,
    required this.simulatedAt,
    this.predictedReach,
    this.predictedClicks,
    this.predictedConversions,
    this.predictedCtr,
    this.avgCpc,
    this.costPerAcquisition,
    this.recommendedStrategy,
    this.summary,
    this.warnings = const [],
  });

  factory SimulationSummaryModel.fromJson(Map<String, dynamic> json) {
    final scenarios = (json['scenarios'] as List? ?? const []).cast<Map<String, dynamic>>();
    final recommended = scenarios.where((s) => s['isRecommended'] == true);
    final scenario = recommended.isNotEmpty ? recommended.first : null;
    final analysis = json['aiAnalysis'];
    final aiSummary = analysis is Map ? analysis['summary'] as String? : null;
    return SimulationSummaryModel(
      id: json['id'] as String,
      simulatedAt: DateTime.parse(json['simulatedAt'] as String),
      predictedReach: _toDoubleOrNull(json['predictedReach']),
      predictedClicks: _toDoubleOrNull(scenario?['predictedClicks']),
      predictedConversions: _toDoubleOrNull(scenario?['predictedConversions']),
      predictedCtr: _toDoubleOrNull(json['predictedCtr']),
      avgCpc: _toDoubleOrNull(json['avgCpc']),
      costPerAcquisition: _toDoubleOrNull(json['costPerAcquisition']),
      recommendedStrategy: scenario?['strategy'] as String?,
      summary: (aiSummary != null && aiSummary.trim().isNotEmpty)
          ? aiSummary
          : json['narrativeSummary'] as String?,
      warnings: _strings(json['warnings']),
    );
  }
}

// ===========================================================
// RÉSULTATS RÉELS (GET /campagnes/:id/performance-reelle)
// ===========================================================

enum MetricStatus { ahead, onTrack, behind, unknown }

MetricStatus _metricStatusFromJson(String? value) => switch (value) {
      'ahead' => MetricStatus.ahead,
      'on_track' => MetricStatus.onTrack,
      'behind' => MetricStatus.behind,
      _ => MetricStatus.unknown,
    };

String metricStatusLabel(MetricStatus status) => switch (status) {
      MetricStatus.ahead => 'Mieux que prévu',
      MetricStatus.onTrack => 'Dans les clous',
      MetricStatus.behind => 'En retard',
      MetricStatus.unknown => '—',
    };

String metricLabel(String key) => switch (key) {
      'reach' => 'Personnes touchées',
      'clicks' => 'Clics',
      'conversions' => 'Résultats',
      'ctr' => 'Taux de clic',
      'cpc' => 'Coût par clic',
      'cpa' => 'Coût par résultat',
      'roas' => 'Retour sur dépense',
      _ => key,
    };

class MetricComparisonModel {
  final String key;

  /// volume, rate ou cost.
  final String kind;
  final double? expected;
  final double? actual;
  final MetricStatus status;

  const MetricComparisonModel({
    required this.key,
    required this.kind,
    this.expected,
    this.actual,
    required this.status,
  });

  factory MetricComparisonModel.fromJson(Map<String, dynamic> json) => MetricComparisonModel(
        key: json['key'] as String,
        kind: json['kind'] as String? ?? 'volume',
        expected: _toDoubleOrNull(json['expected']),
        actual: _toDoubleOrNull(json['actual']),
        status: _metricStatusFromJson(json['status'] as String?),
      );
}

class ActualPerformanceModel {
  final String? metaCampaignName;
  final double? spendXaf;
  final double? spendProgress;
  final double timeProgress;
  final bool tooEarly;
  final List<MetricComparisonModel> metrics;
  final int openAlerts;

  const ActualPerformanceModel({
    this.metaCampaignName,
    this.spendXaf,
    this.spendProgress,
    required this.timeProgress,
    required this.tooEarly,
    required this.metrics,
    required this.openAlerts,
  });

  /// null quand aucune campagne Facebook Ads n'est reliée.
  static ActualPerformanceModel? fromResponse(Map<String, dynamic> json) {
    if (json['linked'] != true) return null;
    final comparison = json['comparison'] as Map<String, dynamic>? ?? const {};
    final link = json['link'] as Map<String, dynamic>? ?? const {};
    return ActualPerformanceModel(
      metaCampaignName: link['metaCampaignName'] as String?,
      spendXaf: _toDoubleOrNull(comparison['spendXaf']),
      spendProgress: _toDoubleOrNull(comparison['spendProgress']),
      timeProgress: _toDouble(comparison['timeProgress']),
      tooEarly: comparison['tooEarly'] == true,
      metrics: (comparison['metrics'] as List? ?? const [])
          .map((m) => MetricComparisonModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      openAlerts: (json['alerts'] as List? ?? const []).length,
    );
  }
}

// ===========================================================
// CONFORMITÉ RADIO (GET /campagnes/:id/rapport-conformite)
// ===========================================================

class ConformityReportModel {
  final int total;
  final int broadcasted;
  final int missed;
  final int pending;
  final int cancelled;

  /// 0 à 1 ; null tant qu'aucune diffusion n'est passée.
  final double? rate;

  const ConformityReportModel({
    required this.total,
    required this.broadcasted,
    required this.missed,
    required this.pending,
    required this.cancelled,
    this.rate,
  });

  factory ConformityReportModel.fromJson(Map<String, dynamic> json) => ConformityReportModel(
        total: (json['totalDiffusions'] as num?)?.toInt() ?? 0,
        broadcasted: (json['diffusionsDiffusees'] as num?)?.toInt() ?? 0,
        missed: (json['diffusionsManquees'] as num?)?.toInt() ?? 0,
        pending: (json['diffusionsEnAttente'] as num?)?.toInt() ?? 0,
        cancelled: (json['diffusionsAnnulees'] as num?)?.toInt() ?? 0,
        rate: _toDoubleOrNull(json['tauxConformite']),
      );
}
