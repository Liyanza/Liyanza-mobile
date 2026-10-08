import '../auth/auth_models.dart';
import '../campagnes/campagne_models.dart';

double _toDouble(Object? value) => value is num ? value.toDouble() : 0;

// ===========================================================
// UTILISATEUR CONNECTÉ (GET /auth/me)
// ===========================================================

class MeModel {
  final String userId;
  final String email;
  final UserRole role;
  final String? companyId;
  final String? firstName;
  final String? lastName;

  const MeModel({
    required this.userId,
    required this.email,
    required this.role,
    this.companyId,
    this.firstName,
    this.lastName,
  });

  bool get hasCompany => companyId != null;

  /// Prénom pour la salutation, sinon la partie locale de l'email.
  String get displayName {
    final name = firstName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return email.split('@').first;
  }

  factory MeModel.fromJson(Map<String, dynamic> json) => MeModel(
        userId: json['userId'] as String,
        email: json['email'] as String,
        role: userRoleFromJson(json['role'] as String),
        companyId: json['companyId'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
      );
}

// ===========================================================
// RÉSUMÉ DU TABLEAU DE BORD (GET /dashboard)
// ===========================================================

class DashboardCampaignSummary {
  final String id;
  final String name;
  final CampaignStatus status;
  final double plannedBudget;
  final double actualBudget;

  const DashboardCampaignSummary({
    required this.id,
    required this.name,
    required this.status,
    required this.plannedBudget,
    required this.actualBudget,
  });

  factory DashboardCampaignSummary.fromJson(Map<String, dynamic> json) => DashboardCampaignSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        status: campaignStatusFromJson(json['status'] as String),
        plannedBudget: _toDouble(json['plannedBudget']),
        actualBudget: _toDouble(json['actualBudget']),
      );
}

class DashboardSummary {
  final int totalCampaigns;
  final Map<CampaignStatus, int> campaignsByStatus;
  final double totalPlannedBudget;
  final double totalActualBudget;

  /// Diffusions radio réellement passées / prévues (0 à 1).
  final double complianceRate;
  final int unreadNotifications;
  final List<DashboardCampaignSummary> campaigns;

  const DashboardSummary({
    required this.totalCampaigns,
    required this.campaignsByStatus,
    required this.totalPlannedBudget,
    required this.totalActualBudget,
    required this.complianceRate,
    required this.unreadNotifications,
    required this.campaigns,
  });

  int countOf(CampaignStatus status) => campaignsByStatus[status] ?? 0;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    final byStatus = <CampaignStatus, int>{};
    final rawByStatus = json['campaignsByStatus'];
    if (rawByStatus is Map) {
      rawByStatus.forEach((key, value) {
        byStatus[campaignStatusFromJson(key as String)] = (value as num).toInt();
      });
    }
    return DashboardSummary(
      totalCampaigns: (json['totalCampaigns'] as num?)?.toInt() ?? 0,
      campaignsByStatus: byStatus,
      totalPlannedBudget: _toDouble(json['totalPlannedBudget']),
      totalActualBudget: _toDouble(json['totalActualBudget']),
      complianceRate: _toDouble(json['complianceRate']),
      unreadNotifications: (json['unreadNotifications'] as num?)?.toInt() ?? 0,
      campaigns: (json['campaignsSummary'] as List? ?? const [])
          .map((c) => DashboardCampaignSummary.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ===========================================================
// RECOMMANDATION IA (GET /campagnes/:id/recommandations)
// ===========================================================

enum RecommendationPriority { high, medium, low }

RecommendationPriority recommendationPriorityFromJson(String value) =>
    switch (value.toLowerCase()) {
      'high' => RecommendationPriority.high,
      'low' => RecommendationPriority.low,
      _ => RecommendationPriority.medium,
    };

String recommendationPriorityLabel(RecommendationPriority priority) => switch (priority) {
      RecommendationPriority.high => 'Priorité haute',
      RecommendationPriority.medium => 'Priorité moyenne',
      RecommendationPriority.low => 'Priorité basse',
    };

/// Catégories renvoyées par l'IA (budget, audience, creative…).
String? recommendationCategoryLabel(String? category) => switch (category) {
      'budget' => 'Budget',
      'audience' => 'Audience',
      'creative' => 'Message et visuels',
      'channel' => 'Canaux',
      'timing' => 'Calendrier',
      'field' => 'Terrain',
      'radio' => 'Radio',
      'measurement' => 'Suivi des résultats',
      _ => null,
    };

class RecommendationModel {
  final String id;

  /// L'action en quelques mots (null pour les recommandations anciennes).
  final String? title;
  final String content;
  final RecommendationPriority priority;
  final String? category;
  final DateTime generatedAt;
  final String campaignId;

  const RecommendationModel({
    required this.id,
    this.title,
    required this.content,
    required this.priority,
    this.category,
    required this.generatedAt,
    required this.campaignId,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) => RecommendationModel(
        id: json['id'] as String,
        title: json['title'] as String?,
        content: json['content'] as String,
        priority: recommendationPriorityFromJson(json['priority'] as String? ?? 'medium'),
        category: json['category'] as String?,
        generatedAt: DateTime.parse(json['generatedAt'] as String),
        campaignId: json['campaignId'] as String,
      );
}
