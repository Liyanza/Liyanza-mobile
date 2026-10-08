import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart'; // apiClientProvider
import 'campagne_providers.dart';
import 'dashboard_providers.dart';
import '../../data/datasources/campaign_detail_remote_datasource.dart';
import '../../data/models/campagnes/campagne_models.dart';
import '../../data/models/campagnes/campaign_detail_models.dart';
import '../../data/models/dashboard/dashboard_models.dart';

final campaignDetailRemoteDatasourceProvider = Provider(
  (ref) => CampaignDetailRemoteDatasource(ref.read(apiClientProvider).dio),
);

class CampaignDetailData {
  final CampagneModel campaign;
  final bool canManage;
  final DigitalDetailsModel? digital;
  final SimulationSummaryModel? simulation;
  final ActualPerformanceModel? actual;
  final ConformityReportModel? conformity;

  /// null quand le rôle n'a pas accès aux recommandations.
  final List<RecommendationModel>? recommendations;

  const CampaignDetailData({
    required this.campaign,
    required this.canManage,
    this.digital,
    this.simulation,
    this.actual,
    this.conformity,
    this.recommendations,
  });
}

/// Ignore l'échec d'un bloc secondaire : le détail reste utilisable.
Future<T?> _optional<T>(Future<T?> future) async {
  try {
    return await future;
  } catch (_) {
    return null;
  }
}

final campaignDetailProvider =
    FutureProvider.autoDispose.family<CampaignDetailData, String>((ref, campaignId) async {
  final detail = ref.read(campaignDetailRemoteDatasourceProvider);
  final me = await ref.watch(meProvider.future);
  final campaign = await ref.read(campagneRepositoryProvider).getById(campaignId);
  final canManage = canSeeRecommendations(me.role);

  final isDigital = campaign.type == CampaignType.digital;
  final results = await Future.wait<Object?>([
    isDigital ? _optional(detail.digitalDetails(campaignId)) : Future.value(null),
    isDigital ? _optional(detail.latestSimulation(campaignId)) : Future.value(null),
    isDigital ? _optional(detail.actualPerformance(campaignId)) : Future.value(null),
    campaign.type == CampaignType.radio
        ? _optional(detail.conformityReport(campaignId))
        : Future.value(null),
    canManage
        ? _optional(ref.read(dashboardRemoteDatasourceProvider).recommendations(campaignId))
        : Future.value(null),
  ]);

  return CampaignDetailData(
    campaign: campaign,
    canManage: canManage,
    digital: results[0] as DigitalDetailsModel?,
    simulation: results[1] as SimulationSummaryModel?,
    actual: results[2] as ActualPerformanceModel?,
    conformity: results[3] as ConformityReportModel?,
    recommendations: canManage ? (results[4] as List<RecommendationModel>? ?? const []) : null,
  );
});
